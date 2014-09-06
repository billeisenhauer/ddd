module DDD

  class DomainEvents

    class << self

      attr_writer :container

      def register(domain_event_class, &callback)
        add_callback_for(domain_event_class, &callback)
      end

      def clear_callbacks
        all_callbacks.clear
      end

      def raise(domain_event)
        handle_with_handlers_for(domain_event) if container
        call_callbacks_for(domain_event)
      end

      private

        attr_reader :container

        def all_callbacks
          Thread.current[all_callbacks_key] ||= {}
        end

        def all_callbacks_key
          self.name.gsub("::", "_").downcase
        end

        def callbacks_for(domain_event_class)
          key = callback_key_for(domain_event_class)
          all_callbacks.fetch(key, [])
        end

        def add_callback_for(domain_event_class, &callback)
          key = callback_key_for(domain_event_class)
          callbacks = all_callbacks.fetch(key, [])
          all_callbacks[key] = callbacks.push(callback)
        end

        def callback_key_for(domain_event_event)
          domain_event_event.name.downcase
        end

        def handle_with_handlers_for(domain_event)
          container.resolve_all.each do |handler|
            handler.handle(domain_event)
          end
        end

        def call_callbacks_for(domain_event)
          callbacks_for(domain_event.class).each do |callback|
            callback.call(domain_event)
          end
        end

    end

  end

end
