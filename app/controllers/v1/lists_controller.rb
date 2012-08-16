class V1::ListsController < ApplicationController
  
  def categories
    cats = Category.all.sort.collect{|c| {c.id => c.name}}
    render :json => {:categories => cats}
  end
  
  def decades
    decades = Memory::DECADES.keys.sort.collect{|k| {k => Memory::DECADES[k]}}
    render :json => {:decades => decades}
  end
  
end