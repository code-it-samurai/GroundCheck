require "application_system_test_case"

class UserSportsMastersTest < ApplicationSystemTestCase
  setup do
    @user_sports_master = user_sports_masters(:one)
  end

  test "visiting the index" do
    visit user_sports_masters_url
    assert_selector "h1", text: "User Sports Masters"
  end

  test "creating a User sports master" do
    visit user_sports_masters_url
    click_on "New User Sports Master"

    fill_in "Sports master", with: @user_sports_master.sports_master_id
    fill_in "User", with: @user_sports_master.user_id
    click_on "Create User sports master"

    assert_text "User sports master was successfully created"
    click_on "Back"
  end

  test "updating a User sports master" do
    visit user_sports_masters_url
    click_on "Edit", match: :first

    fill_in "Sports master", with: @user_sports_master.sports_master_id
    fill_in "User", with: @user_sports_master.user_id
    click_on "Update User sports master"

    assert_text "User sports master was successfully updated"
    click_on "Back"
  end

  test "destroying a User sports master" do
    visit user_sports_masters_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "User sports master was successfully destroyed"
  end
end
