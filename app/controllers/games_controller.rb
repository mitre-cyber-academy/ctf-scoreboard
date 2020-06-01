# frozen_string_literal: true

require 'zip'

class GamesController < ApplicationController
  include ApplicationModule

  before_action :load_game, only: %i[terms_and_conditions terms_of_service]

  before_action only: %i[resumes transcripts completion_certificate_template] do
    load_game(:users)
    deny_if_not_admin
  end
  before_action only: %i[summary teams] do
    load_game(:divisions)
    load_users_and_divisions
  end
  before_action only: %i[show] do
    deny_users_to_non_html_formats
    load_game(:categories, { challenges: :solved_challenges }, :teams, flags: { solved_challenges: :team })
  end
  before_action :filter_access_before_game_open
  before_action :load_game_graph_data, only: %i[summary]
  before_action :load_message_count

  def teams; end

  def terms_and_conditions; end

  def terms_of_service; end

  def show
    @pentest_challenges = @game&.pentest_challenges
    @point_challenges = @game&.point_challenges
    ActiveRecord::Precounter.new(@point_challenges).precount(:solved_challenges)
    ActiveRecord::Precounter.new(@pentest_challenges).precount(:solved_challenges)
    prepare_pentest_challenge_table # Always show PentestChallenges, no matter the Gameboard type
    prepare_challenge_table
    respond_to do |format|
      format.html
      format.markdown do
        render_to_string :show
      end
    end
  end

  def summary
    @view_all_teams_link = true
    respond_to do |format|
      format.html
      format.json { render json: { standings: @game.all_teams_information } }
    end
  end

  def resumes
    send_data create_zip_of('resume').read, filename: 'resumes.zip'
  end

  def transcripts
    send_data create_zip_of('transcript').read, filename: 'transcripts.zip'
  end

  def completion_certificate_template
    download_file(@game.completion_certificate_template, @game.title)
  end

  def load_users_and_divisions
    @divisions = @game.divisions
    signed_in_not_admin = !current_user&.admin?
    @active_division = signed_in_not_admin && current_user&.team ? current_user&.team&.division : @divisions.first
  end

  def load_game_graph_data
    @flags_per_hour = SubmittedFlag.group_by_hour(:created_at).count
    @line_chart_data = [
      { name: 'Flag Submissions', data: @flags_per_hour },
      { name: 'Challenges Solved', data: FeedItem.solved_challenges.group_by_hour(:created_at).count }
    ]
  end

  def deny_users_to_non_html_formats
    deny_if_not_admin unless request.format.html?
  end

  private

  def prepare_challenge_table
    # What information we need depends on the game mode we are in, however
    # we will always need a list of challenges
    @point_challenges = @game&.point_challenges
    if @game.jeopardy?
      @categories = @game.categories
    elsif @game.teams_x_challenges?
      # prepare_teams_x_challenges_table
    elsif @game.multiple_categories?
      # prepare_multiple_categories_table
    end
  end

  def prepare_pentest_challenge_table
    # The headings of the gameboard are either categories or teams, this loads based
    # on the STI model that the game is based on.
    # @teams = @game&.teams

    @pentest_table_heading = [OpenStruct.new(name: 'Teams'), @game&.pentest_challenges].flatten
    @teams_with_assoc = @game.teams_associated_with_flags_and_pentest_challenges
  end

  # Creates a zip from any collection of files available on the user model.
  # For example, create_zip_of('resume') will create a zip of all resumes
  # uploaded by all teams, broken out into the team folders.
  def create_zip_of(uploader)
    compressed_filestream = Zip::OutputStream.write_buffer do |zos|
      @game.users.each do |user|
        next unless (file_contents = user.send(uploader).read)

        zos.put_next_entry "#{uploader.pluralize}/#{user.team_id}/#{user.full_name}.pdf"
        zos.write file_contents
      end
    end

    compressed_filestream.rewind
    compressed_filestream
  end
end
