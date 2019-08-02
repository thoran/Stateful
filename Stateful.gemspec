Gem::Specification.new do |spec|
  spec.name = 'stateful'
  spec.version = '0.14.1'
  spec.date = '2019-08-02'

  spec.summary = "A Ruby state machine."
  spec.description = "Easily add state and manage it with Poro and ActiveRecord objects."

  spec.author = 'thoran'
  spec.email = 'code@thoran.com'
  spec.homepage = 'http://github.com/thoran/Stateful'
  spec.license = 'MIT'

  spec.files = Dir['lib/**/*.rb']
  spec.required_ruby_version = '>= 1.8.6'
end
