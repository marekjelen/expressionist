# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'expressionist/version'

Gem::Specification.new do |spec|

  spec.name          = 'expressionist'
  spec.version       = Expressionist::VERSION
  spec.authors       = ['Marek Jelen']
  spec.email         = ['marek@jelen.biz']

  spec.summary       = 'Simple query language for tree structured data'
  spec.description   = 'Safely make queries against tree data structure with ' \
                       'ability to serialize queries for later usage'
  spec.homepage      = 'https://www.github.com/marekjelen/expressionist'
  spec.license       = 'MIT'

  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      f.match(%r{^(test|spec|features)/})
    end
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'parslet', '~> 1.8'

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'pry', '~> 0.11'
  spec.add_development_dependency 'rake', '~> 10.0'

end
