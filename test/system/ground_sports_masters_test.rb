require "application_system_test_case"

class GroundSportsMastersTest < ApplicationSystemTestCase
  setup do
    @ground_sports_master = ground_sports_masters(:one)
  end

  test "visiting the index" do
    visit ground_sports_masters_url
    assert_selector "h1", text: "Ground Sports Masters"
  end

  test "creating a Ground sports master" do
    visit ground_sports_masters_url
    click_on "New Ground Sports Master"

    fill_in "Ground", with: @ground_sports_master.ground_id
    fill_in "Sports master", with: @ground_sports_master.sports_master_id
    click_on "Create Ground sports master"

    assert_text "Ground sports master was successfully created"
    click_on "Back"
  end

  test "updating a Ground sports master" do
    visit ground_sports_masters_url
    click_on "Edit", match: :first

    fill_in "Ground", with: @ground_sports_master.ground_id
    fill_in "Sports master", with: @ground_sports_master.sports_master_id
    click_on "Update Ground sports master"

    assert_text "Ground sports master was successfully updated"
    click_on "Back"
  end

  test "destroying a Ground sports master" do
    visit ground_sports_masters_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Ground sports master was successfully destroyed"
  end
end
