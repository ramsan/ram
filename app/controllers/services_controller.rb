class ServicesController < ApplicationController
  before_filter :authenticate_user!, :except => [:new, :create]
  def index
    # get all authentication services assigned to the current user
    @services = current_user.services.all
  end
  
  def destroy
    # remove an authentication service linked to the current user
    @service = current_user.services.find(params[:id])
    @service.destroy

    redirect_to users_home_path(:anchor => 'settings')
  end

  def create
    #render :text => '<pre>' + request.env["omniauth.auth"].to_yaml + '</pre>' and return #For testing
    
    # get the service parameter from the Rails router
    params[:service] ? service_route = params[:service] : service_route = 'no service (invalid callback)'

    # get the full hash from omniauth
    omniauth = request.env['omniauth.auth']

    # continue only if hash and parameter exist
    if omniauth and params[:service]
      logger.debug "**** omniauth:"
      logger.debug omniauth.to_yaml
      
      if %w(facebook twitter google).include?(service_route)

        email =  omniauth['info']['email'] ? omniauth['info']['email'] : ''
        if !omniauth['extra']['raw_info']['name'].blank?
          name = omniauth['extra']['raw_info']['name']
        elsif !omniauth['info']['first_name'].blank? && !omniauth['info']['last_name'].blank?
          first_name = omniauth['info']['first_name']
          last_name = omniauth['info']['last_name']
          name = first_name + ' ' + last_name
        else
          name = omniauth['info']['name'] ? omniauth['info']['name'] : ''
        end        
        if !omniauth['extra']['raw_info']['birthday'].blank?
          birth = omniauth['extra']['raw_info']['birthday'] ? omniauth['extra']['raw_info']['birthday'].to_date.year : '1900'
        end
        uid = omniauth['uid'] ? omniauth['uid'] : ''
        provider = service_route
      else
        # we have an unrecognized service, just output the hash that has been returned
        # render :text => omniauth.to_yaml
        #render :text => uid.to_s + " - " + name + " - " + email + " - " + provider
        return
      end

      # continue only if provider and uid exist
      if uid != '' and provider != ''

        # nobody can sign in twice, nobody can sign up while being signed in (this saves a lot of trouble)
        if !user_signed_in?

          # check if user has already signed in using this service provider and continue with sign in process if yes
          auth = Service.find_by_provider_and_uid(provider, uid)
          if auth
            set_facebook_auth_token(auth.user, omniauth) if service_route == 'facebook'
            flash[:notice] = 'Signed in successfully via ' + provider.capitalize + '.'
            sign_in_and_redirect(:user, auth.user)
          else
          # check if this user is already registered with this email address; get out if no email has been provided
            if email != '' || email == '' && service_route.eql?('twitter')
              # search for a user with this email address
              existinguser = User.find_by_email(email)
              if existinguser
                # map this new login method via a service provider to an existing account if the email address is the same
                existinguser.services.create(:provider => provider, :uid => uid, :uname => name, :uemail => email)
                flash[:notice] = 'Sign in via ' + provider.capitalize + ' has been added to your account ' + existinguser.email + '. Signed in successfully!'
                set_facebook_auth_token(existinguser, omniauth) if service_route == 'facebook'
                sign_in_and_redirect(:user, existinguser)
              elsif service_route.eql?('facebook')
              # let's create a new user: register this user and add this authentication method for this user
                name = name[0, 39] if name.length > 39             # otherwise our user validation will hit us

                # new user, set email, a random password and take the name from the authentication service
                user = User.new :email => email, :password => SecureRandom.hex(10), :full_name => name, :birth_year => birth, :haslocalpw => false

                # add this authentication service to our new user
                user.services.build(:provider => provider, :uid => uid, :uname => name, :uemail => email)

                # do not send confirmation email, we directly save and confirm the new record
                #user.skip_confirmation!
                #user.confirm!
                user.save!
                set_facebook_auth_token(user, omniauth) if service_route == 'facebook'
                user.update_profile_from_facebook if service_route == 'facebook'
                # flash and sign in
                flash[:myinfo] = 'Your account on ' + CONFIG[:app_name] + ' has been created via ' + provider.capitalize + '. In your profile you can change your personal information and add a local password.'
                sign_in_and_redirect(:user, user)
              
              elsif service_route.eql?('twitter')
                
                  #name = name[0, 39] if name.length > 39
                  user = User.new :email => email, :password => SecureRandom.hex(10), :full_name => name, :haslocalpw => false
                  #service_route == 'twitter'
                  session[:omniauth] = omniauth
                  session[:omniauth][:password] = SecureRandom.hex(10)
                  redirect_to new_user_registration_path
              end
            else
              flash[:alert] =  service_route.capitalize + ' can not be used to sign-up on ' + CONFIG[:app_name] + ' as no valid email address has been provided. Please use another authentication provider or use local sign-up. If you already have an account, please sign-in and add ' + service_route.capitalize + ' from your profile.'
              redirect_to new_user_session_path
              #twitter registration fallback
              #session[:omniauth] = omniauth.except('extra')
              #redirect_to new_user_registration_url
            end
          end
        else
        # the user is currently signed in
          set_facebook_auth_token(current_user, omniauth) if service_route == 'facebook' 
        
        # check if this service is already linked to his/her account, if not, add it
          auth = Service.find_by_provider_and_uid(provider, uid)
          if !auth
            current_user.services.create(:provider => provider, :uid => uid, :uname => name, :uemail => email)
            flash[:notice] = 'Sign in via ' + provider.capitalize + ' has been added to your account.'
            redirect_to users_home_path(:anchor => 'settings')
          else
            flash[:notice] = service_route.capitalize + ' is already linked to your account.'
            redirect_to users_home_path(:anchor => 'settings')
          end
        end
      else
        flash[:alert] =  service_route.capitalize + ' returned invalid data for the user id.'
        redirect_to new_user_session_path
      end
    else
      flash[:alert] = 'Error while authenticating via ' + service_route.capitalize + '.'
      redirect_to new_user_session_path
    end
  end
  
  private
  def set_facebook_auth_token(user, omniauth)
    user.update_attribute(:fb_auth_token, omniauth['credentials']['token']) if !user.fb_auth_token.eql?(omniauth['credentials']['token']) && !omniauth['credentials']['token'].blank?
  end
end
