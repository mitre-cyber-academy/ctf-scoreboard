# frozen_string_literal: true

require 'zip'

class GamesController < ApplicationController
  before_action :load_game_with_users, :deny_if_not_admin, only: %i[resumes transcripts]
  before_action :load_users_and_divisions, only: %i[summary teams]
  before_action :deny_users_to_non_html_formats, :load_game_for_show_page, only: %i[show]
  before_action :filter_access_before_game_open, except: %i[new]
  before_action :load_game_graph_data, only: %i[summary]
  before_action :load_message_count, except: %i[new]

  def teams; end

  def show
    @challenges = @game&.challenges
    ActiveRecord::Precounter.new(@challenges).precount(:solved_challenges)
    @categories = @game&.categories
    @solved_challenges = current_user&.team&.solved_challenges&.map(&:challenge_id)
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

  def load_game_for_show_page
    @game = Game.includes(:categories).includes(:challenges).instance
  end

  def load_users_and_divisions
    @game = Game.includes(:divisions).instance
    @divisions = @game.divisions
    signed_in_not_admin = !current_user&.admin?
    @active_division = signed_in_not_admin && current_user&.team ? current_user&.team&.division : @divisions.first
  end

  def load_game_graph_data
    @flags_per_hour = SubmittedFlag.group_by_hour(:created_at).count
    @line_chart_data = [
      { name: 'Flag Submissions', data: @flags_per_hour },
      { name: 'Challenges Solved', data: SolvedChallenge.group_by_hour(:created_at).count }
    ]
  end

  def load_game_with_users
    @game = Game.includes(:users).instance
  end

  def deny_users_to_non_html_formats
    deny_if_not_admin unless request.format.html?
  end

  private

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
