Pod::Spec.new do |s|
  s.name             = 'RxDataBus'
  s.version          = '1.0.0'
  s.summary          = 'A cross-component data synchronization middleware using RxSwift.'
  s.description      = <<-DESC
RxDataBus is a business-agnostic middleware that leverages RxSwift to provide a robust event bus and data synchronization mechanism between different components.
                       DESC

  s.homepage         = 'https://github.com/example/RxDataBus'
  s.license          = { :type => 'MIT', :text => 'Copyright 2024' }
  s.author           = { 'Developer' => 'dev@example.com' }
  s.source           = { :path => '.' }

  s.ios.deployment_target = '13.0'
  s.swift_version = '5.0'

  s.source_files = 'Classes/**/*'
  
  s.dependency 'RxSwift', '~> 6.5'
  s.dependency 'RxRelay', '~> 6.5'
  
  s.frameworks = 'Foundation'
end
