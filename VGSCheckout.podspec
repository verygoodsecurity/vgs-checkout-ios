#
#  Be sure to run `pod spec lint VGSCheckout.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  spec.name         = "VGSCheckout"
  spec.version      = "0.0.1"
  spec.summary      = "VGS iOS Checkout SDK!"
  spec.description  = <<-DESC
                     VGS Checkout - is a universal checkout and user experience. Single, customized, consistent experience to your customers across devices and browsers that you control
                  DESC

  spec.homepage     = "https://github.com/verygoodsecurity/vgs-checkout-ios"
  spec.license      = { :type => "MIT", :file => "FILE_LICENSE" }
  spec.author             = { "Very Good Security" => "support@verygoodsecurity.com" }
  spec.ios.deployment_target = "11.0"
  spec.source       = { :git => "https://github.com/verygoodsecurity/vgs-checkout-ios.git", :tag => "#{spec.version}" }


  spec.requires_arc = true
  spec.default_subspec = 'Core'

  spec.subspec 'Core' do |core|
  #set as default podspec to prevent from downloading additional modules
    core.source_files = "Sources/VGSCheckout", "Sources/VGSCheckout/**/*.{swift}", "Sources/VGSCheckout/**/*.{h, m}"
		core.dependency "VGSCollectSDK", '1.7.13'
		core.resource_bundles = {
			'CheckoutResources' => ['Sources/VGSCheckout/Resources/*']
		}
  end

	spec.subspec 'CardIO' do |cardIO|
		cardIO.dependency "VGSCollectSDK/CardIO"
		cardIO.source_files  = "Sources/VGSCheckoutCardIOScanner", "Sources/VGSCheckoutCardIOScanner/**/*.{swift}", "Sources/VGSCheckoutCardIOScanner/**/*.{h, m}"
    cardIO.dependency "VGSCheckout/Core"
	end


  # ――― Resources ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  A list of resources included with the Pod. These are copied into the
  #  target bundle with a build phase script. Anything else will be cleaned.
  #  You can preserve files from being cleaned, please don't preserve
  #  non-essential files like tests, examples and documentation.
  #

  # spec.resource  = "icon.png"
  # spec.resources = "Resources/*.png"

  # spec.preserve_paths = "FilesToSave", "MoreFilesToSave"


  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Link your library with frameworks, or libraries. Libraries do not include
  #  the lib prefix of their name.
  #

  # spec.framework  = "SomeFramework"
  # spec.frameworks = "SomeFramework", "AnotherFramework"

  # spec.library   = "iconv"
  # spec.libraries = "iconv", "xml2"


  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If your library depends on compiler flags you can set them in the xcconfig hash
  #  where they will only apply to your library. If you depend on other Podspecs
  #  you can include multiple dependencies to ensure it works.

  # spec.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # spec.dependency "JSONKit", "~> 1.4"

end
