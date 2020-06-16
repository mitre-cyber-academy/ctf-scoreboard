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

  config.actions do
    # root actions
    dashboard                     # mandatory
    # collection actions 
    index                         # mandatory
    new do
      except ['Challenge', 'FeedItem', 'SolvedChallenge', 'Flag'] # Block users from adding items from their parent classes instead of their own classes
    end
    export
    history_index
    bulk_delete
    # member actions
    show
    edit
    delete
    history_show
    show_in_app
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

  config.model 'Category' do
    list do
      field :name
      field :created_at
      field :updated_at
    end
  end

  config.model 'Challenge' do
    list do
      field :name
      field :description
      field :categories
      field :point_value
      field :created_at
    end
  end

  config.model 'PentestChallenge' do
    list do
      field :name
      field :description
      field :categories
      field :point_value
      field :created_at
    end
  end

  config.model 'StandardChallenge' do
    list do
      field :name
      field :description
      field :categories
      field :point_value
      field :created_at
    end
  end

  config.model 'ShareChallenge' do
    list do
      field :name
      field :description
      field :categories
      field :point_value
      field :created_at
    end
  end

  config.model 'ChallengeCategory' do
    visible false
  end

  config.model 'Division' do
    list do
      field :name
      field :teams
    end
  end

  config.model 'FeedItem' do
    list do
      field :user
      field :team
      field :division
      field :text
      field :challenge
    end
  end

  config.model 'Achievement' do
    list do
      field :user
      field :team
      field :division
      field :text
      field :challenge
    end
  end

  config.model 'ScoreAdjustment' do
    list do
      field :user
      field :team
      field :division
      field :text
      field :challenge
    end
  end

  config.model 'SolvedChallenge' do
    list do
      field :user
      field :team
      field :division
      field :text
      field :challenge
    end
  end

  config.model 'PentestSolvedChallenge' do
    list do
      field :user
      field :team
      field :division
      field :text
      field :challenge
    end
  end

  config.model 'StandardSolvedChallenge' do
    list do
      field :user
      field :team
      field :division
      field :text
      field :challenge
    end
  end

  config.model 'Flag' do
    list do
      field :challenge_id
      field :flag
      field :api_url
      field :video_url
    end
  end

  config.model 'DefenseFlag' do
    list do
      field :challenge
      field :flag
      field :api_url
      field :video_url
    end
  end

  config.model 'StandardFlag' do
    list do
      field :challenge
      field :flag
      field :api_url
      field :video_url
    end
  end

  config.model 'Game' do
    list do
      field :title
      field :start
      field :stop
      field :description
    end
  end

  # If you want to track changes on your models:
  # config.audit_with :history, 'User'

  # Or with a PaperTrail: (you need to install it first)
  config.audit_with :paper_trail, 'User', 'PaperTrail::Version'
end
