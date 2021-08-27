require "test_helper"

class GroundsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @ground = grounds(:one)
  end

  test "should get index" do
    get grounds_url
    assert_response :success
  end

  test "should get new" do
    get new_ground_url
    assert_response :success
  end

  test "should create ground" do
    assert_difference('Ground.count') do
      post grounds_url, params: { ground: { business_email: @ground.business_email, business_phone: @ground.business_phone, closing_time: @ground.closing_time, cost_per_hour: @ground.cost_per_hour, ground_name: @ground.ground_name, ground_pincode: @ground.ground_pincode, opening_time: @ground.opening_time } }
    end

    assert_redirected_to ground_url(Ground.last)
  end

  test "should show ground" do
    get ground_url(@ground)
    assert_response :success
  end

  test "should get edit" do
    get edit_ground_url(@ground)
    assert_response :success
  end

  test "should update ground" do
    patch ground_url(@ground), params: { ground: { business_email: @ground.business_email, business_phone: @ground.business_phone, closing_time: @ground.closing_time, cost_per_hour: @ground.cost_per_hour, ground_name: @ground.ground_name, ground_pincode: @ground.ground_pincode, opening_time: @ground.opening_time } }
    assert_redirected_to ground_url(@ground)
  end

  test "should destroy ground" do
    assert_difference('Ground.count', -1) do
      delete ground_url(@ground)
    end

    assert_redirected_to grounds_url
  end
end
