require 'test_helper'

class PagesDisplayModesTest < ActionDispatch::IntegrationTest
  include TeamsHelper
  include Devise::Test::IntegrationHelpers

  def setup
    @game = create(:active_game)
  end

  test 'page list displays correctly when there are pages' do
    page = create(:page, title: 'Example Title', body: 'Example Body', path: 'page')

    get "/game/pages"
    assert_select 'div[class=page]' do
      assert_select 'a', /Example Title/
      assert_select 'a', :href => /game\/pages\/page/
    end
  end

  test 'no pages show when there are no pages' do
    get "/game/pages"
    assert_select 'h4[class=zero-items-text]', /No Pages/
  end

  test 'page displays contents correctly' do
    page = create(:page, title: 'Example Title', body: 'Example Body', path: 'page')

    get "/game/pages/page"
    assert_select 'div[class=title]', /Example Title/
    assert_select 'div[class=body]', /Example Body/
  end

  test 'template page displays when page has no contents' do
    page = create(:page, title: nil, body: nil, path: 'page')

    get "/game/pages/page"
    assert_select 'div[class=title]', /Page/
    assert_select 'div[class=body]', /This page is empty/
  end

end
