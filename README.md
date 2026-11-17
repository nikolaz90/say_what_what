# SayWhatWhat
Error logging for Rails projects with very little setup.
Just an error panel and a few config variables in an initializer.
Inspired by Devise, Good Job and many other great gems.
Currently testing on postgres, though may cover other DBs at some point.

## Installation
Add this line to your application's Gemfile:

```ruby
gem "say_what_what", git: "https://github.com/nikolaz90/say_what_what"
```

And then execute:
```bash
$ bundle
```

Generate a migration file with:
This will add 2 tables, one for errors, and one for each occurrence of that error.
```bash
bin/rails g say_what_what:install
```

Run the migration with:
```bash
bin/rails db:migrate
```

Mount the engine in the routes.rb file, ideally with admin constraint:
```ruby
  authenticate :user, ->(user) { user.admin? } do
    mount SayWhatWhat::Engine => '/error_panel' # or mount SayWhatWhat::Engine => '/any_path_other_path
  end
```

## config options
Optional config options can be configured in an initializer file like this
```ruby
# config/initilizers/say_what_what.rb
SayWhatWhat.configuration do |config|
  # config.active is a boolean that activates persisitance to the db.
  config.active = ['development', 'production'].include?(Rails.env)
  # config.exempt_path_matchers is an array of strings or regexes, that uses the ruby .match? method on paths. If a route matches a value in this array, the error will be ignored.
  config.exempt_path_matchers << /path_that_is_prone_to_errors/
  # config.exempt_error_class_matchers is an array of strings or regexes, that uses the ruby .match? method on error_classes. If an errors error_class matches a value in this array, the error will be ignored.
  config.exempt_error_class_matchers << 'ActionController::RoutingError'
  # config.max_occurrences_per_error is an integer value. When an error has accumulated this number of occurrences, the following occurrences are ignored. If not added, or if config.max_occurrences_per_error.nil? for some reason, unlimited numbers of occurrences will be persisted per error.
  config.max_occurrences_per_error = 50
end
```

## Development
Run `bundle` to set up dependencies and run `rspec spec` to run the tests.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
