Pod::Spec.new do |s|
  s.name = 'AChain'
  s.version = '0.0.5'
  s.license = 'MIT'
  s.summary = 'Lightweight, syntax-similar to default UIKit, yet powerful animation lib in Swift'
  s.homepage = 'https://github.com/macistador/AChain'
  s.social_media_url = 'http://twitter.com/macistador'
  s.authors = { 'Michel-André Chirita' => 'mac.hamac@gmail.com' }
  s.source = { :git => 'https://github.com/macistador/AChain.git', :tag => s.version }
  s.documentation_url = 'https://macistador.github.io/AChain/'

  s.ios.deployment_target = '10.0'
  s.source_files = 'AChain/*.swift'
end
