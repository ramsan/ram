class RegistrationsController < Devise::RegistrationsController
  include DeviseDowncase
  
  #TODO: DRY up
  def update
    params[:user].delete(:profile_image) if params[:user][:profile_image].blank?
    if params[:delete_image].eql?('1')
      resource.profile_image = nil if resource.profile_image.present?
    end
    if params[resource_name][:password].blank?
      params[resource_name].delete(:password)
      params[resource_name].delete(:password_confirmation)
    else
    # if the user wants to set a password we set haslocalpw for the future
      params[resource_name][:haslocalpw] = true
    end

    # this is copied over from the original devise controller, instead of update_with_password we use update_attributes
    # Override Devise to use update_attributes instead of update_with_password.
    downcase_authentication_params
    if resource.update_attributes(params[resource_name])
      set_flash_message :notice, :updated
      sign_in resource, :bypass => true
      redirect_to after_update_path_for(resource)
    else
      flash[:alert] = I18n.t('fail', :object => 'user profile', :action => 'updating')
      clean_up_passwords(resource)
      render_with_scope :edit
    end
  end

  def create    
    downcase_authentication_params    
    build_resource
    
    # unless verify_recaptcha :private_key => CONFIG[:recaptcha][:private]
      # try_again(resource) and return
    # end
    
    if resource.save
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_navigational_format?
        sign_in(resource_name, resource)
        #Process the birth year for show once
        birthyear = resource.birth_year
        session[:birthyear] = birthyear
        session[:showbirthyearmemories] = true
        respond_with resource, :location => after_sign_in_path_for(resource)
      else
        set_flash_message :notice, :inactive_signed_up, :reason => inactive_reason(resource) if is_navigational_format?
        expire_session_data_after_sign_in!
        respond_with resource, :location => after_inactive_sign_up_path_for(resource)
      end
    else
      try_again(resource)
    end
  end
  
  

  
  private
  def try_again(resource)
    clean_up_passwords(resource)
    respond_with_navigational(resource) { render_with_scope :new }
  end
  
end