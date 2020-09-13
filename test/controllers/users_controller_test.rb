require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:michael)
    @other_user = users(:archer)
  end

  test "should get index" do
    log_in_as(@user)
    get users_url
    assert_response :success
  end

  test "should redirect index when not logged in" do
    get users_url
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should get new" do
    get signup_path
    assert_response :success
  end

  test "should disallow admin role setting" do
    post users_url, params: { user: { email: "unique@mail.com", name: @user.name, password: "foobar", password_confirmation: "foobar", admin: true } }
    assert_not User.last.admin?

    assert_redirected_to user_url(User.last)
  end

  test "should show user" do
    get user_url(@user)
    assert_response :success
  end

  test "should get edit" do
    log_in_as(@user)
    get edit_user_url(@user)
    assert_response :success
  end

  test "should redirect edit when not logged in" do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect update when not logged in" do
    patch user_path(@user), params: { user: { name: @user.name,
                                             email: @user.email } }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect edit when logged in as wrong user" do
    log_in_as(@other_user)
    get edit_user_path(@user)
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect update when logged in as wrong user" do
    log_in_as(@other_user)
    patch user_path(@user), params: { user: { name: @user.name,
                                             email: @user.email } }
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should not destroy user as non admin" do
    log_in_as(@other_user)
    assert_no_difference("User.count") do
      delete user_url(@user)
    end
    assert_redirected_to root_url
  end

  test "should redirect destory when not logged in" do
    assert_no_difference("User.count") do
      delete user_url(@user)
    end
    assert_redirected_to login_url
  end

  test "should destroy user as admin" do
    log_in_as(@user)
    assert_difference("User.count", -1) do
      delete user_url(@other_user)
    end
  end
end
