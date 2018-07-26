module RedisBatchPush

  class Processor
    def initialize block, max_size=nil, max_interval_sec=nil
      @max_size = max_size
      @max_interval_sec = max_interval_sec
      validate!
      @block = block

      initialize_buffer
    end

    def initialize_buffer
      @buffer = []
      @buffer_start_time = Time.now
    end

    def validate!
      if @max_size.nil? && @max_interval_sec.nil?
        raise "You must inform max_size or max_interval_sec"
      end
    end

    def process_current_time
      Time.now
    end

    def must_send
      by_buffer_size = @max_size && @buffer.size >= @max_size
      by_interval_passed = @max_interval_sec && process_current_time - @buffer_start_time >= @max_interval_sec

      by_buffer_size || by_interval_passed
    end

    def tick
      if must_send && @buffer.size > 0
        @block.call(@buffer)
        initialize_buffer
      end
    end

    def process item
      @buffer << item
      tick
    end
  end
end
