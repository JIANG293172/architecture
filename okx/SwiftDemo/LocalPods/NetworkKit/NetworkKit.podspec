Pod::Spec.new do |s|
  s.name             = 'NetworkKit'
  s.version          = '1.0.0'
  s.summary          = 'A professional high-level networking framework based on Alamofire.'
  s.description      = <<-DESC
A comprehensive networking framework with support for RESTful API, TLS pinning, client certificates, token refresh, and common parameter injection.
                       DESC

  s.homepage         = 'https://github.com/networkkit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Architecture' => 'arch@example.com' }
  s.source           = { :git => 'https://github.com/networkkit.git', :tag => s.version.to_s }

  s.ios.deployment_target = '13.0'
  s.swift_version = '5.0'

  s.source_files = 'Classes/**/*'
  
  s.dependency 'Alamofire', '~> 5.9'
end
