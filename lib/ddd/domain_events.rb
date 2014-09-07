module DDD

  class DomainEvents

    class << self

      attr_writer :container

      def register(*events, &callback)
        events.each { |e| add_callback_for(e, &callback) }
      end

      def clear_callbacks
        all_callbacks.clear
      end

      def raise(*events)
        events.each do |e|
          handle_with_handlers_for(e) if container
          call_callbacks_for(e)
        end
      end

      private

        attr_reader :container, :key_generator

        def key_generator
          @key_generator ||= DomainEventKeyGenerator.new
        end

        def all_callbacks
          Thread.current[all_callbacks_key] ||= {}
        end

        def all_callbacks_key
          self.name.gsub("::", "_").downcase
        end

        def add_callback_for(event, &callback)
          event_key = key_generator.key_from(event)
          callbacks = all_callbacks.fetch(event_key, [])
          all_callbacks[event_key] = callbacks.push(callback)
        end

        def callbacks_for(event)
          event_key = key_generator.key_from(event)
          all_callbacks.inject([]) do |matching_cbs, (cb_key, cbs)|
            cb_key == event_key ? matching_cbs.push(*cbs) : matching_cbs
          end
        end

        def call_callbacks_for(event)
          callbacks_for(event).each do |callback|
            callback.call(event)
          end
        end

        def handle_with_handlers_for(event)
          container.resolve_all.each do |handler|
            handler.handle(event)
          end
        end

    end

    class DomainEventKeyGenerator

      def key_from(event)
        unless [String, Symbol, Class].include?(event.class)
          event.class
        else
          event
        end.to_s
      end

    end

  end

end
