require 'test_helper'

class ChallengesHelperTest < ActionView::TestCase
  test 'embed' do
    content = embed('https://www.youtube.com/watch?v=C0DPdy98e4c')
    assert_includes content, 'https://www.youtube.com/embed/C0DPdy98e4c?rel=0'
  end
end
