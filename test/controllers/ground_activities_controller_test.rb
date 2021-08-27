require "test_helper"

class GroundActivitiesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @ground_activity = ground_activities(:one)
  end

  test "should get index" do
    get ground_activities_url
    assert_response :success
  end

  test "should get new" do
    get new_ground_activity_url
    assert_response :success
  end

  test "should create ground_activity" do
    assert_difference('GroundActivity.count') do
      post ground_activities_url, params: { ground_activity: {  } }
    end

    assert_redirected_to ground_activity_url(GroundActivity.last)
  end

  test "should show ground_activity" do
    get ground_activity_url(@ground_activity)
    assert_response :success
  end

  test "should get edit" do
    get edit_ground_activity_url(@ground_activity)
    assert_response :success
  end

  test "should update ground_activity" do
    patch ground_activity_url(@ground_activity), params: { ground_activity: {  } }
    assert_redirected_to ground_activity_url(@ground_activity)
  end

  test "should destroy ground_activity" do
    assert_difference('GroundActivity.count', -1) do
      delete ground_activity_url(@ground_activity)
    end

    assert_redirected_to ground_activities_url
  end
end
