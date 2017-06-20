require 'test_helper'

class CertificateGeneratorTest < ActiveSupport::TestCase
  test 'transform replaces bad characters' do
    assert_equal 'abcs_123_', (CertificateGenerator.new.transform'@Bc$_#123!%^&*()] [')
  end

  test 'path generator works correctly' do
    user = users(:user_on_team_with_special_chars)
    assert_equal Rails.root.to_s + "/certs/High School-certificates/$0m3Thing @mazing/special_chars.pdf",
                 (CertificateGenerator.new.path_generator user)
  end

  test 'generate all certs' do
    CertificateGenerator.new.generate_all_certs
    Division.all.find_each do |division|
      division.ordered_teams.each do |team|
        team.users.each do |user|
          assert_equal true, (File.exist? (CertificateGenerator.new.path_generator user))
        end
      end
    end
  end

  test 'helper initialize' do
    team = teams(:team_with_special_chars)
    helper = CertificateGenerator::Helper.new team, 1
    assert_equal (Rails.root.to_s + "/certs/High School-certificates"), (helper.instance_variable_get :@certs_directory)
    assert_equal (Rails.root.to_s + '/certs/ctf-certificate-template.jpg'), (helper.instance_variable_get :@template_file)
    assert_equal team.team_name, (helper.instance_variable_get :@team_name)
    assert_equal team.score, (helper.instance_variable_get :@score)
    assert_equal team.users, (helper.instance_variable_get :@members)
    assert_equal 1, (helper.instance_variable_get :@rank)
    assert_equal (helper.transform team.team_name), (helper.instance_variable_get :@transformed_name)
  end

  test 'helper transform' do
    assert_equal 'abcs_123_', (CertificateGenerator::Helper.new(teams(:team_with_special_chars), 1).transform'@Bc$_#123!%^&*()] [')
  end
end