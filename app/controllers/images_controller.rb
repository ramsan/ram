class ImagesController < ApplicationController
  before_filter :authenticate_user!
  
  def create
    memory_id = params[:images].first[:memory_id]
    remove_empty_images unless params[:as_comment]
    img_count = params[:images].count
    img_upload = 0
    params[:images].each do |img|
      begin
        Image.create(img)
        img_upload += 1
      end    
    end
    if img_count.eql?(img_upload)
      flash[:notice] = I18n.t('success', :obj => 'Comment', :action => 'created')
    else
      flash[:alert] = I18n.t('fail', :obj => 'Comment', :action => 'creating')
    end
    
    redirect_to memory_path(memory_id, :created_now => true)
  end
  
  # PUT /posts/1
  # PUT /posts/1.json
  def update
    @image = Image.find(params[:id])
    @image.update_attributes(params[:images])
    @memory = Memory.find(params[:images][:memory_id], :include => [:images, :categories])
    if(params[:user_comment])
      @direction = current_user.comments;
    end
    render :layout => false
  end
  # GET /images/1/edit
  def edit
    @images = Image.find(params[:id])
    render :layout => false
  end

  def destroy
    @result = {}
    img = Image.find(params[:id])    
    if img.user.eql?(current_user) && img.destroy
      @result[:id] = params[:id]
      @memory = Memory.find(params[:memory_id], :include => [:images, :categories])
    end
    render :layout => false
  end
  
  def distroying_from_userpage
    img = Image.find(params[:id])
    if img.user.eql?(current_user) && img.destroy
      @comments = User.current_user.comments
    end
    render :layout => false
  end
  
  private
  def remove_empty_images
    params[:images].reject! {|img| img['image'].blank? && img['google_thumb'].blank? }    
  end
end
