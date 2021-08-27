require "test_helper"

class GroundSportsMastersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @ground_sports_master = ground_sports_masters(:one)
  end

  test "should get index" do
    get ground_sports_masters_url
    assert_response :success
  end

  test "should get new" do
    get new_ground_sports_master_url
    assert_response :success
  end

  test "should create ground_sports_master" do
    assert_difference('GroundSportsMaster.count') do
      post ground_sports_masters_url, params: { ground_sports_master: { ground_id: @ground_sports_master.ground_id, sports_master_id: @ground_sports_master.sports_master_id } }
    end

    assert_redirected_to ground_sports_master_url(GroundSportsMaster.last)
  end

  test "should show ground_sports_master" do
    get ground_sports_master_url(@ground_sports_master)
    assert_response :success
  end

  test "should get edit" do
    get edit_ground_sports_master_url(@ground_sports_master)
    assert_response :success
  end

  test "should update ground_sports_master" do
    patch ground_sports_master_url(@ground_sports_master), params: { ground_sports_master: { ground_id: @ground_sports_master.ground_id, sports_master_id: @ground_sports_master.sports_master_id } }
    assert_redirected_to ground_sports_master_url(@ground_sports_master)
  end

  test "should destroy ground_sports_master" do
    assert_difference('GroundSportsMaster.count', -1) do
      delete ground_sports_master_url(@ground_sports_master)
    end

    assert_redirected_to ground_sports_masters_url
  end
end
