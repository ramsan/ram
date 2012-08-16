class CustomAuthenticationFailure < Devise::FailureApp
  protected
  def redirect_url
    # login_register_path
    new_user_session_path
  end
end 