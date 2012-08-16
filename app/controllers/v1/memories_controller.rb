class V1::MemoriesController < ApplicationController
  
  before_filter :set_offset_and_limit
  
  def index
    @memories = Memory.offset(@offset).limit(@limit)
    render :json => {:memories => format_collection}
  end
  
  def per_decade
    @memories = Memory.includes(:categories).where(:decade => params[:id]).offset(@offset).limit(@limit)
    render :json => {:memories => format_collection}
  end
  
  def per_category
    @memories = Memory.includes(:categories).where('categories_memories.category_id = ?', params[:id]).offset(@offset).limit(@limit)
    render :json => {:memories => format_collection}
  end
  
  def suggested
    if !params.has_key?(:gender)
      gender = nil
    else
      gender = params[:gender].blank? || !%w(m f).include?(params[:gender]) ? nil : (params[:gender].eql?('m') ? 'male' : 'female')
    end
    @memories = Memory.similar_demographics(params[:year], gender, nil).offset(@offset).limit(@limit)
    render :json => {:memories => format_collection}
  end
  
  private
  
  def set_offset_and_limit
    @offset = params[:start].blank? ? 0 : params[:start].to_i - 1
    @limit = params[:amount].blank? ? 30 : params[:amount].to_i    
  end
  
  def format_collection
    arr = []
    @memories.each do |m|
      hsh = {}
      hsh[:decade] = m.decade_name
      hsh[:name] = m.name
      hsh[:updated_at] = m.updated_at.to_date
      hsh[:is_anonymous] = m.is_anonymous
      hsh[:description] = m.description
      hsh[:date_of_memory] = m.date_of_memory
      hsh[:views] = m.views
      hsh[:id] = m.id
      hsh[:created_at] = m.created_at
      hsh[:user_id] = m.is_anonymous ? nil : m.user.id
      hsh[:user_name] = m.is_anonymous ? nil : m.user.name
      hsh[:image] = m.main_image.this_url
      hsh[:comments_count] = m.comments.count
      hsh[:follows_count] = m.is_anonymous ? nil : m.user.followers.count
      hsh[:likes_count] = m.remembered_by.count
      hsh[:category_id] = m.category.id
      hsh[:category_name] = m.category.name
      arr << hsh
    end
    arr
  end
  
end