source 'https://github.com/CocoaPods/Specs.git'
source 'https://github.com/netcosports/NSTPodsSpecs.git'

use_frameworks!

abstract_target 'Tests' do
  pod 'SwiftLint'
  pod 'Sextant', :path => '.'
  pod 'Nimble', '~> 7.0'
  pod 'RxBlocking'
  pod 'SignatureInterceptor', '~> 2.0'

  target 'iOSTests' do
    platform :ios, '8.0'
  end

  target 'tvOSTests' do
    platform :tvos, '9.0'
  end

end
