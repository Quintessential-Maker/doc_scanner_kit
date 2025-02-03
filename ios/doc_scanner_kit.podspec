Pod::Spec.new do |s|
  s.name             = 'doc_scanner_kit'
  s.version          = '0.0.2'
  s.summary          = 'A document scanner kit for iOS in Flutter.'
  s.description      = <<-DESC
This Flutter plugin provides a document scanning capability using advanced image processing techniques.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :type => 'MIT', :file => '../LICENSE' }
  s.authors          = { 'Your Name' => 'developer.pallii09@gmail.com' }
  s.source           = { :git => 'https://github.com/Quintessential-Maker/doc_scanner_kit.git', :tag => s.version.to_s }
  s.source_files     = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform         = :ios, '13.0'

  # Flutter.framework does not contain an i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
