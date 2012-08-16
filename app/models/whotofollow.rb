class Whotofollow
  attr_accessor :params, :results, :term_filtered

  STOP_WORDS = %w(a an the and or some of for in I)
  COLUMNS = %w(users.first_name) # users.description images.caption

  def initialize(params = {}, page = 1)
    @params = params
    @keyword_array = @params[:term].gsub(/[^\w\s]/,'').split(' ').reject{|word| STOP_WORDS.include?(word)}
    @term_filtered = @keyword_array.join(' ')
    @unordered = build_query(page)
    @results = @unordered
  end

  def reorder(params ={})
    @results = @unordered.order('users.' + params[:sort] + ' ' + params[:direction])
  end

  private
  def build_query(page)
    #init = 'User.includes(:images)'
    init = 'User'
    arel = init

   arel += find(:all, :conditions => ["first_name LIKE ?", "%#{session[:search]}%"], :order => "first_name ASC")
    eval(arel).page(page)
  end

end
