require "redis_batch_push"
require "redis"

queue = "redis_batch_push::example_queue"
# localhost
redis = Redis.new
max_interval_sec = 30
max_size = 20

t = Time.now

runner = RedisBatchPush::Runner.new(redis, queue, max_size, max_interval_sec)
runner.run do |data|
  p 'data will be an array'
  p "got some data #{data.size} #{data}"
  p "ellapsed time #{Time.now - t}"
  t = Time.now
end
