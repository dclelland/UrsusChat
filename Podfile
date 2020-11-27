source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '14.0'

use_frameworks!

development_pods = true

target 'Ursus Chat' do
  
    unless development_pods
        pod 'UrsusAPI', '~> 0.1.0'
        pod 'UrsusAtom', '~> 1.2.4'
        pod 'UrsusHTTP', '~> 1.10.0'
        pod 'UrsusSigil', '~> 1.2.2'
    else
        pod 'UrsusAPI', path: '../UrsusAPI'
        pod 'UrsusAtom', path: '../UrsusAtom'
        pod 'UrsusHTTP', path: '../UrsusHTTP'
        pod 'UrsusSigil', path: '../UrsusSigil'
    end
    
    pod 'AlamofireLogger', '~> 1.0'
    pod 'Introspect', '~> 0.1'
    pod 'KeyboardObserving', '~> 0.3'
    pod 'KeychainAccess', '~> 4.2'
    pod 'NonEmpty', '~> 0.2'
    pod 'ReSwift', '~> 5.0'
    pod 'ReSwiftThunk', '~> 1.2'
    pod 'SwiftDate', '~> 6.1'
    
end

# See https://stackoverflow.com/a/64048124

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
        end
    end
end
