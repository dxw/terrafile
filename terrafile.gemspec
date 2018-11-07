lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'terrafile/version'

Gem::Specification.new do |spec|
  spec.name          = 'terrafile'
  spec.version       = Terrafile::VERSION
  spec.platform      = Gem::Platform::RUBY
  spec.authors       = ['dxw']
  spec.email         = ['ops@dxw.net']

  spec.summary       = 'Installs the modules listed in Terrafile'
  spec.description   = 'Terraform modules listed in Terrafile are installed in ' \
                         'vendor/terraform_modules'
  # spec.homepage      = "TODO: Put your gem's website or public repo URL here."
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # if spec.respond_to?(:metadata)
  spec.metadata['credit'] = 'Original found at: ' \
    'http://bensnape.com/2016/01/14/terraform-design-patterns-the-terrafile/'
  #   spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  #   spec.metadata["homepage_uri"] = spec.homepage
  #   spec.metadata["source_code_uri"] = "TODO: Put your gem's public repo URL here."
  #   spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."
  # else
  #   raise "RubyGems 2.0 or newer is required to protect against " \
  #     "public gem pushes."
  # end

  spec.files         = `git ls-files -z`.split('\n')
  spec.test_files    = `git ls-files -z -- spec/*`.split('\n')
  spec.bindir        = 'bin'
  spec.require_paths = ['lib']
  spec.executables   = ['terrafile']

  spec.add_development_dependency 'bundler', '~> 1.17'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
