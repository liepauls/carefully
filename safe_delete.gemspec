lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'safe_delete/version'

Gem::Specification.new do |spec|
  spec.name          = 'safe_delete'
  spec.version       = SafeDelete::VERSION
  spec.authors       = ['Pauls Liepa']
  spec.email         = ['liepauls@gmail.com']

  spec.summary       = 'Ask for confirmation before destroying ActiveRecord::Base objects in specific environments'
  spec.license       = 'MIT'

  spec.files         = Dir.glob('lib/**/*') + ['README.md', 'LICENSE']
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rake', '~> 10.0'
end
