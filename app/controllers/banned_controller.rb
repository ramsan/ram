class BannedController < ApplicationController
  def index
    render :layout => false
  end
end
