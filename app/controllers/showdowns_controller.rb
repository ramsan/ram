class ShowdownsController < ApplicationController
  before_filter :authenticate_user!, :except => :next_vote
  load_and_authorize_resource
  
  # GET /showdowns
  # GET /showdowns.json
  def index
    @showdowns = Showdown.unscoped.order("created_at DESC").page(params[:page]).per(CONFIG[:memories_per_page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @showdowns }
    end
  end

  # GET /showdowns/1
  # GET /showdowns/1.json
  def show
    @showdown = Showdown.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @showdown }
    end
  end

  # GET /showdowns/new
  # GET /showdowns/new.json
  def new
    @showdown = Showdown.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @showdown }
    end
  end

  # GET /showdowns/1/edit
  def edit
    @showdown = Showdown.find(params[:id])
  end

  # POST /showdowns
  # POST /showdowns.json
  def create
    @showdown = Showdown.new(params[:showdown])

    respond_to do |format|
      if @showdown.save
        format.html { redirect_to @showdown, :notice => 'Showdown was successfully created.' }
        format.json { render :json => @showdown, :status => :created, :location => @showdown }
      else
        format.html { render :action => "new" }
        format.json { render :json => @showdown.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /showdowns/1
  # PUT /showdowns/1.json
  def update
    @showdown = Showdown.find(params[:id])

    respond_to do |format|
      if @showdown.update_attributes(params[:showdown])
        format.html { redirect_to @showdown, :notice => 'Showdown was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @showdown.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /showdowns/1
  # DELETE /showdowns/1.json
  def destroy
    @showdown = Showdown.find(params[:id])
    @showdown.destroy

    respond_to do |format|
      format.html { redirect_to showdowns_url }
      format.json { head :ok }
    end
  end
  
  def next_vote
    previous_showdown = params[:showdown] ? params[:showdown].to_i - 1 : nil
    if previous_showdown == 0
      @previous_showdown = nil
    elsif previous_showdown >= 1
      @previous_showdown = previous_showdown
    end
    if user_signed_in?
      user_voted = current_user.votes.map(&:showdown_id)
      showdowns = !user_voted.empty? ? Showdown.next_vote(user_voted) : Showdown.scoped
      @showdowns = Kaminari.paginate_array(showdowns).page(params[:showdown]).per(1)
    else
      showdowns = Showdown.scoped
      @showdowns = showdowns.page(params[:showdown]).per(1)
    end
    
    respond_to do |format|
      format.html
      format.js { render :layout => false }
    end
  end
  
end
