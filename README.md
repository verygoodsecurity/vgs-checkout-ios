[![CircleCI](https://circleci.com/gh/verygoodsecurity/vgs-checkout-ios/tree/checkout_0%2E0%2E1.svg?style=svg&circle-token=702dbbf24489d26efb05ca3eff1dd6f370c31ea6)](https://circleci.com/gh/verygoodsecurity/vgs-checkout-ios/tree/checkout_0%2E0%2E1)
[![UT](https://img.shields.io/badge/Unit_Test-pass-green)]()
[![license](https://img.shields.io/badge/License-MIT-green.svg)](./LICENSE)
[![Platform](https://img.shields.io/cocoapods/p/VGSCheckoutSDK.svg?style=flat)](https://github.com/verygoodsecurity/vgs-checkout-ios)
[![swift](https://img.shields.io/badge/swift-5-orange)]()
[![Cocoapods Compatible](https://img.shields.io/cocoapods/v/VGSCheckoutSDK.svg?style=flat)](https://cocoapods.org/pods/VGSCheckoutSDK)
<img src="./VGSZeroData.png" height="20">

# VGS Checkout iOS SDK

VGS provides you with a Universal Checkout and User Experience which is fully integrated with our payment optimization solution. We offer a single, customized, consistent experience to your customers across devices and browsers that you control. Provide a unified experience with all the features you want and no compromises to ensure your customers have the best experience with no distractions.

Depending on the needs we provide you with two solutions:

**Customized Universal Checkout** - shape the solution you need with our universal checkout solution. It’s easy to customize your integration with no heavy lifting to have a uniform experience across platforms and devices.
**Checkout for Payments Orchestration** - save time on integration by integration with Multiplexing App.

Table of contents
=================

<!--ts-->
   * [Before you start](#before-you-start)
   * [Integration](#integration)
      * [CocoaPods](#cocoapods)
      * [Swift Package Manager](#swift-package-manager-beta) 
   * [Usage](#usage)
      * [Create VGSCollect instance and VGS UI Elements](#create-vgscollect-instance-and-vgs-ui-elements)
      * [Scan Credit Card Data](#scan-credit-card-data)
      * [Upload Files](#upload-files)
      * [Demo Application](#demo-application)
      * [Documentation](#documentation)
      * [Releases](#releases)
   * [Dependencies](#dependencies)
   * [License](#license)
<!--te-->

<p align="center">
  <img src="https://raw.githubusercontent.com/verygoodsecurity/vgs-checkout-ios/canary/vgs-checkout-ios-add-card-1.png
  vgs-checkout-ios-add-card-2.png.png" width="200" alt="VGS Checkout iOS SDK Initial State" hspace="20">
  <img src="https://raw.githubusercontent.com/verygoodsecurity/vgs-checkout-ios/canary/vgs-checkout-ios-add-card-2.png" width="200" alt="VGS Checkout iOS SDK Edit State" hspace="20">
</p>


## Before you start
You should have your organization registered at <a href="https://dashboard.verygoodsecurity.com/dashboard/">VGS Dashboard</a>. Sandbox vault will be pre-created for you. You should use your `<vaultId>` to start collecting data. Follow integration guide below.

# Integration

### CocoaPods

[CocoaPods](https://cocoapods.org) is a dependency manager for Cocoa projects. For usage and installation instructions, visit their website. To integrate VGSCheckoutSDK into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
pod 'VGSCheckoutSDK'
```

### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler.
Xcode with Swift tools version of 5.3 is required for VGSCheckoutSDK. Earlier Xcode versions don't support Swift packages with resources.
To check your current Swift tools version run in your terminal:

```ruby
xcrun swift -version
```

> NOTE: In some cases you can have multiple Swift tools versions installed.


Follow the official Apple SPM guide [instructions](https://developer.apple.com/documentation/xcode/adding_package_dependencies_to_your_app) for more details.\n  
To use Swift Package Manager, in Xcode add the https://github.com/verygoodsecurity/vgs-checkout-ios.git dependency.


## Usage

### Import SDK into your file
```swift

import VGSCheckoutSDK

```
### Create VGSCollect instance and VGS UI Elements
Use your `<vaultId>` to initialize VGSCollect instance. You can get it in your [organisation dashboard](https://dashboard.verygoodsecurity.com/).

### Code example

<table>
  <tr">
    <th >Here's an example</th>
    <th width="27%">In Action</th>
  </tr>
  <tr>
    <td>Customize  VGSTextFields...</td>
     <th rowspan="2"><img src="add-card.gif"></th>
  </tr>
  <tr>
    <td>

    /// Initialize VGSCollect instance
    var vgsCollect = VGSCollect(id: "vauiltId", environment: .sandbox)

    /// VGS UI Elements
    var cardNumberField = VGSCardTextField()
    var cardHolderNameField = VGSTextField()
    var expCardDateField = VGSTextField()
    var cvcField = VGSTextField()

    /// Native UI Elements
    @IBOutlet weak var stackView: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()

        /// Create card number field configuration
        let cardConfiguration = VGSConfiguration(collector: vgsCollect,
                                           fieldName: "card_number")
        cardConfiguration.type = .cardNumber
        cardConfiguration.isRequiredValidOnly = true

        /// Setup configuration to card number field
        cardNumberField.configuration = cardConfiguration
        cardNumberField.placeholder = "Card Number"
        stackView.addArrangedSubview(cardNumberField)

        /// Setup next textfields...
    }
    ...
  </td>
  </tr>
  <tr>
    <td>... observe filed states </td>
     <th rowspan="2"><img src="state.gif"></th>
  </tr>
  <tr>
    <td>
  
    override func viewDidLoad() {
        super.viewDidLoad()
    
        ...  
    
        /// Observing text fields
        vgsCollect.observeStates = { textFields in

            textFields.forEach({ textField in
                print(textdField.state.description)
                if textdField.state.isValid {
                    textField.borderColor = .grey
                } else {
                    textField.borderColor = .red
                }

                /// CardState is available for VGSCardTextField
                if let cardState = textField.state as? CardState {
                    print(cardState.bin)
                    print(cardState.last4)
                    print(cardState.brand.stringValue)
                }
            })
        }
    }
  </td>
  </tr>
  <tr>
    <td colspan="2">... send data to your Vault</td>
  </tr>
  <tr>
    <td colspan="2">
        
    // ...

    // MARK: - Send data    
    func sendData() {
    
        /// handle fields validation before send data
        guard cardNumberField.state.isValid else {
    print("cardNumberField input is not valid")
        }
  
        /// extra information will be sent together with all sensitive card information
        var extraData = [String: Any]()
        extraData["customKey"] = "Custom Value"

        /// send data to your Vault
        vgsCollect.sendData(path: "/post", extraData: extraData) { [weak self](response) in
          switch response {
            case .success(let code, let data, let response):
              // parse data
            case .failure(let code, let data, let response, let error):
              // handle failed request
              switch code {
                // handle error codes
              }
          }
        }
    }
  </td>
  </tr>
</table>

**VGSCardTextField** automatically detects card provider and display card brand icon in the input field.


### Scan Credit Card Data
VGS Collect SDK provides several card scan solutions for the Payment Card Industry to help protect your businesses and the sensitive information of your consumers. It's required to use only Scan modules provided by VGS, which are audited by VGS PCI requirements.

#### Integrate with Cocoapods

Add 'VGSCheckoutSDK' alongside with one of scan modules pod:

```ruby
pod 'VGSCheckoutSDK'

# Add CardIO module to use Card.io as scan provider
pod 'VGSCheckoutSDK/CardIO' 

# Add CardScan module to use CardScan(Bouncer) as scan provider
pod 'VGSCheckoutSDK/CardScan' 
```
#### Integrate with Swift Package Manager

Starting with the 1.7.4 release, `VGSCheckoutSDK` also supports  [CardScan](https://github.com/getbouncer/cardscan-ios) integration via Swift PM.

To use **CardScan** add `VGSCheckoutSDK`, `VGSCardScanCollector` packages to your target. 

Starting with the 1.7.11 release, `VGSCheckoutSDK` supports  [CardIO](https://github.com/verygoodsecurity/card.io-iOS-source) integration via Swift PM.

To use **CardIO** add `VGSCheckoutSDK`, `VGSCardIOCollector` packages to your target. 

#### Integrate with Carthage

Carthage users should point to `VGSCheckoutSDK` repository and use next generated framework:

-  To use **Card.io**: `VGSCheckoutSDK`, `VGSCardIOCollector`, and `CardIO`. In your file add `import VGSCardIOCollector`.
-  To use **Card Scan**: `VGSCheckoutSDK`, `VGSCardScanCollector`, and `CardScan`. In your file add `import VGSCardScanCollector`.

Other submodules can safely be deleted from Carthage Build folder.

> NOTE: At this time, **Carthage** does not provide a way to build only specific repository submodules. All submodules and their dependencies will be built by default. However you can include into your project only submodules that you need.

> NOTE: For **Carthage** users CardScan available only with version 1.0.5048. Use **CocoaPods** or **Swift Package Manager** integration for the latest CardScan version. CardScan supports only **CocoaPods** or **Swift Package Manager** now.

#### Code Example

<table>
  <tr>
    <th>Here's an example</th>
    <th width="25%">In Action</th>
  </tr>
  <tr>
    <td>Setup  VGSCardIOScanController...</td>
    <th rowspan="2"><img src="card-scan.gif"></th>
  </tr>
  <tr>
    <td>
    
    class ViewController: UIViewController {
       
        var vgsCollect = VGSCollect(id: "vauiltId", environment: .sandbox)

        /// Init VGSCardIOScanController
        var scanController = VGSCardIOScanController()

        /// Init VGSTextFields...

        override func viewDidLoad() {
            super.viewDidLoad()

            /// set VGSCardIOScanDelegate
            canController.delegate = self
        }

        /// Present scan controller 
        func scanData() {
            scanController.presentCardScanner(on: self,
          animated: true,
              completion: nil)
        }

        // MARK: - Send data  
        func sendData() {
            /// Send data from VGSTextFields to your Vault
            vgsCollect.sendData{...}
        }
    }
    ...
  </td>
  </tr>
  <tr>
    <td colspan="2">... handle VGSCardIOScanControllerDelegate</td>
  </tr>
  <tr>
    <td colspan="2">
      
    // ...
    
    /// Implement VGSCardIOScanControllerDelegate methods
    extension ViewController: VGSCardIOScanControllerDelegate {

      ///Asks VGSTextField where scanned data with type need to be set.
      func textFieldForScannedData(type: CradIODataType) -> VGSTextField? {
    switch type {
    case .expirationDate:
        return expCardDateField
    case .cvc:
        return cvcField
    case .cardNumber:
        return cardNumberField
    default:
        return nil
    }
      }

      /// When user press Done button on CardIO screen
      func userDidFinishScan() {
    scanController.dismissCardScanner(animated: true, completion: { [weak self] in
        /// self?.sendData()
    })
      }
    }
   
  </td>
  </tr>
</table>

Handle `VGSCardIOScanControllerDelegate` functions. To setup scanned data into specific  VGSTextField implement `textFieldForScannedData:` . If scanned data is valid it will be set in your VGSTextField automatically after user confirmation. Check  `CradIODataType` to get available scand data types.

Don't forget to add **NSCameraUsageDescription** key and description into your App ``Info.plist``.

### Upload Files

You can add a file uploading functionality to your application with **VGSFilePickerController**.

#### Code Example

<table>
  <tr">
    <th  colspan="2>Here's an example</th>
  </tr>
  <tr>
    <td colspan="2">Setup  VGSFilePickerController...</td>
  </tr>
  <tr>
    <td colspan="2">
      
    class FilePickerViewController: UIViewController, VGSFilePickerControllerDelegate {

    var vgsCollect = VGSCollect(id: "vailtId", environment: .sandbox)
    
    /// Create strong referrence of VGSFilePickerController
    var pickerController: VGSFilePickerController?

    override func viewDidLoad() {
        super.viewDidLoad()

        /// create picker configuration
        let filePickerConfig = VGSFilePickerConfiguration(collector: vgsCollect,
                      fieldName: "secret_doc",
                     fileSource: .photoLibrary)

        /// init picket controller with configuration
        pickerController = VGSFilePickerController(configuration: filePickerConfig)

        /// handle picker delegates
        pickerController?.delegate = self
    }

    /// Present picker controller
    func presentFilePicker() {
        pickerController?.presentFilePicker(on: self, animated: true, completion: nil)
    }
  }
  ...
  </td>
  </tr>
  <tr>
    <td>... handle VGSFilePickerControllerDelegate</td>
    <th width="27%">In Action</th>
  </tr>
  <tr>
    <td>
  
  // ...  
  
  // MARK: - VGSFilePickerControllerDelegate
  /// Check file info, selected by user
  func userDidPickFileWithInfo(_ info: VGSFileInfo) {
    let fileInfo = """
          File info:
          - fileExtension: \(info.fileExtension ?? "unknown")
          - size: \(info.size)
          - sizeUnits: \(info.sizeUnits ?? "unknown")
          """
    print(fileInfo)
    pickerController?.dismissFilePicker(animated: true,
              completion: { [weak self] in
              
      self?.sendFile()
    })
  }

  // Handle cancel file selection
  func userDidSCancelFilePicking() {
    pickerController?.dismissFilePicker(animated: true)
  }

  // Handle errors on picking the file
  func filePickingFailedWithError(_ error: VGSError) {
    pickerController?.dismissFilePicker(animated: true)
  }
   
  </td>
  <td><img src="file-picker.gif"></td>
  </tr>
  <tr>
    <td colspan="2">... send file to your Vault</td>
  </tr>
  <tr>
    <td colspan="2">
      
  // ...

  // MARK: - Send File  
  /// Send file and extra data
  func sendFile() {
  
    /// add extra data to send request  
    let extraData = ["document_holder": "Joe B"]
    
      /// send file to your Vault
      vgsCollect.sendFile(path: "/post", extraData: extraData) { [weak self](response) in
        switch response {
          case .success(let code, let data, let response):
            /// remove file from VGSCollect storage
            self?.vgsCollect.cleanFiles()
          case .failure(let code, let data, let response, let error):
            // handle failed request
            switch code {
              // handle error codes
            }
        }
      }
  }
  </td>
  </tr>
</table>

Use vgsCollect.cleanFiles() to unassign file from associated VGSCollect instance whenever you need.

## Demo Application
Demo application for collecting card data on iOS is <a href="https://github.com/vgs-samples/very-spacy-food-iOS">here</a>.

Also you can check our [payment optimization demo](./demoapp/demoapp/UseCases/MultiplexingSetup/) with Multiplexing.

### Documentation
-  SDK Documentation: https://www.verygoodsecurity.com/docs/vgs-collect/ios-sdk
-  API Documentation: https://verygoodsecurity.github.io/vgs-checkout-ios/

### Releases
To follow `VGSCheckoutSDK` updates and changes check the [releases](https://github.com/verygoodsecurity/vgs-checkout-ios/releases) page.

### Metrics
VGSCheckoutSDK tracks a few key metrics to understand SDK features usage, which helps us know what areas need improvement. No personal information is tracked.
You can easily opt-out of metrics collection in `VGSAnalyticsClient`:
```
VGSAnalyticsClient.shared.shouldCollectAnalytics = false
```

## Dependencies
- iOS 11+
- Swift 5

## License

 VGSCheckout iOS SDK is released under the MIT license. [See LICENSE](https://github.com/verygoodsecurity/vgs-checkoutt-ios/blob/main/LICENSE) for details.

