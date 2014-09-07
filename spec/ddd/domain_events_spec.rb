require 'spec_helper'

module DDD

  describe DomainEvents do

    class RecordSaved; end
    class RecordRemoved; end

    let(:record_saved) { RecordSaved.new }
    let(:record_removed) { RecordRemoved.new }
    let(:events) { [] }

    before(:each) do
      @background_thread = Thread.new {
        DomainEvents.register(RecordSaved) do |e|
          @events << e
        end
      }
      DomainEvents.register(RecordRemoved) do |e|
        events << e
      end
      DomainEvents.register("record_viewed") do |e|
        events << e
      end
      DomainEvents.register(:record_created) do |e|
        events << e
      end
      DomainEvents.register(:case_opened, :case_closed) do |e|
        events << e
      end
    end

    it 'fires registered event class callback for current thread' do
      DomainEvents.raise(record_removed)
      expect(events).to eql([record_removed])
    end

    it 'fires registered event string callback for current thread' do
      DomainEvents.raise("record_viewed")
      expect(events).to eql(["record_viewed"])
    end

    it 'fires registered event symbol callback for current thread' do
      DomainEvents.raise(:record_created)
      expect(events).to eql([:record_created])
    end

    it 'fires registered event symbol (from array) callback for current thread' do
      DomainEvents.raise(:case_opened, :case_closed)
      expect(events).to eql([:case_opened, :case_closed])
    end

    it 'clears all registered callbacks' do
      DomainEvents.clear_callbacks
      DomainEvents.raise(record_removed)
      expect(events).to be_empty
    end

  end

end
