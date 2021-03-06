//
//  VGSCardTextField.swift
//  VGSCheckoutSDK
//

#if os(iOS)
import UIKit
#endif

/// An object that displays an editable text area. Can be use instead of a `VGSTextField` when need to detect and show credit card brand images.
internal final class VGSCardTextField: VGSTextField {
  
    internal let cardIconView = UIImageView()
    internal lazy var stackView = self.makeStackView()
    internal let stackSpacing: CGFloat = 8.0
    internal lazy var defaultUnknowBrandImage: UIImage? = {
      return VGSCheckoutPaymentCards.CardBrand.unknown.brandIcon
    }()

	/// Card number image view container.
	internal lazy var cardIconContainerView: UIView = {
		let view = UIView()
		view.backgroundColor = .clear
		view.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(cardIconView)

		// Center cardIconImageView in container view.
		cardIconView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
		cardIconView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

		// Container view width should be equal to cvcIconImageView.width. Container view doesn't infer its own intristicContentSize. So stackView cannot get widths from simpleView without this.
		view.widthAnchor.constraint(equalTo: cardIconView.widthAnchor).isActive = true

		return view
	}()
  
    // MARK: - Enum cases
    /// Available Card brand icon positions enum.
    public enum CardIconLocation {
        /// Card brand icon at left side of `VGSCardTextField`.
        case left
      
        /// Card brand icon at right side of `VGSCardTextField`.
        case right
    }
    
    // MARK: Attributes
  
    /// Card brand icon visibility..
    public var isIconHidden: Bool = false {
      didSet { updateCardImageView(hidden: isIconHidden)}
    }
  
    /// Card brand icon position inside `VGSCardTextField`.
    public var cardIconLocation = CardIconLocation.right {
      didSet {
        setCardIconAtLocation(cardIconLocation)
      }
    }
  
    /// Card brand icon size.
    public var cardIconSize: CGSize = CGSize(width: 45, height: 45) {
        didSet {
            updateCardIconViewSize()
        }
    }
    
    // MARK: Custom card brand images
    /// Asks custom image for specific `VGSCheckoutPaymentCards.CardBrand`
    public var cardsIconSource: ((VGSCheckoutPaymentCards.CardBrand) -> UIImage?)?
    
    /// :nodoc:
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        updateCardImage()
    }
}

internal extension VGSCardTextField {
  
    // MARK: - Initialization
    override func mainInitialization() {
        super.mainInitialization()
        
        buildCardIconView()
        setCardIconAtLocation(cardIconLocation)
        updateCardImage()
    }
  
    override func buildTextFieldUI() {
        addSubview(stackView)
        textField.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(textField)
        setMainPaddings()
    }
    
    override func setMainPaddings() {
      NSLayoutConstraint.deactivate(verticalConstraint)
      NSLayoutConstraint.deactivate(horizontalConstraints)
      
      let views = ["view": self, "stackView": stackView]
      
      horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-\(padding.left)-[stackView]-\(padding.right)-|",
                                                                 options: .alignAllCenterY,
                                                                 metrics: nil,
                                                                 views: views)
      NSLayoutConstraint.activate(horizontalConstraints)
      
      verticalConstraint = NSLayoutConstraint.constraints(withVisualFormat: "V:|-\(padding.top)-[stackView]-\(padding.bottom)-|",
                                                              options: .alignAllCenterX,
                                                              metrics: nil,
                                                              views: views)
      NSLayoutConstraint.activate(verticalConstraint)
      self.layoutIfNeeded()
    }
  
    private func makeStackView() -> UIStackView {
        let stack = UIStackView()
        stack.alignment = .fill
        stack.axis = .horizontal
        stack.distribution = .fillProportionally
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 8
        return stack
    }
  
    // override textFieldDidChange
    override func textFieldValueChanged() {
        super.textFieldValueChanged()
        updateCardImage()
    }
  
    func updateCardImageView(hidden: Bool) {
      if hidden {
        cardIconView.removeFromSuperview()
      } else {
        buildCardIconView()
        setCardIconAtLocation(cardIconLocation)
        updateCardImage()
      }
    }
  
    func updateCardImage() {
      guard !isIconHidden else {
        return
      }
      if let state = state as? CardState {
         cardIconView.image = (cardsIconSource == nil) ? state.cardBrand.brandIcon :  cardsIconSource?(state.cardBrand)
      } else {
        cardIconView.image = VGSCheckoutPaymentCards.unknown.brandIcon
      }
    }
  
    func setCardIconAtLocation(_ location: CardIconLocation) {
        guard !isIconHidden else {
          return
        }
				cardIconContainerView.removeFromSuperview()
        switch location {
        case .left:
            stackView.insertArrangedSubview(cardIconContainerView, at: 0)
        case .right:
            stackView.addArrangedSubview(cardIconContainerView)
        }
    }
    
    func updateCardIconViewSize() {
        guard !isIconHidden else {
          return
        }
        if let widthConstraint = cardIconView.constraints.filter({ $0.identifier == "widthConstraint" }).first {
            widthConstraint.constant = cardIconSize.width
        }
        if let heightConstraint = cardIconView.constraints.filter({ $0.identifier == "heightConstraint" }).first {
            heightConstraint.constant = cardIconSize.height
        }
    }
    
    // make image view for a card brand icon
    private func buildCardIconView() {
        cardIconView.translatesAutoresizingMaskIntoConstraints = false
        cardIconView.contentMode = .scaleAspectFit
        let widthConstraint = NSLayoutConstraint(item: cardIconView,
                                                 attribute: .width,
                                                 relatedBy: .equal,
                                                 toItem: nil,
                                                 attribute: .notAnAttribute,
                                                 multiplier: 1,
                                                 constant: cardIconSize.width)
        widthConstraint.identifier = "widthConstraint"
        let heightConstraint = NSLayoutConstraint(item: cardIconView,
                                                  attribute: .height,
                                                  relatedBy: .equal,
                                                  toItem: nil,
                                                  attribute: .notAnAttribute,
                                                  multiplier: 1,
                                                  constant: cardIconSize.height)
        heightConstraint.identifier = "heightConstraint"
        // fix conflict with textfield height constraint when card icon more higher then textfield
        heightConstraint.priority = UILayoutPriority(rawValue: 999)
        cardIconView.addConstraints([widthConstraint, heightConstraint])
    }
}
