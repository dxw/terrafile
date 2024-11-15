# Terrafile

This gem provides a `terrafile` executable (Ruby) to install a Terraform project's modules using `git`. 

The idea of using a 'Terrafile' (like a 'Puppetfile' or a 'Gemfile') to manage a project's dependencies comes from Ben Snape and this code is based on his blog post [http://bensnape.com/2016/01/14/terraform-design-patterns-the-terrafile/](http://bensnape.com/2016/01/14/terraform-design-patterns-the-terrafile/).

Conventions:

- a project's modules are described in a `Terrafile` located at the root of the project
- terraform modules are installed in `vendor/terraform_modules`   


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'terrafile'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install terrafile

## Usage

Invoke the executable from your shell:

    $ terrafile

to install the modules listed in `Terrafile` into `vendor/terraform_modules`.

## Dependencies

- git
- Ruby (>= 3.1.6)

## Development

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

### Installing gem in development

- `gem build terrafile.gemspec`
- `gem install terrafile-*.gem`

Then you can run `$ terrafile` to run the latest version

### Tests

Run the test suite with: 

    rake test

The task will:

- run unit tests with 'rspec'
- enforce 100% coverage with 'simplecov'
- lint the Ruby code with 'rubocop'
- run integration tests with 'cucumber'

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/dxw/terrafile. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Terrafile project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/dxw/terrafile/blob/master/CODE_OF_CONDUCT.md).
