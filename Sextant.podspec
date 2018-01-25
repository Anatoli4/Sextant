Pod::Spec.new do |s|
  s.name = "Sextant"
  s.version = "0.0.1"
  s.summary = "Perform API access library"

  s.license = { :type => "MIT" }
  s.homepage = "https://github.com/netcosports/Sextant"
  s.author = {
    "Vladimir Burdukov" => "vladimir.burdukov@netcosports.com"
  }
  s.source = { :git => "https://github.com/netcosports/Sextant.git", :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'
  s.tvos.deployment_target = '9.0'
  s.osx.deployment_target = '10.10'

  s.dependency 'Gnomon/Core'
  s.dependency 'Gnomon/JSON'
  s.dependency 'Gnomon/XML'
  s.dependency 'Marshal'
  s.dependency 'Fuzi'
  s.dependency 'Ji'
  s.dependency 'RxSwift', '~> 4.0'

  s.source_files = 'Sources/**/*.swift'

end
