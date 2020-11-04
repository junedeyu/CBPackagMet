Pod::Spec.new do |s|
s.name = "CBPackagMet"
s.version = '1.1.4'
s.license = 'MIT'
# Copyright (c2019) CBin. All rights reserved
s.summary = "常用方法封装"
s.homepage = "https://github.com/junedeyu/CBPackagMet"
s.authors = { 'junedeyu' => '497303054@qq.com' }
s.source = { :git => "https://github.com/junedeyu/CBPackagMet.git", :tag => s.version.to_s}
s.requires_arc = true
s.platform = :ios, '9.0'
s.ios.deployment_target = '9.0'
s.source_files = 'PackagMet.h','PackagMet.m','SSKeychain.h','SSKeychain.m'
# 'CBPackagMet/*.{h,m}'
s.frameworks = 'Foundation','UIKit'
s.dependency 'MBProgressHUD'
s.dependency 'AFNetworking'
end
