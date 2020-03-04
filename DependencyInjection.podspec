Pod::Spec.new do |s|
  s.name = 'DependencyInjection'
  s.version = '0.0.1'
  s.summary = 'DependencyInjection lib.'
  s.description = <<-DESC
  DependencyInjection is a collection for extension.
                   DESC

  s.license = { type: 'MIT', file: 'LICENSE' }
  s.authors = { 'Amine Bensalah' => 'amine.bensalah@outlook.com' }

  s.ios.deployment_target = '12.0'

  s.requires_arc = true
  s.source = { git: 'https://github.com/amine2233/DependencyInjection.git', tag: s.version.to_s }
  s.swift_version = '5.0'
  s.homepage     = 'https://github.com/amine2233/DependencyInjection.git'

  s.pod_target_xcconfig = {
    'SWIFT_VERSION' => s.swift_version
  }

  s.module_name = s.name
  s.source_files = 'Sources/DependencyInjection/**/*.{swift}'

  s.test_spec 'Tests' do |test_spec|
    test_spec.source_files = 'Tests/DependencyInjectionTests/**/*.{swift}'
  end

end
