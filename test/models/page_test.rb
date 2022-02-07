require "test_helper"

class PageTest < ActiveSupport::TestCase
  def setup
    create(:active_game)
  end

  test 'page preview reflects body' do
    page = create(:page, title: 'Example Title', body: 'Example Body', path: 'page')

    assert_equal page.preview, 'Example Body'
  end
end
