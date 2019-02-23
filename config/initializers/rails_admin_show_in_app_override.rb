# frozen_string_literal: true
require 'rails_admin/config/actions'
require 'rails_admin/config/actions/show_in_app'

module RailsAdmin
  module Config
    module Actions
      class ShowInApp < RailsAdmin::Config::Actions::Base
        RailsAdmin::Config::Actions.register(self)

        register_instance_option :controller do
          proc do
            if @object.is_a?(Team)
              redirect_to main_app.url_for(controller: '/teams', action: 'summary', id: @object.id)
            else
              redirect_to main_app.url_for(@object)
            end
          end
        end
      end
    end
  end
end
