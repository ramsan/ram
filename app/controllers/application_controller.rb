class ApplicationController < ActionController::Base
  protect_from_forgery
  layout :layout
  
  helper_method :splash_user, :can_use_demographics?, :demographic_vars, :hide_welcome_message, :splash_user, :my_memory_bank
  
  before_filter :set_common#, :my_memory_bank
  
  # def after_sign_in_path_for(resource_or_scope)
  #     #logger.info '*********** after_sign_in_path_for()'
  #     redirect_path = '/'
  #     #logger.info '*********** redirect_path: ' + redirect_path
  #     if resource_or_scope.is_a?(User)
  #       redirect_path = users_home_path
  #       #logger.info '*********** resource is a User'
  #       if session.has_key?(:pre_sign_in_path)
  #         redirect_path = session[:pre_sign_in_path] if !session[:pre_sign_in_path].eql?('/') 
  #         #logger.info '*********** session[:pre_sign_in_path]: ' + session[:pre_sign_in_path]
  #         session[:pre_sign_in_path] = nil
  #       end
  #     end
  #     #logger.info '*********** redirect_path: ' + redirect_path
  #     return redirect_path
  #   end
  
  def set_common
    @body_id = controller_name + '_' + action_name
    #@memories = Memory.has_images.order("created_at DESC").page(params[:page]).per(CONFIG[:custom_per_page])
    #@random = Memory.random
    
    #Temporary load of images for slider
    
    
    #  Switching off since its not being used at now (The Slider)
    
    # if params[:controller] == "home" && params[:action] == "index"
    #       #  Switching off since its not being used at now
    #       #  @slider = true
    #       #  sliderTop = 48
    #       #  @slider_memories = nil#Memory.find(:all, :joins => :categories, :group => :category_id, :order => "categories.name ASC, memories.created_at DESC")      
    #       
    #       #Memory.joins(:categories).group(:category_id).order("memories.created_at DESC, categories.name ASC")
    #       
    #       
    #       #Memory.joins(:categories).find(:all, :order => "categories.name ASC", :group => :category_id)
    #       
    #       #Memory.scoped.order("created_at DESC").limit(sliderTop)
    #       
    #       
    #       
    #       ##PREVIOUS SLIDER OPTIONS FOR BIRTH YEAR INPUT
    #       # if session[:birthyear]
    #       #         birth_year = session[:birthyear]
    #       #         @slider_memories = Memory.suggested_memories_for_guess(birth_year).order("created_at DESC").limit(sliderTop)
    #       #       else
    #       #         @slider_memories = Memory.scoped.order("created_at DESC").limit(sliderTop)
    #       #       end
    #     end
  end

  def my_memory_bank
    # if user_signed_in?
    #   @my_memory_bank = current_user.also_remembers(:order => "updated_at Desc") + current_user.memories(:order => "updated_at Desc")
    # end
  end
  
  def can_use_demographics?
    (current_user && !current_user.birth_year.nil?) || session[:demographics] || (params[:birth_year] && params[:gender])
  end
  
  def demographic_vars
    if current_user
      return [current_user.birth_year, current_user.gender, current_user.id]
    elsif (params[:birth_year] && params[:gender])
      session[:demographics] = {}
      session[:demographics][:birth_year] = params[:birth_year]
      # session[:demographics][:gender] = params[:gender]
    end
    return [session[:demographics][:birth_year], session[:demographics][:gender], nil]
  end
  
  #https://github.com/rails/rails/issues/671#issuecomment-1780159
  ## RESCUE ONLY ON PRODUCTION
  if Rails.env.production?
    unless Rails.application.config.consider_all_requests_local
      rescue_from ActiveRecord::RecordNotFound, :with => :render_not_found
      rescue_from ActionController::RoutingError, :with => :render_not_found
      rescue_from ActionController::UnknownController, :with => :render_not_found
      # customize these as much as you want, ie, different for every error or all the same
      rescue_from ActionController::UnknownAction, :with => :render_not_found
      rescue_from AbstractController::ActionNotFound, :with => :render_not_found
      rescue_from Exception, :with => :render_error
    end
  end
  
  #Alert user of unauthorized access 
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end
  
  def render_not_found(exception)
    msg = "ApplicationController#render_not_found: #{exception.inspect}"
    logit(msg)
    @title = 'Unknown request (404)';
    @msg = 'I\'m sorry, but the page you requested could not be found.';
    render "home/error", :status => 404
  end
  
  def render_error(exception)
    # you can insert logic in here too to log errors
    # or get more error info and use different templates
    msg = "ApplicationController#render_error: #{exception.inspect}"
    logit(msg)
    @title = 'Error (500)';
    @msg = 'I\'m sorry, an unknown error occured.';
    render "home/error", :status =>  500
  end
  

  def splash_user
    unless user_signed_in? == true
      if params[:splashed] == "true"
        cookies.delete :key
        cookies[:key] = {:value => 'invite', :expires => 30.days.from_now }
      end
      unless cookies[:key] == "invite"
        cookies[:key] = {:value => 'splashed', :expires => 30.days.from_now }
        redirect_to :controller => "home", :action => "splash" 
      end
    end
  end
  
  private
  
  #Overwritting devise used of application layout
  def layout
    # only turn it off for login pages:
    # is_a?(Devise::SessionsController) ? "sign_in_up" : "application"
    # or turn layout off for every devise controller:
    #devise_controller? && "application"
    @categories ||= Category.ordered.with_memories 

    if devise_controller? && params[:controller] == "sessions" ||  params[:controller] == "registrations" && params[:action] == "new" || 
      params[:controller] == "registrations" && params[:action] == "create" || params[:controller] == "passwords" && params[:action] == "new" ||
      params[:controller] == "confirmations" && params[:action] == "show" 
      "sign_in_up"
    else
      "application"
    end
      
    
  end
  
  def logit(msg)
    if Rails.env.eql?('production')
      logger.error msg 
    else
      puts msg
    end
  end

  #Redirecting users to previous url prior to login
  def after_sign_in_path_for(resource_or_scope)
    if resource_or_scope.is_a?(User) && resource_or_scope.banned?
      sign_out resource_or_scope
      banned_index_path
    elsif session[:pre_sign_in_path] && session[:pre_sign_in_path] != birthyear_path || session[:pre_sign_in_path] != new_user_session_path
       session[:user_return_to] || (session[:pre_sign_in_path] if session[:pre_sign_in_path] != birthyear_path ) || root_path
    elsif request.env['omniauth.origin'] && request.env['omniauth.origin'] != new_user_session_path || request.env['omniauth.origin'] != birthyear_path
      session[:user_return_to] || (session[:pre_sign_in_path] if session[:pre_sign_in_path] != birthyear_path ) || request.env['omniauth.origin'] || root_path
    else
      root_path
    end
  end
    
end
