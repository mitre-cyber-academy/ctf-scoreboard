# frozen_string_literal: true

class CertificateGenerator
  class Helper
    def initialize(team, rank)
      @certs_directory = Rails.root.to_s + "/certs/#{team.division.name}-certificates"
      @template_file = Rails.root.to_s + '/certs/ctf-certificate-template.jpg'
      @team_name = team.team_name
      @score = team.score
      @transformed_name = transform(@team_name)
      @members = team.users
      @rank = rank
    end

    def generate_user_certificates(division_team_count)
      # Iterate over all users in members.
      Dir.mkdir(@certs_directory) unless Dir.exist?(@certs_directory)
      @members.each do |user|
        # Forward slashes in team name break paths, remove them.
        team_name_rmslashes = @team_name.delete("\/")
        team_cert_directory = "#{@certs_directory}/#{team_name_rmslashes}"
        Dir.mkdir(team_cert_directory) unless Dir.exist?(team_cert_directory)
        File.open("#{team_cert_directory}/team_member_emails.txt", 'a') do |file|
          file.write("#{user.full_name}: #{user.email}\n")
        end
        generate_certificate(user.full_name, team_cert_directory, division_team_count)
      end
    end

    def transform(display_name)
      temp = display_name.dup
      temp.downcase!
      temp.tr! ' ', '_'
      temp.tr! '@', 'a'
      temp.tr! '$', 's'
      temp.gsub!(/[^a-z0-9_]/, '')
      temp
    end

    private

    def generate_certificate(player_name, save_directory, division_team_count)
      dimensions = [720, 540]
      file_name = "#{save_directory}/#{transform(player_name)}.pdf"
      Prawn::Document.generate(file_name, background: @template_file, page_size: dimensions, margin: 0) do |doc|
        doc.image @template_file, at: [0, dimensions[1]], fit: dimensions
        doc.bounding_box([55, 200], width: 640, height: 200) do
          doc_stuff doc, player_name, division_team_count
        end
      end
    end

    def doc_stuff(doc, player_name, division_team_count)
      doc.font('Helvetica', size: 18, style: :bold) do
        doc.text "This is to certify that #{player_name}", color: '005BA1', align: :center, leading: 8
        doc.text "successfully competed as a member of Team #{@team_name},
achieving #{@score} points and finishing #{@rank} out of #{division_team_count} teams.", color: '005BA1', align: :center
      end
    end
  end

  def generate_all_certs
    Division.all.find_each do |division|
      division.ordered_teams.each do |team|
        help = Helper.new team, 1 + (division.ordered_teams.index team)
        help.generate_user_certificates(division.teams.size)
      end
    end
  end

  def path_generator(user)
    root = Rails.root.to_s + "/certs/#{user.team.division.name}-certificates"
    root + "/#{user.team.team_name.delete("\/")}/#{transform user.full_name}.pdf"
  end

  def transform(display_name)
    temp = display_name.dup
    temp.downcase!
    temp.tr! ' ', '_'
    temp.tr! '@', 'a'
    temp.tr! '$', 's'
    temp.gsub!(/[^a-z0-9_]/, '')
    temp
  end
end
