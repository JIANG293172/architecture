Pod::Spec.new do |s|
  s.name             = 'IMKit'
  s.version          = '1.0.0'
  s.summary          = 'A professional high-performance IM component for iOS.'
  s.description      = <<-DESC
A business-agnostic IM component supporting MQTT and customizable protocols. Designed for high performance and scalability.
                       DESC

  s.homepage         = 'https://github.com/imkit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Architecture' => 'arch@example.com' }
  s.source           = { :git => 'https://github.com/imkit.git', :tag => s.version.to_s }

  s.ios.deployment_target = '13.0'
  s.swift_version = '5.0'

  s.source_files = 'Classes/**/*'
  
  # Business-agnostic component should not depend on specific UI or heavy libraries unless necessary.
  # We will use CocoaMQTT as the underlying transport layer for this demo.
  s.dependency 'CocoaMQTT'
end
