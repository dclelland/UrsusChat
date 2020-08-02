source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '13.0'

use_frameworks!

development_pods = false

target 'Ursus Chat' do
  
    unless development_pods
        pod 'UrsusAirlock', '~> 1.7.2'
        pod 'UrsusAtom', '~> 1.2.1'
        pod 'UrsusSigil', '~> 1.2.1'
    else
        pod 'UrsusAirlock', path: '../UrsusAirlock'
        pod 'UrsusAtom', path: '../UrsusAtom'
        pod 'UrsusSigil', path: '../UrsusSigil'
    end
  
    pod 'AlamofireNetworkActivityIndicator', '~> 3.1'
    pod 'AlamofireLogger', '~> 1.0'
    pod 'Introspect', '~> 0.1'
    pod 'KeyboardObserving', '~> 0.3'
    pod 'KeychainAccess', '~> 4.2'
    pod 'NonEmpty', '~> 0.2'
    pod 'ReSwift', '~> 5.0'
    pod 'ReSwiftThunk', '~> 1.2'
    pod 'SwiftDate', '~> 6.1'
    
end
