Pod::Spec.new do |s|
  s.name = 'AChain'
  s.version = '0.0.1'
  s.license = 'MIT'
  s.summary = 'Easy chaining Swift animations'
  s.homepage = 'https://github.com/macistador/AChain'
  s.social_media_url = 'http://twitter.com/macistador'
  s.authors = { 'Michel-André Chirita' => 'mac.hamac@gmail.com' }
  s.source = { :git => 'https://github.com/macistador/AChain.git', :tag => s.version }
  s.documentation_url = 'https://macistador.github.io/AChain/'

  s.ios.deployment_target = '10.2'
  s.source_files = 'AChain/*.swift'
end
