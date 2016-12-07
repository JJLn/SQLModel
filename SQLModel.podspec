#
#  Be sure to run `pod spec lint SQLModel.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#
Pod::Spec.new do |s|
　　s.name = 'SQLModel'
　　s.version = ‘1.0.0’
　　s.license = 'MIT'
　　s.summary = ‘sql to model’
　　s.homepage = 'https://github.com/JJLn/SQLModel'
　　s.author = { ‘wj’ => ‘wj’ }
　　s.source = { :git => 'https://github.com/JJLn/SQLModel.git' }
　　s.platform = :ios
　　s.source_files = 'SQLModel/FMDBHelper/*.{h,m}'
　　s.resources = ""
　　s.framework = ‘libsqlite3.0’
　　s.requires_arc = true
   s.dependency 'FMDB', '~> 2.6.2'
　　end