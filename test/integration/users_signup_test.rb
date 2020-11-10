require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear
  end


  test "invalid signup information" do
    get signup_path
      assert_no_difference 'User.count' do 
        post users_path, params: { user: { name: "", email: "user@invalid", password: "foo", password_confirmation: "bar" } }
    end
  end

    test "signup with valid into with account activation" do
      get signup_path
      assert_difference 'User.count', 1 do
        post users_path, params: { user: { name:  "Example User", email: "user@example.com", password: "password", password_confirmation: "password" } }
      end
      assert_equal 1, ActionMailer::Base.deliveries.size
      user = assigns(:user)
      assert_not user.activated?
      #attempt to log in before authentication
      log_in_as(user)
      assert_not is_logged_in?
      #attempt auth with invalid token
      get edit_account_activation_path("Invalid token", email: user.email)
      assert_not is_logged_in?
      #valid token but wrong email
      get edit_account_activation_path(user.activation_token, email: "Wrong email")
      assert_not is_logged_in?
      #valid auth
      get edit_account_activation_path(user.activation_token, email: user.email)
      assert user.reload.activated?
      follow_redirect!
      assert_template 'users/show'
      assert is_logged_in?
  end
end
