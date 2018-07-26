require "redis_batch_push/version"
require "redis_batch_push/monitor"
require "redis_batch_push/getter"
require "redis_batch_push/processor"

module RedisBatchPush

  class Runner
    def initialize redis_client, queue, max_size=nil, max_interval_sec=nil
      @redis_client = redis_client
      @queue = queue
      @max_size = max_size
      @max_interval_sec = max_interval_sec
    end

    def run &block
      getter = Getter.new(@redis_client, @queue)
      blk = Proc.new do |data|
        yield data
        getter.clear_backup
      end
      processor = Processor.new(blk, @max_size, @max_interval_sec)
      monitor = Monitor.new(getter, processor)
      monitor.run
    end
  end

end
