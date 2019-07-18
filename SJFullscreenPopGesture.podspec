#
#  Be sure to run `pod spec lint SJVideoPlayerBackGR.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "SJFullscreenPopGesture"
  s.version      = "1.5.0"
  s.summary      = "fullscreen pop gestures."
  s.description  = 'https://github.com/changsanjiang/SJFullscreenPopGesture/blob/master/README.md'


  s.homepage     = "https://github.com/changsanjiang/SJFullscreenPopGesture"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }

  s.author             = { "SanJiang" => "changsanjiang@gmail.com" }
  s.platform     = :ios, '8.0'

  s.source       =   { :git => 'https://github.com/changsanjiang/SJFullscreenPopGesture.git', :tag => "v#{s.version}" }

  s.requires_arc = true

  s.default_subspec = 'ObjC'

  s.subspec 'ObjC' do |ss|
    ss.source_files = "SJFullscreenPopGesture/ObjC/*.{h,m}"
  end

  s.subspec 'Swift' do |ss|
    s.swift_version = '5.0'
    ss.source_files = "SJFullscreenPopGesture/Swift/*.swift"
  end
end
