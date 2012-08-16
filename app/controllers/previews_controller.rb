class PreviewsController < ApplicationController
  before_filter :find_memory
  before_filter :authenticate_user!, :only => [:post_comment, :also_remembers, :follow, :unfollow, :delete] 
  
  def comments
    render :layout => false
  end
  
  def post_comment
    begin
      img = @memory.images.create(params[:memory].merge(:user => current_user))
      if img.errors.count > 0
        Rails.logger.error "[ERROR] #{File.basename(__FILE__)}[#{__LINE__}]: #{img.errors.inspect}"
      end
    rescue Exception => e
      Rails.logger.error "[ERROR] #{File.basename(__FILE__)}[#{__LINE__}]: #{e.inspect}"
    end
    render :layout => false
  end
  
  def related
    memories = Search.new(:term => @memory.name).results.where('id != ?', @memory)
    @total_related = memories.count
    @memories = memories.limit(6)
    
    #CACHE THE RELATED MEMORIES AMOUNT BASED ON LAST RELATED SEARCH
    if @memory.related_memories_count != @total_related
      @memory.related_memories_count = @total_related
      @memory.save!
    end
    render :layout => false
  end
  
  def remembered
    render :layout => false
  end
  
  def photos
    render :layout => false
  end
  
  def also_remembers
    current_user.also_remembers << @memory unless current_user.also_remembers.include?(@memory)
    render :layout => false
  end
  
  def forgot
    current_user.also_remembers.delete(@memory) unless !current_user.also_remembers.include?(@memory)
    render :layout => false
  end
  
  def follow
    @followee = User.find(params[:id])
    if params[:list] == "true"
      @list = true
    end
    
    current_user.followees << @followee
    current_user.save    
    render :layout => false
  end
  
  def unfollow
    if params[:list] == "true"
      @list = true
    end
    
    @followee = User.find(params[:id])
    current_user.followees.delete(@followee)
    current_user.save    
    render :layout => false
  end
  
  def delete
    @memory.destroy if @memory.user.eql?(current_user)
    render :layout => false
  end
  
  private
  
  def find_memory
    @memory = Memory.find(params[:id])
  end
end