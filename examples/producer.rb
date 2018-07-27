require "redis_batch_push"
require "securerandom"
require "redis"

queue = "redis_batch_push::example_queue"
# localhost
redis = Redis.new


loop do
  data = SecureRandom.hex
  p "pushing #{data}"
  redis.lpush(queue, data)

  # if you want to see data printed by size
  sleep 0.1

  # if you want to see data printed by ellapsed time
  # sleep 1
end
