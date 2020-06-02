# frozen_string_literal: true

module StiPreload
  unless Rails.application.config.eager_load
    extend ActiveSupport::Concern

    included do
      cattr_accessor :preloaded, instance_accessor: false
    end

    class_methods do
      def descendants
        preload_sti unless preloaded
        super
      end

      # Constantizes all types present on the model
      def preload_sti
        base_class.type_enum.flatten.map(&:constantize)

        self.preloaded = true
      end
    end
  end
end
