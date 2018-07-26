# Expressionist

Simple query language for tree structured data

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'expressionist'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install expressionist

## Usage

```ruby
require 'expressionist'

context = Expressionist::Context.new

context['some.key'] = 'value'

expression = Expressionist.compile('some.key == "value" AND count(some.*) == 1')

expression.call(context) # => true

context['some.key2'] = 'value'

expression.call(context) # => false

context.export # => {"some"=>{"key"=>{"."=>"value"}, "key2"=>{"."=>"value"}}}

tmp = expression.executable # => Array

another = Expressionist.compile(tmp)

another.call(context) # => false
```

## Contexts

Context defines tree data structure that can be queried. Data can be importad
from an existing `Hash` and can be exported using `context.export`. 

The `.` is used to separate the path. There can never be two `.` next to each
other and path can not start with a `.`. The `.` character can not be escaped.

Paths can only contain these `/[A-Za-z0-9.\-_]/` characters.

## Query language (expressions)

ToDo: update the section, ATM check the `lib/expressionist/grammar.rb` and
`lib/expressionist/functions/*.rb` files. 

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, 
run `rake test` to run the tests. You can also run `bin/console` for an 
interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. 
To release a new version, update the version number in `version.rb`, 
and then run `bundle exec rake release`, which will create a git tag for the 
version, push git commits and tags, and push the `.gem` file to 
[rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at 
[marekjelen/expressionist](https://github.com/marekjelen/expressionist).

## License

The gem is available as open source under the terms of the 
[MIT License](https://opensource.org/licenses/MIT).
