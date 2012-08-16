class MemoriesController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :show, :send_to_a_friend, :per_category, :per_similar_demographics, :per_decade, :by_birthyear]
  # TEMPORARY METHOD (INVITED_USER) FOR THE SPLASH SCREEN TO IGNORE INVITED USERS
  before_filter :invited_user, :only => [:index, :show]
  helper_method :sort_column, :sort_direction
  load_and_authorize_resource :only => [:suspend, :unsuspend, :ban_user, :unban_user]
  
  
  def index
    @memories = Memory.order(sort_column + " " + sort_direction).includes(:categories, :images).page(params[:page]).per(CONFIG[:memories_per_page])
    @random = Memory.random
    respond_to do |format|
        format.html { render :template => "home/index"}
        format.js  { render :layout => false, :template => "home/index" }
    end
  end

  def show
    if params[:created_now] == "true"
      @created_now = true
    end
    @memory = Memory.find(params[:id], :include => [:images, :categories])
    @memory.views += 1
    @memory.save
    @term = @memory.name
    @recents = Memory.find(:all, :conditions => ["id != ? and user_id = ?", @memory.id, @memory.user_id], :limit => 3, :order => "created_at DESC")
    # @comments = @memory.comments.page(params[:comment_page])
    
    #activate message after comment is created
  end
  
  def lightbox
    if params[:created_now] == "true"
      @created_now = true
    end
    @memory = Memory.find(params[:id], :include => [:images, :categories])
    @memory.views += 1
    @memory.save
    @term = @memory.name
    @recents = Memory.find(:all, :conditions => ["id != ? and user_id = ?", @memory.id, @memory.user_id], :limit => 3, :order => "created_at DESC")
    # @comments = @memory.comments.page(params[:comment_page])
    
    #activate message after comment is created
    respond_to do |format|
      format.html { render :layout => false }
    end
    
  end

  def new
    @memory = Memory.new(:share_on_facebook => current_user.prefers?(User::SYSTEM_AUTO_FB_MEMORY_POST))
    @memory.user = current_user
    @memory.you_tube_videos.new
    if !params[:name].blank?
      @memory.name = URI.unescape(params[:name]) 
      @term = @memory.name      
    end
  end

  def create
    remove_images_without_files
    remove_videos_without_urls
    @memory = Memory.new(params[:memory])
    @memory.user = current_user
    if @memory.save
      flash[:notice] = I18n.t('success', :obj => 'Memory', :action => 'created')
      expire_fragment('nav_categories') if @memory.categories.count > 0
      expire_fragment('home_latest')
      expire_fragment('footer')
      if @memory.categories.count > 0
        flash[:notice] = I18n.t('controllers.memories.create.other_things')
      #   redirect_to memories_per_category_path(@memory.categories.first) and return
      # else
        redirect_to '/?show_latest=true' and return
      end
      render :new
    end
  end

  # GET /images/1/edit
  def edit_comment
    @images = Image.find(params[:id])
    render :layout => false
  end
  def edit
    find_and_validate_memory
    @memory.you_tube_videos.new if @memory.you_tube_videos.empty?

  end

  def update
    find_and_validate_memory
    remove_images_without_files
    remove_videos_without_urls
  
    if @memory.update_attributes(params[:memory])
      expire_fragment('nav_categories') if @memory.categories.count > 0
      flash[:notice] = I18n.t('success', :obj => 'Memory', :action => 'updated')
      redirect_to memory_path(@memory)
    else
      render :action => "edit"
    end

  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @memory = Memory.find(params[:id])
    @memory.destroy

    respond_to do |format|
      format.html { redirect_to memory_path(@memory) }
      format.json { head :ok }
      format.js
    end
  end

  def send_to_a_friend
    @memory = Memory.find(params[:id])
    if current_user
      params[:sender_name] = current_user.name
    end
    if Email.send_to_a_friend(@memory, params).deliver
      flash[:notice] = 'This memory was sent to '+params[:friend_name]+'!'
    else
      flash[:alert] = I18n.t('fail', :object => 'Memory', :action => 'sending to a friend')
    end
    redirect_to memory_path(params[:id])
  end

  def per_category
    @current_tab = "category"
    @categories = Category.all
    unless params[:sort]
      params[:sort] = "memories.created_at"
    end
    #@random = Memory.random
    if params[:category_id].eql?('all')
      @memories = Memory.all.page(params[:page]).per(CONFIG[:memories_per_page])
    else
      @memories = Memory.order(sort_column + " " + sort_direction).includes(:categories).where('categories_memories.category_id = ?', params[:category_id]).page(params[:page]).per(CONFIG[:memories_per_page])
      @category = Category.find(params[:category_id])
    end
    respond_to do |format|
        format.html { render :template => "home/index"}
        format.js  { render :layout => false, :template => "home/index" }
    end
  end
  
  def per_decade
    @current_tab = "category"
    #@random = Memory.random
    @memories = Memory.order(sort_column + " " + sort_direction).where(:decade => params[:decade_id]).page(params[:page]).per(CONFIG[:memories_per_page])
    Struct.new("Decade", :name)
    @category = Struct::Decade.new(Memory::DECADES[params[:decade_id].to_i])
    respond_to do |format|
        format.html { render :template => "home/index"}
        format.js  { render :layout => false, :template => "home/index" }
    end
  end
  
  def per_similar_demographics
    @current_tab = "suggested"    
    redirect_to :action => :index and return unless can_use_demographics?
    # Using a @category is somewhat of a hack in order to reuse the heading display mechanism of index.haml
    @category = Category.new
    @category.name = ' you may like'
    if session[:birthyear].present? == true
      birth_year = session[:birthyear]
      gender = nil
      user_id = nil
    end  
    birth_year, gender, user_id = demographic_vars
    @memories = Memory.similar_demographics(birth_year, gender, user_id).page(params[:page]).per(CONFIG[:memories_per_page])
    respond_to do |format|
        format.html { render :template => "home/index"}
        format.js  { render :layout => false, :template => "home/index" }
    end
  end
  
  def by_birthyear
    
    if session[:birthyear]
        birth_year = session[:birthyear].to_i
        #@birth_year_memories = Memory.similar_demographics(birth_year).order("created_at DESC").limit(3)
        @memories = Memory.similar_demographics(birth_year).order("updated_at DESC").page(params[:page]).per(CONFIG[:memories_per_page])
      # else
        # session[:sawbirthyearmemories] = true
    end
    @special_title = "We have found some members' memories that you might remember based on your birth year: " + session[:birthyear] 
    @current_tab = "suggested"
    
    respond_to do |format|
      format.html { render :template => "home/index"}
      format.js  { render :layout => false, :template => "home/index" }
    end
    
  end
  
  def also_remembers
    @memory = Memory.find(params[:id])
    current_user.also_remembers << @memory unless @memory.user.eql?(current_user)
    render :layout => false
  end
  
  def forgot
    @memory = Memory.find(params[:id])
    current_user.also_remembers.delete(@memory) unless !current_user.also_remembers.include?(@memory)
    render :layout => false
  end

  def memory_bank
    # memories = 
    @memories = Kaminari.paginate_array(current_user.also_remembers(:order => "updated_at Desc") + current_user.memories(:order => "updated_at Desc")).page(params[:page]).per(CONFIG[:memories_per_page]) 
    #current_user.memories.joins(current_user.also_remembers).page(params[:page]).per(CONFIG[:memories_per_page]) 
    #Memory.where(:user_id => current_user).page(params[:page]).per(CONFIG[:memories_per_page]) 
    #current_user.memories(:includes =>:also_remembers).page(params[:page]).per(CONFIG[:memories_per_page]) 
    
    respond_to do |format|
      format.html { render :template => "home/index"}
      format.js  { render :layout => false, :template => "home/index" }
    end
  end
  
  def add_to_memory_bank
    @memory = Memory.find(params[:id])
    @user = current_user
    
    its_stored = @user.also_remembers.where(:id => params[:id])
    
    
    if @memory.user == @user
      @can = false
    elsif its_stored.empty? != true
      @can = false
      @its_remembered = true
    else
      @can = true
    end
    respond_to do |format|
      format.js  { render :layout => false }
    end
  end
  
  def suspend
    @memory = Memory.find(params[:id])
    @memory.update_attribute(:suspended, true)
    @admin = true
    
    respond_to do |format|
      format.js  { render :layout => false }
    end
  end
  
  def unsuspend
    @memory = Memory.find(params[:id])
    @memory.update_attribute(:suspended, false)
    @admin = true
    
    respond_to do |format|
      format.js  { render :layout => false }
    end
  end
  
  def destroy
    @memory = Memory.find(params[:id])
    @memory.destroy

    respond_to do |format|
      format.html { redirect_to root_url, :notice => 'Memory was successfully deleted.' }
      format.json { head :ok }
    end
  end
  
  def ban_user
    @memory = Memory.find(params[:id], :include => [:images, :categories])
    @banned_user = User.find(@memory.user_id)
    @banned_user.update_attribute(:banned, true)
    @memory.user.banned = true
    
    respond_to do |format|
      format.html { redirect_to root_url, :notice => 'User was successfully banned.' }
      format.js { render :layout => false }
    end
  end
  
  def unban_user
    @memory = Memory.find(params[:id], :include => [:images, :categories])
    @banned_user = User.find(@memory.user_id)
    @banned_user.update_attribute(:banned, false)
    @memory.user.banned = false
    
    respond_to do |format|
      format.html { redirect_to root_url, :notice => 'User was successfully unbanned.' }
      format.js { render :layout => false }
    end
  end
  
  private

  def sort_column
    #Memory.column_names.include?(params[:sort]) ? params[:sort] : "memories.views"
    params[:sort] ? params[:sort] : "memories.created_at"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end

  def find_and_validate_memory
    @memory = Memory.find(params[:id])
    if @memory.user != current_user
      flash[:alert] = I18n.t('action_not_allowed')
      redirect_to :action => 'index' and return
    end
  end

  def remove_images_without_files
    params[:memory][:images_attributes].reject! {|img| img['image'].blank? && img['google_thumb'].blank? && img['external_url'].blank?}
  end

  def remove_videos_without_urls
    if params[:memory][:you_tube_videos_attributes]
      params[:memory][:you_tube_videos_attributes].each_pair do |k,v|
        params[:memory][:you_tube_videos_attributes].delete(k)  if (v[:url] =~ URI::regexp).nil?
      end
    end
  end
  
  def invited_user
    if cookies[:key] != "invite"
      cookies.delete :key
      cookies[:key] = {:value => 'invite', :expires => 30.days.from_now }
    end
  end

end
