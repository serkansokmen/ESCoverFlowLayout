#
# Be sure to run `pod lib lint ESCoverFlowLayout.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name         = 'ESCoverFlowLayout'
  s.version      = "1.0.4"
  s.summary      = "Custom Coverflow Collection View Layout"

  s.description      = <<-DESC
Simple coverflow layout for UICollectionView
                       DESC

  s.homepage         = 'https://github.com/serkansokmen/ESCoverFlowLayout'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'serkansokmen' => 'e.serkan.sokmen@gmail.com' }
  s.source           = { :git => 'https://github.com/serkansokmen/ESCoverFlowLayout.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'ESCoverFlowLayout/Classes/**/*'
  
  # s.resource_bundles = {
  #   'ESCoverFlowLayout' => ['ESCoverFlowLayout/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
