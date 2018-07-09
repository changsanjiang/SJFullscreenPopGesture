#
#  Be sure to run `pod spec lint SJVideoPlayerBackGR.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "SJFullscreenPopGesture"
  s.version      = "1.4.2"
  s.summary      = "fullscreen pop gestures."
  s.description  = 'fullscreen pop gesture. System native gestures and custom gestures are free to switch.'


  s.homepage     = "https://github.com/changsanjiang/SJFullscreenPopGesture"
  s.license      = { :type => 'MIT', :file => 'LICENSE.md' }

  s.author             = { "SanJiang" => "changsanjiang@gmail.com" }
  s.platform     = :ios, '8.0'

  s.source       =   { :git => 'https://github.com/changsanjiang/SJFullscreenPopGesture.git', :tag => "v#{s.version}" }

  s.source_files = "SJFullscreenPopGesture/*.{h,m}"

  s.requires_arc = true
end
