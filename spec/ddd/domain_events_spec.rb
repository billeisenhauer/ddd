require 'spec_helper'

module DDD

  describe DomainEvents do

    class FirstEvent; end
    class SecondEvent; end

    let(:first_event) { FirstEvent.new }
    let(:second_event) {SecondEvent.new }

    before(:each) do
      @event = nil
      @other_thread = Thread.new {
        DomainEvents.register(FirstEvent) do |e|
          @event = e
        end
      }
      DomainEvents.register(SecondEvent) do |e|
        @event = e
      end
    end

    it 'fires registered callback for currently running thread' do
      DomainEvents.raise(second_event)
      expect(@event).to eql(second_event)
    end

    it 'clears all registered callbacks' do
      DomainEvents.clear_callbacks
      DomainEvents.raise(second_event)
      expect(@event).to be_nil
    end

  end

end
