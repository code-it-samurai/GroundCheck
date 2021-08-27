require "application_system_test_case"

class GroundActivitiesTest < ApplicationSystemTestCase
  setup do
    @ground_activity = ground_activities(:one)
  end

  test "visiting the index" do
    visit ground_activities_url
    assert_selector "h1", text: "Ground Activities"
  end

  test "creating a Ground activity" do
    visit ground_activities_url
    click_on "New Ground Activity"

    click_on "Create Ground activity"

    assert_text "Ground activity was successfully created"
    click_on "Back"
  end

  test "updating a Ground activity" do
    visit ground_activities_url
    click_on "Edit", match: :first

    click_on "Update Ground activity"

    assert_text "Ground activity was successfully updated"
    click_on "Back"
  end

  test "destroying a Ground activity" do
    visit ground_activities_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Ground activity was successfully destroyed"
  end
end
