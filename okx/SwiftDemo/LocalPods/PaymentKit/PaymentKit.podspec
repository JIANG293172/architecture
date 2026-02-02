Pod::Spec.new do |s|
  s.name             = 'PaymentKit'
  s.version          = '1.0.0'
  s.summary          = 'A high-performance, scalable payment middleware for iOS.'
  s.description      = <<-DESC
                       PaymentKit provides a unified interface for multiple payment channels (AliPay, WeChatPay, ApplePay), 
                       supporting dynamic channel dispatching and standardized result handling.
                       DESC

  s.homepage         = 'https://github.com/jt/PaymentKit'
  s.license          = { :type => 'MIT' }
  s.author           = { 'Jiang Tao' => 'jiang293177@gmail.com' }
  s.source           = { :git => '', :tag => s.version.to_s }

  s.ios.deployment_target = '13.0'
  s.swift_version    = '5.0'

  s.source_files = 'Classes/**/*'
  
  s.frameworks = 'UIKit', 'Foundation'
end
