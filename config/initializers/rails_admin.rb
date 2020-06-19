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
      [:resumes, :transcripts].each do |title|
        configure title do
          formatted_value do
            bindings[:view].link_to("Download #{title.to_s.singularize} bundle", Rails.application.routes.url_helpers.send("#{title}_game_path"))
          end
        end
      end
    end

    edit do
      [:teams, :challenges, :users, :feed_items, :divisions, :messages, :solved_challenges, :categories, :achievements].each do |field|
        configure field do
          hide
        end
      end

      [:start, :stop].each do |f|
        configure f do
          help "Required - Must be in UTC."
        end
      end

      configure :load_js, :hidden do
        def render
          bindings[:view].render partial: 'show_hide_js'
        end
      end
    end
  end

  config.model 'Message' do
    configure :email_message do
      help 'Check this box to also email the message to all competitors'
    end
  end

  config.model 'User' do
    # Have to disable filtering on this since it is an integer and it
    # breaks search
    configure :year_in_school do
      searchable false
    end

    list do
      scopes [nil, :interested_in_employment]
    end
  end

  config.model 'PentestChallenge' do
    edit do
      configure :load_js, :hidden do
        def render
          bindings[:view].render partial: 'show_hide_js'
        end
      end
    end
  end

  config.model 'StandardChallenge' do
    edit do
      configure :load_js, :hidden do
        def render
          bindings[:view].render partial: 'show_hide_js'
        end
      end
    end
  end

  config.model 'ShareChallenge' do
    edit do
      configure :load_js, :hidden do
        def render
          bindings[:view].render partial: 'show_hide_js'
        end
      end
    end
  end

  # If you want to track changes on your models:
  # config.audit_with :history, 'User'

  # Or with a PaperTrail: (you need to install it first)
  config.audit_with :paper_trail, 'User', 'PaperTrail::Version'
end
