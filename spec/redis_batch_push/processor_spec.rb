RSpec.describe RedisBatchPush::Processor do

  let(:max_size) {
    nil
  }

  let(:max_interval_sec) {
    nil
  }


  def make_subject block
    described_class.new(
      block,
      max_size,
      max_interval_sec
    )
  end

  context "when max_size is 2" do
    let(:max_size) { 2 }

    it "should call my block correctly" do
      called_itens = []
      block = Proc.new do |itens|
        called_itens << itens
      end
      the_subject = make_subject block
      the_subject.process 1
      the_subject.process 2
      the_subject.process 3
      the_subject.process 4

      expect(called_itens).to eql([[1, 2], [3, 4]])
    end

  end


  context "when max_size is 4" do
    let(:max_interval_sec) { 4 }

    it "should call my block correctly" do
      called_itens = []
      block = Proc.new do |itens|
        called_itens << itens
      end
      the_subject = make_subject block
      the_subject.process 1
      the_subject.process 2
      allow(the_subject).to receive(:process_current_time).and_return(Time.now + 10)
      the_subject.process 3

      expect(called_itens).to eql([[1, 2, 3]])
    end

  end

end
