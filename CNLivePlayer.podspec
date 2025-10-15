#
# Be sure to run `pod lib lint CNLivePlayer.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'CNLivePlayer'
  s.version          = '0.0.1'
  s.summary          = 'CNLivePlayer'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
网家家视频播放器.
                       DESC

  s.homepage         = 'http://bj.gitlab.cnlive.com/ios-team/CNLivePlayer'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '153993236@qq.com' => 'zhangxiaowen@cnlive.com' }
  s.source           = { :git => 'http://bj.gitlab.cnlive.com/ios-team/CNLivePlayer.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'
  
  #s.public_header_files = 'CNLivePlayer/Classes/Player/CNLivePlayer.h','CNLivePlayer/Classes/Player/CNLivePlayerManager.h','CNLivePlayer/Classes/Header/CNLivePlayerDelegate.h','CNLivePlayer/Classes/Header/CNLivePlayerHeader.h','CNLivePlayer/Classes/Header/CNLivePlayerTypeDef.h','CNLivePlayer/Classes/Database/CNLivePlayerDBTool.h'

  s.source_files = 'CNLivePlayer/Classes/Player/*','CNLivePlayer/Classes/Header/*','CNLivePlayer/Classes/DataRequest/*','CNLivePlayer/Classes/Database/*'
  
  s.vendored_frameworks = 'CNLivePlayer/Classes/CNLiveMsgTools.framework'

  s.dependency 'PLPlayerKit', '~> 3.4.3'
  s.dependency 'FMDB', '~> 2.7.5'

  s.libraries = 'z', 'bz2', 'c++', 'resolv', 'iconv', 'sqlite3.0'

  s.frameworks = 'Foundation', 'UIKit', 'AVFoundation', 'AVKit', 'MediaPlayer', 'VideoToolbox', 'CoreTelephony', 'CoreMedia', 'OpenGLES', 'QuartzCore', 'Accelerate', 'AudioToolbox', 'CoreAudio','CoreGraphics'

  s.static_framework = true
  s.pod_target_xcconfig = { 'VALID_ARCHS[sdk=iphonesimulator*]' => 'PLPlayerKit' }
  
end
