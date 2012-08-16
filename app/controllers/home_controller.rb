class HomeController < ApplicationController  
  before_filter :splash_user, :only => :index
  

  # def decade_index
  #   # @memories = Memory.has_images.order("created_at DESC")#.page(params[:page]).per(100)
  #   @memories ||= Memory.scoped.has_images.order("created_at DESC").page(params[:page]).per(100)
  #   @categories = Category.all
  #   if params[:decade]
  #     decade = @memories.where(:decade => params[:decade])
  #     @decade = decade.page(params[:page]).per(100)
  #   else
  #     @decade = @memories.page(params[:page]).per(100)
  #   end
  #   # @memories = Memory.scoped.has_images.order("created_at DESC").page(params[:page]).per(100)
   
  #   respond_to do |format|
  #       format.html # index.html.erb
  #       format.js  { render :layout => false }
  #   end

  # end


  def index
    # original, unfiltered query: 
    # @memories = Memory.has_images.order("created_at DESC").page(params[:page]).per(CONFIG[:custom_per_page])
    @all_memories ||= Memory.has_images.order("created_at DESC").limit(200)
    
    #Switching off since its not being used at now
    #@feeds = Memory.scoped(:order => "RAND()").has_images.page(params[:feed]).per(5)

    #too bad i couldn't chain this all into one mega-query...
    ## this instances were working
    #     @memories = Memory.has_images.order("created_at DESC")
    #     @memories = @memories.in_decade(params[:decade]) if (params[:decade] && params[:decade].to_i > 0)
    #     @memories = @memories.in_category(params[:category]) if (params[:category])
    #     @memories = @memories.page(params[:page]).per(CONFIG[:custom_per_page])
    
    
    #I am making some testing for speed up this Sh#%
    if params[:decade] && params[:decade].to_i > 0 && params[:category]
      @memories = @all_memories.in_decade(params[:decade]).in_category(params[:category]).page(params[:page]).per(CONFIG[:custom_per_page])
    elsif params[:decade] && params[:decade].to_i > 0
      @memories = @all_memories.in_decade(params[:decade]).page(params[:page]).per(CONFIG[:custom_per_page])
    elsif params[:category]
      @memories = @all_memories.in_category(params[:category])#.page(params[:page]).per(CONFIG[:custom_per_page])

      # @memories = @all_memories.in_category(params[:category])#.page(params[:page]).per(CONFIG[:custom_per_page])
      if @memories.length < 120 
        memories = @memories + @all_memories.limit(100)
        @memories = Kaminari.paginate_array(memories).page(params[:page]).per(200)
      else
        @memories.page(params[:page]).per(CONFIG[:custom_per_page])
      end
      
    elsif !params[:decade].present? && !params[:category].present?
        @memories =  @all_memories.page(params[:page]).per(140)
    end
    
    
    
    # THIS IS THE PREVIOUS QUERY
    # @feeds =  Kaminari.paginate_array(@memories.reverse[1..5]).page(params[:feed]).per(5)
    
    
    # unless params[:current_tab]
    #   @current_tab = "home"
    # end
    
    # BIRTHYEAR IT'S OFF TEMPORARY (BY_BIRTHYEAR ON MEMORY CONTROLLER)
    # if session[:showbirthyearmemories] == true
    #       if !session[:sawbirthyearmemories].present?
    #         session[:sawbirthyearmemories] = true
    #         session[:showbirthyearmemories] = false
    #         birth_year = session[:birthyear].to_i
    #         @showbirthyearmemories = true
    #         #@birth_year_memories = Memory.similar_demographics(birth_year).order("created_at DESC").limit(3)
    #         
    #       else
    #         session[:sawbirthyearmemories] = true
    #       end
    #     end



    #Switching off since its not being used at now 
    # if user_signed_in?
    #   user_voted = current_user.votes.map(&:showdown_id)
    #   showdowns = !user_voted.empty? ? Showdown.next_vote(user_voted) : Showdown.scoped
    #   @showdowns = Kaminari.paginate_array(showdowns).page(params[:showdown]).per(1)
    # else
    #   showdowns = Showdown.scoped
    #   @showdowns = showdowns.page(params[:showdown]).per(1)
    # end
    
    
    # @memories_latest = Memory.latest.limit(CONFIG[:memories_per_page])
    # @memories_most_popular = Memory.most_popular.limit(CONFIG[:memories_per_page])    
    
    # if params[:sort] == "memories.views"
    #      @memories = @memories_most_popular
    #    else
    #      @memories = @memories_latest
    #    end
    
    
    respond_to do |format|
        format.html # index.html.erb
        format.js  { render :layout => false }
    end
  end
  
  def trending
    @memories = Memory.most_popular.order("created_at DESC").includes(:categories, :images).page(params[:page]).per(CONFIG[:memories_per_page])
    
    respond_to do |format|
        format.html { render :template => "home/index"}
        format.js  { render :layout => false, :template => "home/index" }
    end
  end
  
  def splash
    if params[:code]
      user_typed = params[:code].downcase
    end
    passwords = ["barbie", "lennon", "ewing", "popsicle", "lassie", "Saunders", "saunders", "vinyl"]
    if passwords.all?{ |p| passwords.include?(user_typed)} != true
      @visit = params[:visit] ||= Visit.new
      render :layout => false
    elsif passwords.all?{ |p| passwords.include?(user_typed)} == true
      cookies.delete :key
      cookies[:key] = {:value => 'invite', :expires => 30.days.from_now }
      #redirect_to :action => "entrance"
      redirect_to :action => "index"
    else
      @visit = params[:visit] ||= Visit.new
      render :layout => false
    end
  end
  
  # ONLY FOR TEST EMAILS NOTIFICATIONS TEMPLATE
  # def email_test
  #     @user = User.find(5).name
  #     @user_id = 5
  #     @other_user = User.find(156).name
  #     memory = Memory.last
  #     @image = memory.main_image
  #     @image_title = memory.name
  #     @link_text = "This is a nice link to something fun!"
  #     @link_url = "http://www.doyouremember.com"
  #     
  #     render :layout => "email"
  #   end
  
  def entrance
    #Getting the birthyear of non registered visitors
    if params[:ten] && params[:unid]
      birthyear = "19" + params[:ten] + params[:unid]
      session[:birthyear] = birthyear
      session[:showbirthyearmemories] = true
      redirect_to by_birthyear_url
    elsif params[:birthYear] == "skipped" #Skipping the birthyear of non registered visitors
      birthyear = "2012"
      session[:birthyear] = nil
      redirect_to :action => "index"
    else
      @categories = Category.with_memories
    
      unless params[:category]
        @selected_category = nil
        @memories = Memory.scoped.limit(18).order("created_at DESC")
      else
        @selected_category = Category.find(params[:category])
        @memories = Memory.in_category(params[:category]).limit(18).order("created_at DESC")
      end
    
      respond_to do |format|
        format.html{render :layout => false}
        format.js {render :layout => false}
      end
    end
  end

  #Browsing Memories by List
  def list_view
    @updown = params[:updown].nil? ? "DESC" : params[:updown]
    @v = @updown
    options_for_order = %w[name tag user_id follow comments_count created_at]
    if options_for_order.include?(params[:order])
      @memories = Memory.scoped.list_view(params[:order], @updown).page(params[:page]).per(CONFIG[:memories_per_page])
    else
      @memories = Memory.scoped.order("name ASC").page(params[:page]).per(CONFIG[:memories_per_page])
    end
  end
  
  #temporary location for put birthday info or login
  def birthyear
    render :layout => false
  end
  
  def vip
    cookies[:key] = {:value => 'invite', :expires => 30.days.from_now }
    params[:code] = "barbie"
    redirect_to splash_path(:code => "barbie")  
  end
  
  
  def routing_error
    @title = 'Unknown request (404)';
    @msg = 'I\'m sorry, but the page you requested could not be found.';
    render :error
  end
end