//
//  APIClient.swift
//  VGSCheckoutSDK
//

import Foundation

internal class APIClient {

	/// Additional custom headers.
	var customHeader: HTTPHeaders?

  /// Vault Id.
	private let vaultId: String

	/// Vault URL.
	private let vaultUrl: URL?

	/// Form analytics details.
	private (set) internal var formAnalyticDetails: VGSCheckoutFormAnanlyticsDetails

	/// Base URL.
	internal var baseURL: URL? {
		return self.hostURLPolicy.url
	}

	/// URL session object with `.ephemeral` configuration.
	internal let urlSession = URLSession(configuration: .ephemeral)

	/// Host URL policy. Determinates final URL to send Collect requests.
	internal var hostURLPolicy: APIHostURLPolicy

	/// Serial queue for syncing requests on resolving hostname flow.
	private let dataSyncQueue: DispatchQueue = .init(label: "iOS.VGSCheckout.ResolveHostNameRequestsQueue")

	/// Semaphore for sync logic.
	private let syncSemaphore: DispatchSemaphore = {
		// DispatchSemaphore checks to see whether the semaphore’s associated value is less at deinit than at init, and if so, it fails. In short, if the value is less, libDispatch concludes that the semaphore is still being used.
		// https://stackoverflow.com/a/70458886

		// Semantically the same as DispatchSemaphore(value: 1) but does not crash on deinit/dealloc if its current value != 1.
		// See https://lists.apple.com/archives/cocoa-dev/2014/Apr/msg00484.html.
		let semaphore = DispatchSemaphore(value: 0)
		semaphore.signal()
		return semaphore
	}()

	/// Default headers.
	internal static let defaultHttpHeaders: HTTPHeaders = {
		// Add Headers.
		let version = ProcessInfo.processInfo.operatingSystemVersion
		let versionString = "\(version.majorVersion).\(version.minorVersion).\(version.patchVersion)"

		let trStatus = VGSCheckoutAnalyticsClient.shared.shouldCollectAnalytics ? "default" : "none"

		return [
			"vgs-client": "source=checkout-ios&medium=vgs-checkout&content=\(Utils.vgsCheckoutVersion)&osVersion=\(versionString)&vgsCheckoutSessionId=\(VGSCheckoutAnalyticsClient.shared.vgsCheckoutSessionId)&tr=\(trStatus)"
		]
	}()

	/// Initialization.
	/// - Parameters:
	///   - tenantId: `String` object, should be valid tenant id.
	///   - regionalEnvironment: `String` object, should be valid environment.
  ///   - routeId:  `String?` object, should be valid route id or `nil`.
	///   - hostname: `String?` object, should be valid hostname or `nil`.
	///   - formAnalyticsDetails: `VGSFormAnanlyticsDetails` object, analytics data.
	///   - satellitePort: `Int?` object, custom port for satellite configuration. **IMPORTANT! Use only with .sandbox environment!**.
  required init(tenantId: String, regionalEnvironment: String, routeId: String?, hostname: String?, formAnalyticsDetails: VGSCheckoutFormAnanlyticsDetails, satellitePort: Int?) {
    self.vaultUrl = APIClient.buildVaultURL(tenantId: tenantId, regionalEnvironment: regionalEnvironment, routeId: routeId)

		self.vaultId = tenantId
		self.formAnalyticDetails = formAnalyticsDetails

		guard let validVaultURL = vaultUrl else {
			// Cannot resolve hostname with invalid Vault URL.
			self.hostURLPolicy = .invalidVaultURL
			return
		}

		// Check satellite port is *nil* for regular API flow.
		guard satellitePort == nil else {
			// Try to build satellite URL.
			guard let port = satellitePort, let satelliteURL = VGSCollectSatelliteUtils.buildSatelliteURL(with: regionalEnvironment, hostname: hostname, satellitePort: port) else {

				// Use vault URL as fallback if cannot resolve satellite flow.
				self.hostURLPolicy = .vaultURL(validVaultURL)
				return
			}

			// Use satellite URL and return.
			self.formAnalyticDetails.isSatelliteMode = true
			self.hostURLPolicy = .satelliteURL(satelliteURL)

			let message = "Satellite has been configured successfully! Satellite URL is: \(satelliteURL.absoluteString)"
			let event = VGSLogEvent(level: .info, text: message)
			VGSCheckoutLogger.shared.forwardLogEvent(event)

			return
		}

		guard let hostnameToResolve = hostname, !hostnameToResolve.isEmpty else {

			if let name = hostname, name.isEmpty {
				let message = "Hostname is invalid (empty) and will be ignored. Default Vault URL will be used."
				let event = VGSLogEvent(level: .warning, text: message, severityLevel: .error)
				VGSCheckoutLogger.shared.forwardLogEvent(event)
			}

			// Use vault URL.
			self.hostURLPolicy = .vaultURL(validVaultURL)
			return
		}

		self.hostURLPolicy = .customHostURL(.isResolving(hostnameToResolve))
		updateHost(with: hostnameToResolve)
	}

	// MARK: - Send request

	func sendRequest(path: String, method: HTTPMethod = .post, value: BodyData?, completion block: ((_ response: VGSResponse) -> Void)? ) {

		let sendRequestBlock: (URL?) -> Void = {url in
			guard let requestURL = url else {
				let message = "CONFIGURATION ERROR: NOT VALID ORGANIZATION PARAMETERS!!! CANNOT BUILD URL!!!"
				let event = VGSLogEvent(level: .warning, text: message, severityLevel: .error)
				VGSCheckoutLogger.shared.forwardLogEvent(event)

				let invalidURLError = VGSError(type: .invalidConfigurationURL)
				block?(.failure(invalidURLError.code, nil, nil, invalidURLError))
				return
			}

			let url = requestURL.appendingPathComponent(path)
			self.sendRequest(to: url, method: method, value: value, completion: block)
		}

		switch hostURLPolicy {
		case .invalidVaultURL:
			sendRequestBlock(nil)
		case .vaultURL(let url):
			sendRequestBlock(url)
		case .satelliteURL(let url):
			sendRequestBlock(url)
		case .customHostURL(let status):
			switch status {
			case .resolved(let resolvedURL):
				sendRequestBlock(resolvedURL)
			case .useDefaultVault(let defaultVaultURL):
				sendRequestBlock(defaultVaultURL)
			case .isResolving(let hostnameToResolve):
				updateHost(with: hostnameToResolve) { (url) in
					sendRequestBlock(url)
				}
			}
		}
	}

	private  func sendRequest(to url: URL, method: HTTPMethod = .post, value: BodyData?, completion block: ((_ response: VGSResponse) -> Void)? ) {

		// Add headers.
		var headers = APIClient.defaultHttpHeaders
		headers["Content-Type"] = "application/json"
		// Add custom headers if needed.
		if let customerHeaders = customHeader, customerHeaders.count > 0 {
			customerHeaders.keys.forEach({ (key) in
				headers[key] = customerHeaders[key]
			})
		}
		// Setup URLRequest.
		var request = URLRequest(url: url)
		if let data = value {
			let jsonData = try? JSONSerialization.data(withJSONObject: data)
			request.httpBody = jsonData
		}
		request.httpMethod = method.rawValue
		request.allHTTPHeaderFields = headers

		// Log request.
		VGSNetworkRequestLogger.logRequest(request, payload: value)

		// Send data.
		urlSession.dataTask(with: request) { (data, response, error) in
			DispatchQueue.main.async {
				if let error = error as NSError? {
					VGSNetworkRequestLogger.logErrorResponse(response, data: data, error: error, code: error.code)
					block?(.failure(error.code, data, response, error))
					return
				}
				let statusCode = (response as? HTTPURLResponse)?.statusCode ?? VGSErrorType.unexpectedResponseType.rawValue

				switch statusCode {
				case 200..<300:
					VGSNetworkRequestLogger.logSuccessResponse(response, data: data, code: statusCode)
					block?(.success(statusCode, data, response))
					return
				default:
					VGSNetworkRequestLogger.logErrorResponse(response, data: data, error: error, code: statusCode)
					block?(.failure(statusCode, data, response, error))
					return
				}
			}
		}.resume()
	}
}

extension APIClient {

	// MARK: - Custom Host Name

	private func updateHost(with hostname: String, completion: ((URL) -> Void)? = nil) {

		dataSyncQueue.async {[weak self] in
			guard let strongSelf = self else {return}

			// Enter sync zone.
			strongSelf.syncSemaphore.wait()

			// Check if we already have URL. If yes, don't fetch it the same time.
			if let url = strongSelf.hostURLPolicy.url {
				completion?(url)
				// Quite sync zone.
				strongSelf.syncSemaphore.signal()
				return
			}

			// Resolve hostname.
			APIHostnameValidator.validateCustomHostname(hostname, tenantId: strongSelf.vaultId, formAnalyticDetails: strongSelf.formAnalyticDetails) {[weak self](url) in
				if var validUrl = url {

					// Update url scheme if needed.
					if !validUrl.hasSecureScheme(), let secureURL = URL.urlWithSecureScheme(from: validUrl) {
						validUrl = secureURL
					}

					self?.hostURLPolicy = .customHostURL(.resolved(validUrl))
					completion?(validUrl)

					// Exit sync zone.
					self?.syncSemaphore.signal()
					if let strongSelf = self {

						let text = "✅ Success! VGSCheckout hostname \(hostname) has been successfully resolved and will be used for requests!"
						let event = VGSLogEvent(level: .info, text: text)
						VGSCheckoutLogger.shared.forwardLogEvent(event)

						VGSCheckoutAnalyticsClient.shared.trackFormEvent(strongSelf.formAnalyticDetails, type: .hostnameValidation, status: .success, extraData: ["hostname": hostname])
					}
					return
				} else {
					guard let strongSelf = self, let validVaultURL = self?.vaultUrl else {
						let text = "No VGSCheckout instance or any valid url"
						let event = VGSLogEvent(level: .warning, text: text, severityLevel: .error)
						VGSCheckoutLogger.shared.forwardLogEvent(event)
						return
					}

					strongSelf.hostURLPolicy = .customHostURL(.useDefaultVault(validVaultURL))
					completion?(validVaultURL)

					// Exit sync zone.
					strongSelf.syncSemaphore.signal()

					let text = "VAULT URL WILL BE USED!"
					let event = VGSLogEvent(level: .warning, text: text, severityLevel: .error)
					VGSCheckoutLogger.shared.forwardLogEvent(event)

					VGSCheckoutAnalyticsClient.shared.trackFormEvent(strongSelf.formAnalyticDetails, type: .hostnameValidation, status: .failed, extraData: ["hostname": hostname])
					return
				}
			}
		}
	}
}
