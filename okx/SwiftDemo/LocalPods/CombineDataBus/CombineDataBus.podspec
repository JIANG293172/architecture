Pod::Spec.new do |s|
  s.name             = 'CombineDataBus'
  s.version          = '1.0.0'
  s.summary          = 'A lightweight cross-component data synchronization middleware using Combine.'
  s.description      = <<-DESC
CombineDataBus is a business-agnostic middleware that leverages Apple's Combine framework to provide a robust event bus and data synchronization mechanism between different components in an iOS application.
                       DESC

  s.homepage         = 'https://github.com/example/CombineDataBus'
  s.license          = { :type => 'MIT', :text => 'Copyright 2024' }
  s.author           = { 'Developer' => 'dev@example.com' }
  s.source           = { :path => '.' }

  s.ios.deployment_target = '13.0'
  s.swift_version = '5.0'

  s.source_files = 'Classes/**/*'
  
  s.frameworks = 'Foundation', 'Combine'
end
