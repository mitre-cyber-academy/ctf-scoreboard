require 'test_helper'

class CompetitionCertificateTemplateUploaderTest < ActionDispatch::IntegrationTest
  def setup
    @game = create(:active_point_game, enable_completion_certificates: true)
  end

  test 'filename' do
    assert @game.completion_certificate_template.filename, 'ctf-certificate-template.jpg'
  end

  test 'url' do
    assert @game.completion_certificate_template.url, '/game/completion_certificate_template'
  end
end
