module RedisBatchPush

  class Monitor
    def initialize getter, processor
      @getter = getter
      @processor = processor
    end

    def run
      @getter.restore_backups

      loop do
        if item = @getter.get_next_item
          @processor.process item
        else
          @processor.tick
        end
      end
    end
  end
end
