class FeedsController < ApplicationController
  def index
  end

  def next
    feeds = Memory.suspended.has_images.order('rand(), images_count DESC')
    # feeds = Memory.has_images.order("images_count DESC, updated_at DESC,  created_at DESC").scoped
    @feeds = feeds.page(params[:feed]).per(1)
    
    respond_to do |format|
      # format.html # index.html.erb
      format.json { render :json => @feeds }
      format.js  { render :layout => false }
    end
  end

end
