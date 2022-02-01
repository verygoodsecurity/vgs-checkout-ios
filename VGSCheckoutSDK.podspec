Pod::Spec.new do |spec|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  spec.name         = "VGSCheckoutSDK"
  spec.version      = "1.3.0"
  spec.summary      = "VGS iOS Checkout SDK!"
	spec.swift_version = '5.0'
  spec.description  = <<-DESC
                     VGS Checkout - is a universal checkout and user experience. Single, customized, consistent experience to your customers across devices and browsers that you control.
                  DESC

  spec.homepage     = "https://github.com/verygoodsecurity/vgs-checkout-ios"
	#spec.documentation_url    = "https://github.com/verygoodsecurity/vgs-checkout-ios"
  spec.license      = { type: 'MIT', file: 'LICENSE' }
  spec.author             = { "Very Good Security" => "support@verygoodsecurity.com" }
	spec.social_media_url   = "https://twitter.com/getvgs"
	spec.platform     = :ios, "11.0"
  spec.ios.deployment_target = "11.0"
  spec.source       = { :git => "https://github.com/verygoodsecurity/vgs-checkout-ios.git", :tag => "#{spec.version}" }


  spec.requires_arc = true
  spec.default_subspec = 'Core'

  spec.subspec 'Core' do |core|
  #set as default podspec to prevent from downloading additional modules
    core.source_files = "Sources/VGSCheckoutSDK", "Sources/VGSCheckoutSDK/**/*.{swift}", "Sources/VGSCheckoutSDK/**/*.{h, m}"
		core.resource_bundles = {
			'CheckoutResources' => ['Sources/VGSCheckoutSDK/Resources/*'],
			'CardIcon' => ['Sources/VGSCheckoutSDK/Resources/*']
		}
  end
end
