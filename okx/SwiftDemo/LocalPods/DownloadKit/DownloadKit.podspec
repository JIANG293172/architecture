Pod::Spec.new do |s|
  s.name             = 'DownloadKit'
  s.version          = '1.0.0'
  s.summary          = 'A professional resume-download component for iOS.'
  s.description      = <<-DESC
                       DownloadKit supports multi-task concurrent downloading, resume from break point, 
                       and persistent task state management.
                       DESC

  s.homepage         = 'https://github.com/jt/DownloadKit'
  s.license          = { :type => 'MIT' }
  s.author           = { 'Jiang Tao' => 'jiang293177@gmail.com' }
  s.source           = { :git => '', :tag => s.version.to_s }

  s.ios.deployment_target = '13.0'
  s.swift_version    = '5.0'

  s.source_files = 'Classes/**/*'
end
