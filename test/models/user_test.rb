require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  def setup
    @user_in_school = User.create!(
      full_name: "User one",
      email: "user4@test.com",
      affiliation: "School",
      year_in_school: 12,
      state: "FL",
      password: "TestPassword123",
    )
    @user_out_of_school = User.create!(
      full_name: "User two",
      email: "user5@test.com",
      affiliation: "Out of School",
      year_in_school: 0,
      state: "FL",
      password: "TestPassword123",
      compete_for_prizes: true,
    )
    @user_out_of_state = User.create!(
      full_name: "User two",
      email: "user6@test.com",
      affiliation: "Out of School",
      year_in_school: 12,
      state: "NA",
      password: "TestPassword123",
      compete_for_prizes: true,
    )
  end

  test "default compete for prizes value is false if none is provided" do
    assert_equal(false, @user_in_school.compete_for_prizes)
  end

  test "user must be in school to compete for prizes" do
    assert_equal(false, @user_out_of_school.compete_for_prizes)
  end

  test "user must be in the US to compete for prizes" do
    assert_equal(false, @user_out_of_state.compete_for_prizes)
  end

  test "user in the US can compete for prizes" do
    @user_out_of_state.state = "FL"
    @user_out_of_state.compete_for_prizes = true
    assert @user_out_of_state.save
    assert_equal(true, @user_out_of_state.compete_for_prizes)
  end
end
