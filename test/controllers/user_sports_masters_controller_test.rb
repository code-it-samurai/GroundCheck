require "test_helper"

class UserSportsMastersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user_sports_master = user_sports_masters(:one)
  end

  test "should get index" do
    get user_sports_masters_url
    assert_response :success
  end

  test "should get new" do
    get new_user_sports_master_url
    assert_response :success
  end

  test "should create user_sports_master" do
    assert_difference('UserSportsMaster.count') do
      post user_sports_masters_url, params: { user_sports_master: { sports_master_id: @user_sports_master.sports_master_id, user_id: @user_sports_master.user_id } }
    end

    assert_redirected_to user_sports_master_url(UserSportsMaster.last)
  end

  test "should show user_sports_master" do
    get user_sports_master_url(@user_sports_master)
    assert_response :success
  end

  test "should get edit" do
    get edit_user_sports_master_url(@user_sports_master)
    assert_response :success
  end

  test "should update user_sports_master" do
    patch user_sports_master_url(@user_sports_master), params: { user_sports_master: { sports_master_id: @user_sports_master.sports_master_id, user_id: @user_sports_master.user_id } }
    assert_redirected_to user_sports_master_url(@user_sports_master)
  end

  test "should destroy user_sports_master" do
    assert_difference('UserSportsMaster.count', -1) do
      delete user_sports_master_url(@user_sports_master)
    end

    assert_redirected_to user_sports_masters_url
  end
end
