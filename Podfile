source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '13.0'

use_frameworks!

development_pods = false

target 'Ursus Chat' do
  
    if development_pods
        pod 'Ursus', path: '../Ursus'
        pod 'UrsusAtom', path: '../UrsusAtom'
        pod 'UrsusSigil', path: '../UrsusSigil'
    else
        pod 'Ursus', '~> 1.3'
        pod 'UrsusAtom', '~> 1.0'
        pod 'UrsusSigil', '~> 1.1'
    end
  
    pod 'AlamofireNetworkActivityIndicator', '~> 3.1'
    pod 'AlamofireLogger', '~> 1.0'
    pod 'KeychainAccess', '~> 4.2'
    pod 'ReSwift', '~> 5.0'
    pod 'ReSwiftThunk', '~> 1.2'
    pod 'SwiftDate', '~> 6.1'
    
end
