source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '13.0'

use_frameworks!

development_pods = false

target 'Ursus Chat' do
  
    if development_pods
        pod 'Ursus', path: '../Ursus'
        pod 'Ursus/Utilities', path: '../Ursus'
    else
        pod 'Ursus', '~> 1.1'
        pod 'Ursus/Utilities', '~> 1.1'
    end
  
    pod 'AlamofireNetworkActivityIndicator', '~> 3.1'
    pod 'KeychainAccess', '~> 4.2'
    pod 'ReSwift', '~> 5.0'
    
end
