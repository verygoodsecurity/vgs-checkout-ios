//
//  VGSSubmitButton.swift
//  VGSCheckout
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif

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

	/// Current icon accessory style.
	internal var iconAccessory: LeftIconAccessory = .lockImage {
		didSet {
			switch iconAccessory {
			case .none:
				accessoryContainerView.isHidden = true
			case .loader:
				accessoryContainerView.isHidden = false
				checkmarkIndicatorView.isHidden = false
				checkmarkIndicatorView.beginProgress()
				lockImageView.isHidden = true
			case .lockImage:
				accessoryContainerView.isHidden = false
				checkmarkIndicatorView.isHidden = true
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
		view.addSubview(checkmarkIndicatorView)
		checkmarkIndicatorView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
		checkmarkIndicatorView.heightAnchor.constraint(equalToConstant: 20).isActive = true
		checkmarkIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		checkmarkIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

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
		//label.backgroundColor = .yellow

		label.font = UIFont.preferredFont(forTextStyle: .callout)
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

	private lazy var checkmarkIndicatorView: CheckProgressView = {
		let view = CheckProgressView(frame: CGRect(origin: .zero, size: CGSize(width: 20, height: 20)))
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
			updateUI()
		}
	}

	// MARK: - Initialization

	override init(frame: CGRect) {
		super.init(frame: frame)

		setupUI()

		updateUI()
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
	fileprivate func updateUI() {
		let theme = VGSCheckoutTheme.CardPaymentTheme.PaymentButton.self

		layer.cornerRadius = theme.cornerRadius
		layer.masksToBounds = true

		switch status {
		case .disabled:
			isUserInteractionEnabled = false
			backgroundColor =
				theme.backgroundColor.withAlphaComponent(theme.opacity)
			titleLabel.font = UIFont.preferredFont(forTextStyle: .callout)
			titleLabel.textColor = UIColor.white.withAlphaComponent(theme.titleOpacity)
			titleLabel.text = "Pay"
			lockImageView.alpha = theme.titleOpacity
			titleLabel.textAlignment = .center
			activityIndicatorView.stopAnimating()
			iconAccessory = .lockImage
		case .enabled:
			isUserInteractionEnabled = true
			backgroundColor =
				theme.backgroundColor
			titleLabel.font = UIFont.preferredFont(forTextStyle: .callout)
			titleLabel.textColor = UIColor.white
			titleLabel.text = "Pay"
			titleLabel.textAlignment = .center
			lockImageView.alpha = 1
			activityIndicatorView.stopAnimating()
			iconAccessory = .lockImage
		case .processing:
			isUserInteractionEnabled = false
			backgroundColor =
				theme.backgroundColor.withAlphaComponent(theme.opacity)
			titleLabel.font = UIFont.preferredFont(forTextStyle: .callout)
			titleLabel.textColor = UIColor.white.withAlphaComponent(theme.titleOpacity)
			titleLabel.text = "Processing"
			titleLabel.textAlignment = .center
			activityIndicatorView.startAnimating()
			iconAccessory = .loader
		case .success:

			self.checkmarkIndicatorView.completeProgress()
			self.iconAccessory = .none
			UIView.animate(withDuration: 0.3, delay: 0, options: []) {
				self.titleLabel.text = "Success"
				self.backgroundColor = theme.successColor
			} completion: { isFinished in
				//self.checkmarkIndicatorView.completeProgress()
			}
		}
	}
}

private let spinnerMoveToCenterAnimationDuration = 0.35
private let checkmarkStrokeDuration = 0.2

// MARK: - CheckProgressView

class CheckProgressView: UIView {
		let circleLayer = CAShapeLayer()
		let checkmarkLayer = CAShapeLayer()

		override init(frame: CGRect) {
				// Circle
				let circlePath = UIBezierPath(
						arcCenter: CGPoint(
								x: frame.size.width / 2,
								y: frame.size.height / 2),
						radius: (frame.size.width) / 2,
						startAngle: 0.0,
						endAngle: CGFloat.pi * 2,
						clockwise: false)
				circleLayer.bounds = CGRect(
						x: 0, y: 0, width: frame.size.width, height: frame.size.width)
				circleLayer.path = circlePath.cgPath
				circleLayer.fillColor = UIColor.clear.cgColor
				circleLayer.strokeColor = UIColor.white.cgColor
				circleLayer.lineCap = .round
				circleLayer.lineWidth = 1.0
				circleLayer.strokeEnd = 0.0

				// Checkmark
				let checkmarkPath = UIBezierPath()
				let checkOrigin = CGPoint(x: frame.size.width * 0.33, y: frame.size.height * 0.5)
				let checkPoint1 = CGPoint(x: frame.size.width * 0.46, y: frame.size.height * 0.635)
				let checkPoint2 = CGPoint(x: frame.size.width * 0.70, y: frame.size.height * 0.36)
				checkmarkPath.move(to: checkOrigin)
				checkmarkPath.addLine(to: checkPoint1)
				checkmarkPath.addLine(to: checkPoint2)

				checkmarkLayer.bounds = CGRect(
						x: 0, y: 0, width: frame.size.width, height: frame.size.width)
				checkmarkLayer.path = checkmarkPath.cgPath
				checkmarkLayer.lineCap = .round
				checkmarkLayer.fillColor = UIColor.clear.cgColor
				checkmarkLayer.strokeColor = UIColor.white.cgColor
				checkmarkLayer.lineWidth = 1.5
				checkmarkLayer.strokeEnd = 0.0

				checkmarkLayer.position = CGPoint(x: frame.width / 2, y: frame.height / 2)
				circleLayer.position = CGPoint(x: frame.width / 2, y: frame.height / 2)

				super.init(frame: frame)

				self.backgroundColor = UIColor.clear
				layer.addSublayer(circleLayer)
				layer.addSublayer(checkmarkLayer)
		}

		required init?(coder: NSCoder) {
				fatalError()
		}

		func beginProgress() {
				checkmarkLayer.strokeEnd = 0.0  // Make sure checkmark is not drawn yet
				let animation = CABasicAnimation(keyPath: "strokeEnd")
				animation.duration = 1.0
				animation.fromValue = 0
				animation.toValue = 0.8
				animation.timingFunction = CAMediaTimingFunction(
						name: CAMediaTimingFunctionName.easeOut)
				circleLayer.strokeEnd = 0.8
				circleLayer.add(animation, forKey: "animateCircle")
				let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
				rotationAnimation.byValue = 2.0 * Float.pi
				rotationAnimation.duration = 1
				rotationAnimation.repeatCount = .infinity
				circleLayer.add(rotationAnimation, forKey: "animateRotate")
		}

		func completeProgress() {
				circleLayer.removeAnimation(forKey: "animateCircle")

				// Close the circle
				let circleAnimation = CABasicAnimation(keyPath: "strokeEnd")
				circleAnimation.duration = spinnerMoveToCenterAnimationDuration
				circleAnimation.fromValue = 0.8
				circleAnimation.toValue = 1
				circleAnimation.timingFunction = CAMediaTimingFunction(
						name: CAMediaTimingFunctionName.easeIn)
				circleLayer.strokeEnd = 1.0
				circleLayer.add(circleAnimation, forKey: "animateDone")

				// Check the mark
//				let animation = CABasicAnimation(keyPath: "strokeEnd")
//				animation.beginTime = CACurrentMediaTime() + circleAnimation.duration + 0.15  // Start after the circle closes
//				animation.fillMode = .backwards
//				animation.duration = checkmarkStrokeDuration
//				animation.fromValue = 0.0
//				animation.toValue = 1
//				animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
//				checkmarkLayer.strokeEnd = 1.0
//				checkmarkLayer.add(animation, forKey: "animateFinishCircle")
		}
}
