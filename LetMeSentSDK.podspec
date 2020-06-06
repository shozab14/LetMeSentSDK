#
# Be sure to run `pod lib lint LetMeSentSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'LetMeSentSDK'
  s.version          = '0.1.0'
  s.summary          = 'LetMeSentSDK for ios'
  
  s.description      = <<-DESC
  TODO: Add long description of the pod here.
  DESC
  
  s.homepage         = 'https://github.com/shozab14/LetMeSentSDK'
  
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Shozab Haider' => 'shozabhiader14@gmail.com' }
  s.source           = { :git => 'https://github.com/shozab14/LetMeSentSDK.git', :tag => s.version.to_s }
  
  s.swift_version  = '5.0'
  s.ios.deployment_target = '11.0'
  
  s.source_files =  'LetMeSentSDK/Classes/**/*'
  #'General/**/*'
  #'LetMeSentSDK/Classes/**/*'
  
  
end

