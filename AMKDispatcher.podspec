#
# Be sure to run `pod lib lint AMKDispatcher.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
s.name             = 'AMKDispatcher'
s.version          = '0.1.0'
s.summary          = 'AMKDispatcher'
s.description      = <<-DESC
                     The dispatcher with no regist process to split your iOS Project into multiple project.
                     DESC
s.homepage         = 'https://github.com/AndyM129/AMKDispatcher'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'Andy__M' => 'andy_m129@163.com' }
s.source           = { :git => 'https://github.com/AndyM129/AMKDispatcher.git', :tag => s.version.to_s }
s.ios.deployment_target = '8.0'
s.source_files = 'AMKDispatcher/Classes/**/*'
end
