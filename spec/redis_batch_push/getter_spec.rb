RSpec.describe RedisBatchPush::Getter do
  let(:redis) {
    MockRedis.new
  }

  let(:queue) { "queue" }

  subject { described_class.new(redis, queue) }

  context "get_next_item" do

    before(:each) do
      redis.lpush(queue, "1")
      redis.lpush(queue, "2")
      redis.lpush(queue, "3")
    end

    it "return item correctly" do
      expect(subject.get_next_item).to eql("1")
      expect(subject.get_next_item).to eql("2")
      expect(subject.get_next_item).to eql("3")
    end

    it "save in backup" do
      subject.get_next_item
      subject.get_next_item
      expect(redis.rpop(subject.backup_queue)).to eql("1")
      expect(redis.rpop(subject.backup_queue)).to eql("2")
      expect(redis.rpop(queue)).to eql("3")
    end
  end

  context "clear_backup" do

    before(:each) do
      redis.lpush(queue, "1")
      redis.lpush(queue, "2")
      redis.lpush(queue, "3")
    end

    before do
      subject.get_next_item
    end

    it "destroy backup queue" do
      subject.clear_backup
      expect(redis.exists(subject.backup_queue)).to be_falsey
    end
  end


  context "restore_backups" do

    before do
      redis.lpush(subject.backup_queue, "4")
      redis.lpush(subject.backup_queue, "5")
    end

    it "destroy backup queue" do
      expect(redis.exists(queue)).to be_falsey
      subject.restore_backups
      expect(redis.exists(queue)).to be_truthy
      expect(redis.exists(subject.backup_queue)).to be_falsey
      expect(subject.get_next_item).to eql("4")
      expect(subject.get_next_item).to eql("5")
    end
  end

end
