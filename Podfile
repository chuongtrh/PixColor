# Uncomment the next line to define a global platform for your project
platform :ios, '12.0'
use_frameworks!
swift_version = '5'

def share_pods
    pod 'Alamofire', '~> 5.0.0-rc.3'
    pod 'MBProgressHUD'
    pod 'PINRemoteImage'
    pod 'UIImageColors'
    pod 'UIColor_Hex_Swift'
    pod 'UIScrollView-InfiniteScroll'
    pod 'UIView+Shimmer'
    pod 'NextLevel'
end

target 'pixcolor_dev' do
    share_pods
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['CLANG_WARN_DOCUMENTATION_COMMENTS'] = 'NO'
        end
    end
end
