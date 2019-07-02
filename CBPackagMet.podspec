Pod::Spec.new do |s|
s.name = "CBPackagMet"
s.version = "1.0.0"
s.license = 'MIT'
# Copyright (c2019) CBin. All rights reserved
s.summary = "常用方法封装"
s.homepage = "https://github.com/junedeyu/CBPackagMet"
s.authors = { 'junedeyu' => '497303054@qq.com' }
s.source = { :git => "https://github.com/junedeyu/CBPackagMet.git", :tag => "1.0.0"}
s.requires_arc = true
s.platform = :ios, '9.0'
# s.ios.deployment_target = '9.0'
s.source_files = "CBPackagMet","SSKeychain", "*.{h,m}"
s.frameworks = 'Foundation','UIKit'
s.dependency "MBProgressHUD,AFNetworking"
end
