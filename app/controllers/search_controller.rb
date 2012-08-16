class SearchController < ApplicationController
  
  helper_method :sort_column, :sort_direction
  
  def result
    if request.method.eql?('POST')
      session[:search] = nil
      session[:search] = params[:search]
      @search = Search.new(session[:search])
      @search.reorder(:sort => 'name', :direction => 'asc')
      if params[:create]
        #redirect_to new_memory_path(:name => params[:search][:term]) and return if @search.results.count.eql?(0)
        render :create        
      end
    else
      redirect_to search_path if session[:search].nil?
      @search = Search.new(session[:search], params[:page])
      if params[:direction] && params[:sort]
        @search.reorder(params)
      end
    end
    # if @search.results.size.eql?(0)
      # redirect_to new_memory_path(:name => URI.escape(@search.params[:term])) and return
    # end
    @term = session[:search][:term]
  end
  
  private  
  def sort_column
    Memory.column_names.include?(params[:sort]) ? params[:sort] : "name"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end  
end