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

  config.show_gravatar = false

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
    bulk_delete
    # member actions
    show
    edit do
      except ['Challenge', 'FeedItem', 'SolvedChallenge', 'Flag'] # Block users editing items from their parent classes instead of their own classes (because there are different variables for each challenge type which can't be displayed)
    end
    delete
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
      [
        :teams,
        :challenges,
        :users,
        :feed_items,
        :divisions,
        :messages,
        :solved_challenges,
        :categories,
        :achievements
      ].each do |field|
        configure field do
          hide
        end
      end
      [:start, :stop].each do |f|
        configure f do
          help "Required - Must be in UTC."
        end
      end
      field :title
      field :start
      field :stop
      field :description
      field :board_layout
      field :team_size
      field :organization
      field :contact_email
      field :prizes_available
      field :prizes_text
      field :enable_completion_certificates
      field :completion_certificate_template
      field :recruitment_text
      field :open_source_url
      field :request_team_location
      field :location_required
      field :contact_url
      field :footer
      field :terms_of_service
      field :terms_and_conditions
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
    edit do
      field :name
      field :game
    end # Users should change challenge categories from the challenge itself
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
    edit do
      [
        :sponsor,
        :sponsor_logo,
        :sponsor_description
      ].each do |title|
        configure title do
          css_class do
            "#{self.name}_field sponsorship_fields_toggle"
          end
        end
      end
      configure :sponsored do
        css_class do
          "#{self.name}_field sponsorship_fields_toggler"
        end
      end
    end
  end

  config.model 'StandardChallenge' do
    edit do
      [
        :sponsor,
        :sponsor_logo,
        :sponsor_description
      ].each do |title|
        configure title do
          css_class do
            "#{self.name}_field sponsorship_fields_toggle"
          end
        end
      end
      configure :sponsored do
        css_class do
          "#{self.name}_field sponsorship_fields_toggler"
        end
      end
      [
        :challenge_categories,
        :submitted_flags,
        :solved_challenges,
        :unsolved_increment_period,
        :unsolved_increment_points,
        :defense_period,
        :defense_points,
        :type,
        :initial_shares,
        :solved_decrement_shares,
        :solved_decrement_period,
        :first_capture_point_bonus
      ].each do |field|
        configure field do
          hide
        end
      end
    end
    list do
      field :name
      field :description
      field :categories
      field :point_value
      field :created_at
    end
  end

  config.model 'ShareChallenge' do
    edit do
      [
        :sponsor,
        :sponsor_logo,
        :sponsor_description
      ].each do |title|
        configure title do
          css_class do
            "#{self.name}_field sponsorship_fields_toggle"
          end
        end
      end
      configure :sponsored do
        css_class do
          "#{self.name}_field sponsorship_fields_toggler"
        end
      end
      [
        :challenge_categories,
        :submitted_flags,
        :solved_challenges,
        :type
      ].each do |field|
        configure field do
          hide
        end
      end
    end
    list do
      field :name
      field :description
      field :categories
      field :point_value
      field :created_at
    end
  end

  config.model 'FileSubmissionChallenge' do
    edit do
      [
        :sponsor,
        :sponsor_logo,
        :sponsor_description
      ].each do |title|
        configure title do
          css_class do
            "#{self.name}_field sponsorship_fields_toggle"
          end
        end
      end
      configure :sponsored do
        css_class do
          "#{self.name}_field sponsorship_fields_toggler"
        end
      end
      [
        :defense_period,
        :defense_points,
        :unsolved_increment_period,
        :unsolved_increment_points,
        :initial_shares,
        :solved_decrement_shares,
        :first_capture_point_bonus,
        :solved_decrement_period,
        :submitted_flags
      ].each do |field|
        configure field do
          hide
        end
      end
    end
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
    edit do
      field :name
      field :game
      field :min_year_in_school
      field :max_year_in_school
      field :teams
    end
    list do
      field :name
      field :teams
      field :min_year_in_school
      field :max_year_in_school
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
    edit do
      field :user
      field :team
      field :text
      field :challenge
      field :point_value
    end
    list do
      field :user
      field :team
      field :division
      field :text
      field :challenge
    end
  end

  config.model 'ScoreAdjustment' do
    edit do
      field :user
      field :team
      field :text
      field :challenge
      field :point_value
    end
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
    edit do
      field :user
      field :team
      field :division
      field :challenge
      field :point_value
      field :flag
    end
    list do
      field :user
      field :team
      field :division
      field :text
      field :challenge
    end
  end

  config.model 'StandardSolvedChallenge' do
    edit do
      field :user
      field :team
      field :division
      field :challenge
      field :point_value
      field :flag
    end
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
    edit do
      field :challenge
      field :flag
      field :api_url
      field :video_url
      field :team
      field :challenge_state
      field :start_calculation_at
    end
    list do
      field :challenge
      field :flag
      field :api_url
      field :video_url
    end
  end

  config.model 'StandardFlag' do
    edit do
      field :challenge
      field :flag
      field :api_url
      field :video_url
      field :start_calculation_at
    end
    list do
      field :challenge
      field :flag
      field :api_url
      field :video_url
    end
  end

  config.model 'Game' do
    edit do
      field :title
      field :start
      field :stop
      field :description
      field :registration_enabled
      field :board_layout
      field :team_size
      field :organization
      field :contact_email
      field :prizes_available
      field :employment_opportunities_available
      field :prizes_text
      field :enable_completion_certificates
      field :completion_certificate_template
      field :footer
      field :contact_url
      field :recruitment_text
      field :open_source_url
      field :terms_of_service
      field :terms_and_conditions
    end
    list do
      field :title
      field :start
      field :stop
      field :description
      field :board_layout
      field :prizes_available
      field :enable_completion_certificates
    end
  end

  config.model 'Message' do
    edit do
      field :title
      field :text
      field :game
      field :email_message
    end
    list do
      field :title
      field :text
      field :game
      field :email_message
    end
  end

  config.model 'SubmittedFlag' do
    edit do
      field :challenge
      field :user
      field :text
    end
    list do
      field :challenge
      field :user
      field :text
    end
  end

  config.model 'PentestSubmittedFlag' do
    edit do
      field :challenge
      field :user
      field :text
      field :flag
    end
    list do
      field :challenge
      field :user
      field :text
      field :flag
    end
  end

  config.model 'FileSubmission' do
    edit do
      field :challenge
      field :user
      field :submitted_bundle
      field :description
      field :demoed
    end
    list do
      field :challenge
      field :user
      field :submitted_bundle
      field :description
      field :demoed
    end
  end

  config.model 'Team' do
    edit do
      field :team_name
      field :affiliation
      field :team_captain
      field :division
      field :eligible
    end
    list do
      field :team_name
      field :affiliation
      field :team_captain
      field :division
    end
  end

  config.model 'User' do
    edit do
      field :full_name
      field :email
      field :affiliation
      field :year_in_school.to_s
      field :age
      field :area_of_study
      field :location
      field :personal_email
      field :state
      field :compete_for_prizes
      field :country
      field :interested_in_employment
      field :resume
      field :transcript
      field :password
      field :password_confirmation
      field :reset_password_sent_at
      field :remember_created_at
      field :current_sign_in_at
      field :current_sign_in_ip
      field :last_sign_in_ip
      field :confirmed_at
      field :confirmation_sent_at
      field :unconfirmed_email
      field :submitted_flags
    end
    list do
      field :full_name
      field :email
      field :age
      field :current_sign_in_at
      field :sign_in_count
      field :interested_in_employment
    end
  end

  config.model 'UserInvite' do
    edit do
      field :email
      field :team
      field :user
      field :status
    end
    list do
      field :email
      field :team
      field :user
      field :status
    end
  end

  config.model 'UserRequest' do
    edit do
      field :team
      field :user
      field :status
    end
    list do
      field :team
      field :user
      field :created_at
      field :status
    end
  end

  # If you want to track changes on your models:
  # config.audit_with :history, 'User'

  # Or with a PaperTrail: (you need to install it first)
  config.audit_with :paper_trail, 'User', 'PaperTrail::Version'
end
