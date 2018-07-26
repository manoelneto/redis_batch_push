require 'securerandom'

module RedisBatchPush

  class Getter
    attr_reader :backup_queue

    def initialize redis_client, queue
      @redis_client = redis_client
      @queue = queue
      @backup_queue = "#{@queue}:backup:#{SecureRandom.hex}"
    end

    def get_next_item
      @redis_client.brpoplpush(
        @queue,
        @backup_queue,
        {
          timeout: 5
        }
      )
    end

    def clear_backup
      @redis_client.del(@backup_queue)
    end

    def restore_backups
      @redis_client.keys("#{@queue}:backup:*").each do |bkp_queue|
        loop do
          break unless @redis_client.rpoplpush(bkp_queue, @queue)
        end
        @redis_client.del(bkp_queue)
      end
    end
  end

end
