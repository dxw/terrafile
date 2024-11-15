lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'terrafile/version'

Gem::Specification.new do |spec|
  spec.name                  = 'terrafile'
  spec.version               = Terrafile::VERSION
  spec.platform              = Gem::Platform::RUBY
  spec.required_ruby_version = '>= 3.1.6'
  spec.authors               = ['dxw']
  spec.email                 = ['systems@dxw.com']
  spec.summary               = 'Installs the modules listed in Terrafile'
  spec.description           = 'Terraform modules listed in Terrafile are installed in ' \
                                 'vendor/terraform_modules'
  spec.homepage              = 'https://github.com/dxw/terrafile'
  spec.license               = 'MIT'
  spec.post_install_message  = 'Thanks for installing terrafile.'

  if spec.respond_to?(:metadata)
    spec.metadata['credit'] = 'Original code and rationale found at: ' \
      'http://bensnape.com/2016/01/14/terraform-design-patterns-the-terrafile/'
  end

  spec.files         = `git ls-files`.split("\n")
  spec.test_files    = `git ls-files -- spec/*`.split("\n")
  spec.bindir        = 'bin'
  spec.require_paths = ['lib']
  spec.executables   = ['terrafile']

  spec.add_development_dependency 'aruba',      '~> 2.2'
  spec.add_development_dependency 'bundler',    '>= 2.1.0'
  spec.add_development_dependency 'pry-byebug', '~> 3.6'
  spec.add_development_dependency 'rake',       '~> 13.0'
  spec.add_development_dependency 'rspec',      '~> 3.8'
  spec.add_development_dependency 'rubocop',    '~> 1.68'
  spec.add_development_dependency 'simplecov',  '~> 0.1'
end
