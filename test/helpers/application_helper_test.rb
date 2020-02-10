require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test 'amount of errors' do
    game = build(:active_pentest_game, title: nil)
    game.save
    errors = amount_of_errors(game.errors.full_messages.flatten)
    assert_includes errors, '1 error'

    game = build(:active_pentest_game, title: nil, contact_email: nil)
    game.save
    errors = amount_of_errors(game.errors.full_messages.flatten)
    assert_includes errors, '2 errors'
  end
end
