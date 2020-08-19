require "application_system_test_case"

class SurveysTest < ApplicationSystemTestCase
  setup do
    @survey = surveys(:one)
  end

  test "visiting the index" do
    visit surveys_url
    assert_selector "h1", text: "Surveys"
  end

  test "creating a Survey" do
    visit surveys_url
    click_on "New Survey"

    fill_in "Comment", with: @survey.comment
    fill_in "Difficulty", with: @survey.difficulty
    fill_in "Interest", with: @survey.interest
    fill_in "Realism", with: @survey.realism
    fill_in "Submitted flag", with: @survey.submitted_flag_id
    click_on "Create Survey"

    assert_text "Survey was successfully created"
    click_on "Back"
  end

  test "updating a Survey" do
    visit surveys_url
    click_on "Edit", match: :first

    fill_in "Comment", with: @survey.comment
    fill_in "Difficulty", with: @survey.difficulty
    fill_in "Interest", with: @survey.interest
    fill_in "Realism", with: @survey.realism
    fill_in "Submitted flag", with: @survey.submitted_flag_id
    click_on "Update Survey"

    assert_text "Survey was successfully updated"
    click_on "Back"
  end

  test "destroying a Survey" do
    visit surveys_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Survey was successfully destroyed"
  end
end
