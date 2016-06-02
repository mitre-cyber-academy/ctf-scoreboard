require 'test_helper'

class TeamTest < ActiveSupport::TestCase
  test "team with ineligible user is ineligible for prizes" do
    assert_equal(false, teams(:team_one).eligible_for_prizes?)
  end

  test "team with one eligible user and one ineligible is ineligible for prizes" do
    teams(:team_one).users << users(:user_two)
    assert_equal(false, teams(:team_one).eligible_for_prizes?)
  end

  test "team with two eligible users is eligible for prizes" do
    teams(:team_one).users << users(:user_two)
    users(:user_one).compete_for_prizes = true 
    assert_equal(false, teams(:team_one).eligible_for_prizes?)
  end  
end
