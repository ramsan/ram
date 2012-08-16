class VisitsController < ApplicationController
  before_filter :splash_user, :except => [:create]
  def create
    @v = params[:visit]
    @visit = Visit.new(params[:visit])
    
      # respond_to do |format|
        if @visit.save
          Email.notify_team(@visit).deliver
          redirect_to splash_path(:notice => "Thank you!")
          # format.xml  { render :xml => @contact, :status => :created, :location => @contact }
        else
          redirect_to splash_path(:video => @v, :alert => @visit.errors.first)
          # format.xml  { render :xml => @contact.errors, :status => :unprocessable_entity }
        end
      # end

  end

end
