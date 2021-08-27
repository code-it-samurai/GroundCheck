require "test_helper"

class SportsMastersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @sports_master = sports_masters(:one)
  end

  test "should get index" do
    get sports_masters_url
    assert_response :success
  end

  test "should get new" do
    get new_sports_master_url
    assert_response :success
  end

  test "should create sports_master" do
    assert_difference('SportsMaster.count') do
      post sports_masters_url, params: { sports_master: { name: @sports_master.name } }
    end

    assert_redirected_to sports_master_url(SportsMaster.last)
  end

  test "should show sports_master" do
    get sports_master_url(@sports_master)
    assert_response :success
  end

  test "should get edit" do
    get edit_sports_master_url(@sports_master)
    assert_response :success
  end

  test "should update sports_master" do
    patch sports_master_url(@sports_master), params: { sports_master: { name: @sports_master.name } }
    assert_redirected_to sports_master_url(@sports_master)
  end

  test "should destroy sports_master" do
    assert_difference('SportsMaster.count', -1) do
      delete sports_master_url(@sports_master)
    end

    assert_redirected_to sports_masters_url
  end
end
