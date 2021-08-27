require "application_system_test_case"

class GroundsTest < ApplicationSystemTestCase
  setup do
    @ground = grounds(:one)
  end

  test "visiting the index" do
    visit grounds_url
    assert_selector "h1", text: "Grounds"
  end

  test "creating a Ground" do
    visit grounds_url
    click_on "New Ground"

    fill_in "Business email", with: @ground.business_email
    fill_in "Business phone", with: @ground.business_phone
    fill_in "Closing time", with: @ground.closing_time
    fill_in "Cost per hour", with: @ground.cost_per_hour
    fill_in "Ground name", with: @ground.ground_name
    fill_in "Ground pincode", with: @ground.ground_pincode
    fill_in "Opening time", with: @ground.opening_time
    click_on "Create Ground"

    assert_text "Ground was successfully created"
    click_on "Back"
  end

  test "updating a Ground" do
    visit grounds_url
    click_on "Edit", match: :first

    fill_in "Business email", with: @ground.business_email
    fill_in "Business phone", with: @ground.business_phone
    fill_in "Closing time", with: @ground.closing_time
    fill_in "Cost per hour", with: @ground.cost_per_hour
    fill_in "Ground name", with: @ground.ground_name
    fill_in "Ground pincode", with: @ground.ground_pincode
    fill_in "Opening time", with: @ground.opening_time
    click_on "Update Ground"

    assert_text "Ground was successfully updated"
    click_on "Back"
  end

  test "destroying a Ground" do
    visit grounds_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Ground was successfully destroyed"
  end
end
