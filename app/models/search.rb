class Search
  attr_accessor :params, :results, :term_filtered
  
  STOP_WORDS = %w(a an the and or some of for in I)
  COLUMNS = %w(memories.name) # memories.description images.caption
  
  def initialize(params = {}, page = 1)
    @params = params
    @keyword_array = @params[:term].gsub(/[^\w\s]/,'').split(' ').reject{|word| STOP_WORDS.include?(word)}
    @term_filtered = @keyword_array.join(' ')
    @unordered = build_query(page)
    @results = @unordered
  end
  
  def reorder(params ={})
    @results = @unordered.order('memories.' + params[:sort] + ' ' + params[:direction])
  end
  
  private
  def build_query(page)
    #init = 'Memory.includes(:images)'
    init = 'Memory'
    arel = init
    
    if @params.has_key?(:term) && !@params[:term].blank?
      column_clauses = []
      COLUMNS.each do |col|
        column_clauses << @keyword_array.collect{|str| col + ' like "%' + str + '%"'}.join(' OR ')
      end
      arel += '.where(\''+ column_clauses.join(' OR ') + '\')'
    end
        
    arel += '.where("categories_memories.category_id in (?)", @params[:category_ids]).includes(:categories)' if @params.has_key?(:category_ids) && @params[:category_ids].size > 0 && !@params[:category_ids].first.blank?
    arel += '.where(:decade => @params[:decade_id])' if @params.has_key?(:decade_id) && !@params[:decade_id].blank?
    eval(arel).page(page).per(CONFIG[:memories_per_page])
  end

end