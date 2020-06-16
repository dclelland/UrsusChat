source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '13.0'

use_frameworks!

local = true

target 'Ursus Chat' do
  
    if local
        pod 'Ursus', path: '../Ursus'
        pod 'Ursus/Utilities', path: '../Ursus'
    else
        pod 'Ursus', '~> 1.0'
        pod 'Ursus/Utilities', '~> 1.0'
    end
  
    pod 'AlamofireLogger', '~> 0.3'
    pod 'KeychainAccess', '~> 4.2'
    
end
