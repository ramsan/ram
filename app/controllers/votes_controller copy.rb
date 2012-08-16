class VotesController < ApplicationController
  ## Disabling users login for showdown
  #before_filter :authenticate_user!
  load_and_authorize_resource
  
  # GET /votes
  # GET /votes.json
  def index
    @votes = Vote.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @votes }
    end
  end

  # GET /votes/1
  # GET /votes/1.json
  def show
    @vote = Vote.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @vote }
    end
  end

  # GET /votes/new
  # GET /votes/new.json
  def new
    @vote = Vote.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @vote }
    end
  end

  # GET /votes/1/edit
  def edit
    @vote = Vote.find(params[:id])
  end

  # POST /votes
  # POST /votes.json
  def create
    @vote = Vote.new(params[:vote])
    respond_to do |format|
      if @vote.save
        
        if @vote.memory_1 == true
          @vote.showdown.memory_1_votes_count += 1
          @vote.showdown.update_column(:memory_1_votes_count, @vote.showdown.memory_1_votes_count)
        elsif @vote.memory_2 == true
          @vote.showdown.memory_2_votes_count += 1
          @vote.showdown.update_column(:memory_2_votes_count, @vote.showdown.memory_2_votes_count)
        elsif @vote.memory_3 == true
          @vote.showdown.memory_3_votes_count += 1
          @vote.showdown.update_column(:memory_3_votes_count, @vote.showdown.memory_3_votes_count)
        elsif @vote.memory_4 == true
          @vote.showdown.memory_4_votes_count += 1
          @vote.showdown.update_column(:memory_4_votes_count, @vote.showdown.memory_4_votes_count)
        elsif @vote.memory_5 == true
          @vote.showdown.memory_5_votes_count += 1
          @vote.showdown.update_column(:memory_5_votes_count, @vote.showdown.memory_5_votes_count)
        end
        
        @showdown = Showdown.find(@vote.showdown_id)
        format.html { redirect_to @vote, :notice => 'Vote was successfully created.' }
        format.json { render :json => @vote, :status => :created, :location => @vote }
        format.js { render :layout => false }
      else
        format.html { render :action => "new" }
        format.json { render :json => @vote.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /votes/1
  # PUT /votes/1.json
  def update
    @vote = Vote.find(params[:id])

    respond_to do |format|
      if @vote.update_attributes(params[:vote])
        format.html { redirect_to @vote, :notice => 'Vote was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @vote.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /votes/1
  # DELETE /votes/1.json
  def destroy
    @vote = Vote.find(params[:id])
    @vote.destroy

    respond_to do |format|
      format.html { redirect_to votes_url }
      format.json { head :ok }
    end
  end
end
