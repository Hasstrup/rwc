[![CI](https://github.com/Hasstrup/rwc/actions/workflows/ci.yml/badge.svg?branch=main)](https://github.com/Hasstrup/rwc/actions/workflows/ci.yml)

# RwC (Rails with Context!)

This gem helps with generating services, inputs, decorators for Context-Based Rails Applications - A hexagonal way to build rails applications. Wrote about this [here](https://medium.com/@HasstrupEzekiel/context-based-programming-in-rails-0ce951a59c36). 


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rwc'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install rwc

## Usage

```bash
  # generating services
  rails generate rwc:service AnExampleService

  # generating inputs
  rails generate rwc:input AnExampleInput::WithNameSpace

  # generating decorators
  rails generate rwc:decorator AnExampleDecorator::WithDecorators
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on [GitHub](https://github.com/hasstrup/rwc). This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the RwC project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](CODE_OF_CONDUCT.md).


