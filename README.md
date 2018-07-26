# RedisBatchPush

This gem provide a simple way to:

1. watch a data in a redis queue
2. cache this data (buffer)
3. process this buffered data by time

## Motivation

Sometimes you have a webserver that expect some data to come, and you have to save this data in a database. But this webserver receive a lot of requests per second, and saving in database is very expensive.

example:

your server receives:

```
POST /view -d '{id: 1}'
POST /view -d '{id: 1}'
POST /view -d '{id: 2}'
POST /view -d '{id: 1}'
POST /view -d '{id: 3}'
```

and for each post you should do

```
model = Table.find(id)
model.view += 1
model.save
```

with this gem you can reduce your data to make one incr by id

```
# in post
redis.lpush queue, view

# in other work
runner = RedisBatchPush::Runner.new(redis_client, queue, max_size, max_interval_sec)
runner.run do |views|
  views_by_id = views.inject({}) do |memo, item|
    memo[item["id"]] ||= 0
    memo[item["id"]] += 1
  end

  # Now you have to make 3 incr, 1 by id
  print views_by_id

  # {
  #   "1" => 3,
  #   "2" => 1,
  #   "3" => 1,
  # }
end

```


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'redis_batch_push'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install redis_batch_push

## Usage

See examples

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/manoelneto/redis_batch_push. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the RedisBatchPush project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/manoelneto/redis_batch_push/blob/master/CODE_OF_CONDUCT.md).
