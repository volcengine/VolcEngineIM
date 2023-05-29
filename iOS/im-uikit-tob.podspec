#
#  Be sure to run `pod spec lint BIMUIKit.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  spec.name         = "im-uikit-tob"
  spec.version      = "1.1.0"
  spec.summary      = "IM UIKit"
  spec.description  = <<-DESC
       TODO: Add long description of the pod here.
                   DESC

  spec.homepage     = "https://github.com"
  spec.license      = { :type => "MIT", :file => "FILE_LICENSE" }
  spec.author             = { "yangzhanjiang" => "yangzhanjiang@bytedance.com" }
  spec.ios.deployment_target = '9.0'
  spec.source           = { :git => 'git@code.byted.org:im/TIMSDK.git', :tag => spec.version.to_s }

  spec.source_files  = '**/BIMUIKit/**/*'

  spec.resource_bundles = {
      'TIMOEmoji' => ['**/BIMUIKit/**/TIMOEmoji.bundle/**/*'],
      'BIMUIKit' => ['**/BIMUIKit/**/BIMUIKit.bundle/*']
  }


  spec.frameworks = "UIKit"

  spec.dependency 'Masonry'
  spec.dependency 'MJRefresh'
  spec.dependency 'SDWebImage'
  spec.dependency 'imsdk-tob', '1.1.0'

  spec.requires_arc = true

end
