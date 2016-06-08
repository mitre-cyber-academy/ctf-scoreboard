module Devise
  module Models
    module SecureValidatable
      module ClassMethods
        private

        def has_uniqueness_validation_of_login?
          return true if login_attribute == :email
          super
        end
      end
    end
  end
end