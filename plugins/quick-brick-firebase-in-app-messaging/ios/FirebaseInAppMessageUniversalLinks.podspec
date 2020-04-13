Pod::Spec.new do |s|
  s.name         = 'FirebaseInAppMessageUniversalLinks'
  s.version      = '0.0.1'
  s.summary      = 'FirebaseInAppMessageUniversalLinks'
  s.license      = 'MIT'
  s.homepage     = 'http://applicaster.com'
  s.author       = {"Brel Egor" => "brel@scand.com"}
  s.ios.deployment_target = '10.0'
  s.swift_version = '5.1'
  s.source       = { :git => "https://github.com/applicaster/quick-brick-official-plugins"}
  s.source_files = 'FirebaseInAppMessageUniversalLinks/**/*.{swift,h,m}'
  s.resources = 'FirebaseInAppMessageUniversalLinks/**/*.{xib,nib,storyboard}'
  s.requires_arc = true
  s.static_framework = true
  s.dependency 'ZappCore'
  s.xcconfig =  { 'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES',
    'ENABLE_BITCODE' => 'YES',
    'SWIFT_VERSION' => '5.1'
  }
end
