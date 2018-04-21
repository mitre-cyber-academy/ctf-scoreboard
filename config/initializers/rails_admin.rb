# RailsAdmin config file. Generated on February 18, 2013 13:52
# See github.com/sferik/rails_admin for more informations

RailsAdmin.config do |config|
  ################  Global configuration  ################

  # Set the admin name here (optional second array element will appear in red). For example:
  config.main_app_name = ['Ctf Registration', 'Admin']
  # or for a more dynamic name:
  # config.main_app_name = Proc.new { |controller| [Rails.application.engine_name.titleize, controller.params['action'].titleize] }

  # RailsAdmin may need a way to know who the current user is]
  config.current_user_method(&:current_user) # auto-generated

  config.authorize_with do
    redirect_to main_app.root_path unless current_user.try(:admin?)
  end

  config.model 'Game' do
    show do
      configure :resumes do
        formatted_value do
          bindings[:view].link_to('Download resume bundle', Rails.application.routes.url_helpers.resumes_game_path)
        end
      end
    end

    edit do
      [:start, :stop].each do |f|
        configure f do
          help "Required - Must be in UTC. Current time is #{Time.now.utc}"
        end
      end
    end
  end

  config.model 'Message' do
    configure :email_message do
      help 'Check this box to also email the message to all competitors'
    end
  end



  # If you want to track changes on your models:
  # config.audit_with :history, 'User'

  # Or with a PaperTrail: (you need to install it first)
  config.audit_with :paper_trail, 'User', 'PaperTrail::Version'
end
