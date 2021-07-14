//
//  VGSSubmitButton.swift
//  VGSCheckout
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif

/// Delegate for submit button status changes.
internal protocol VGSSubmitButtonDelegateProtocol: AnyObject {

	/// Notify delegate that button status was changed.
	func statusDidChange(in button: VGSSubmitButton)
}

/// Control for payment submit button.
internal class VGSSubmitButton: UIControl {

	/// Defines submit control state.
	enum SubmitState {
		case disabled
		case enabled
		case processing
		case success
	}

	// MARK: - Vars

	enum LeftIconAccessory {
		case none
		case loader
		case lockImage
	}
  
  weak var delegate: VGSSubmitButtonDelegateProtocol?
  
	/// Current icon accessory style.
	internal var iconAccessory: LeftIconAccessory = .lockImage {
		didSet {
			switch iconAccessory {
			case .none:
				accessoryContainerView.isHidden = true
			case .loader:
				accessoryContainerView.isHidden = false
				progressView.isHidden = false
				progressView.beginProgress()
				lockImageView.isHidden = true
			case .lockImage:
				accessoryContainerView.isHidden = false
				progressView.isHidden = true
				activityIndicatorView.stopAnimating()
				lockImageView.isHidden = false
			}
		}
	}

	/// Lock icon image view.
	internal lazy var lockImageView: UIImageView = {
		let imageView = UIImageView(frame: .zero)
		imageView.contentMode = .scaleAspectFit
		imageView.translatesAutoresizingMaskIntoConstraints = false
		if #available(iOS 11.0, *) {
			imageView.adjustsImageSizeForAccessibilityContentSizeCategory = true
		} else {
			// Fallback on earlier versions
		}
		imageView.image = UIImage(named: "submit_button_lock", in: BundleUtils.shared.resourcesBundle, compatibleWith: nil)

		return imageView
	}()

	internal lazy var accessoryContainerView: UIView = {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false

		//view.backgroundColor = .orange
		view.widthAnchor.constraint(equalToConstant: 20).isActive = true
		view.addSubview(lockImageView)
		lockImageView.checkout_constraintViewToSuperviewEdges()
		view.addSubview(progressView)
		progressView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
		progressView.heightAnchor.constraint(equalToConstant: 20).isActive = true
		progressView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		progressView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

		return view
	}()

	/// Stack view.
	internal lazy var stackView: UIStackView = {
		let stackView = UIStackView()

		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.axis = .horizontal
		stackView.alignment = .center
		stackView.distribution = .fill
		stackView.spacing = 8

		return stackView
	}()

	/// Control title.
	lazy var titleLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.text = "PAY"
		return label
	}()

	/// Activity indicator.
	private lazy var activityIndicatorView: UIActivityIndicatorView = {
		let activityIndicatorView = UIActivityIndicatorView(style: .white)
		//			activityIndicatorView.color = titleLabel.textColor
		activityIndicatorView.backgroundColor = .clear
		activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
		activityIndicatorView.hidesWhenStopped = true

		return activityIndicatorView
	}()

	private lazy var progressView: VGSProgressView = {
		let view = VGSProgressView(frame: CGRect(origin: .zero, size: CGSize(width: 20, height: 20)))
		view.translatesAutoresizingMaskIntoConstraints = false

		return view
	}()

	/// Title string.
	internal var title: String? {
		didSet {
			titleLabel.text = title
		}
	}

	/// Control status.
	internal var status: SubmitState = .disabled {
		didSet {
			delegate?.statusDidChange(in: self)
		}
	}

	// MARK: - Initialization

	override init(frame: CGRect) {
		super.init(frame: frame)

		setupUI()
	}

	required init?(coder: NSCoder) {
		fatalError("Not implemented")
	}

	// MARK: - Helpers

	/// Setup UI.
	fileprivate func setupUI() {
		addSubview(stackView)
		stackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
		stackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
		stackView.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true

		// Allow the subviews simply passes the event through.
		stackView.isUserInteractionEnabled = false

		let leftPadding = UIView()
		let rightPadding = UIView()

		stackView.addArrangedSubview(leftPadding)
		// Some issue with constraints here.
		stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true

		stackView.addArrangedSubview(accessoryContainerView)
		//		stackView.addArrangedSubview(activityIndicatorView)
		stackView.addArrangedSubview(titleLabel)

		stackView.addArrangedSubview(rightPadding)

		leftPadding.widthAnchor.constraint(equalTo: rightPadding.widthAnchor).isActive = true
	}

	/// Update UI.
  internal func updateUI(with uiTheme: VGSCheckoutSubmitButtonThemeProtocol) {

    layer.cornerRadius = 6.0
		layer.masksToBounds = true

		switch status {
		case .disabled:
			isUserInteractionEnabled = false
			backgroundColor =
        uiTheme.checkoutSubmitButtonBackgroundColor
      titleLabel.font = uiTheme.checkoutSubmitButtonTitleFont
      titleLabel.textColor = uiTheme.checkoutSubmitButtonTitleColor
			titleLabel.text = VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: "vgs_checkout_pay_button_title")
      lockImageView.alpha = 0.6
			titleLabel.textAlignment = .center
			activityIndicatorView.stopAnimating()
			iconAccessory = .lockImage
		case .enabled:
			isUserInteractionEnabled = true
			backgroundColor =
        uiTheme.checkoutSubmitButtonBackgroundColor
			titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
			titleLabel.textColor = UIColor.white
			titleLabel.text = VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: "vgs_checkout_pay_button_title")
			titleLabel.textAlignment = .center
			lockImageView.alpha = 1
			activityIndicatorView.stopAnimating()
			iconAccessory = .lockImage
		case .processing:
			isUserInteractionEnabled = false
			backgroundColor =
        uiTheme.checkoutSubmitButtonBackgroundColor
			titleLabel.font = uiTheme.checkoutSubmitButtonTitleFont
      titleLabel.textColor = uiTheme.checkoutSubmitButtonTitleColor
			titleLabel.text = VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: "vgs_checkout_pay_button_processing_title")
			titleLabel.textAlignment = .center
			activityIndicatorView.startAnimating()
			iconAccessory = .loader
		case .success:

			self.progressView.endProgress()
			self.iconAccessory = .none
			UIView.animate(withDuration: 0.3, delay: 0, options: []) {
				self.titleLabel.text = "Success"
        self.backgroundColor = uiTheme.checkoutSubmitButtonSuccessBackgroundColor
				self.titleLabel.textColor = UIColor.white
				self.titleLabel.font = UIFont.preferredFont(forTextStyle: .title3)
			} completion: { isFinished in
				//self.checkmarkIndicatorView.completeProgress()
			}
		}
	}
}

/// Progress view.
internal class VGSProgressView: UIView {

	// MARK: - Vars

	/// Circle layer
	internal let progressLayer = CAShapeLayer()

	/// Animation duration.
	private let animationDuration = 0.32

	// MARK: - Initialization

	/// no:doc
	override init(frame: CGRect) {
		let originX = frame.size.width / 2
		let originY = frame.size.width / 2

		let circlePath = UIBezierPath(
			arcCenter: CGPoint(
				x: originX,
				y: originY),
			radius: (frame.size.width) / 2,
			startAngle: 0.0,
			endAngle: CGFloat.pi * 2,
			clockwise: false)

		progressLayer.bounds = CGRect(
			x: 0, y: 0, width: frame.size.width, height: frame.size.width)
		progressLayer.path = circlePath.cgPath

		progressLayer.fillColor = UIColor.clear.cgColor
		progressLayer.strokeColor = UIColor.white.cgColor
		progressLayer.lineCap = .round

		progressLayer.lineWidth = 1.0
		progressLayer.strokeEnd = 0.0

		progressLayer.position = CGPoint(x: frame.width / 2, y: frame.height / 2)

		super.init(frame: frame)

		self.backgroundColor = UIColor.clear
		layer.addSublayer(progressLayer)
	}

	/// no:doc
	internal required init?(coder: NSCoder) {
		fatalError("not implemented")
	}

	// MARK: - Interface

	/// Start animation progress.
	internal func beginProgress() {
		let strokeAnimation = CABasicAnimation(keyPath: "strokeEnd")
		strokeAnimation.duration = 1.0
		strokeAnimation.fromValue = 0
		strokeAnimation.toValue = 0.6
		strokeAnimation.timingFunction = CAMediaTimingFunction(
			name: CAMediaTimingFunctionName.easeOut)

		progressLayer.strokeEnd = 0.6
		progressLayer.add(strokeAnimation, forKey: "animateCircle")
		let progressAnimation = CABasicAnimation(keyPath: "transform.rotation")
		progressAnimation.byValue = 2.0 * Float.pi
		progressAnimation.duration = 1
		progressAnimation.repeatCount = .infinity
		progressLayer.add(progressAnimation, forKey: "animateRotate")
	}

	/// End progress.
	internal func endProgress() {
		progressLayer.removeAnimation(forKey: "animateCircle")

		// Close the circle
		let endProgressAnimation = CABasicAnimation(keyPath: "strokeEnd")
		endProgressAnimation.duration = animationDuration
		endProgressAnimation.fromValue = 0.6
		endProgressAnimation.toValue = 1
		endProgressAnimation.timingFunction = CAMediaTimingFunction(
			name: CAMediaTimingFunctionName.easeInEaseOut)

		progressLayer.strokeEnd = 1.0
		progressLayer.add(endProgressAnimation, forKey: "animateDone")
	}
}
