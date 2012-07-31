class AssignmentsController < ApplicationController

  def index
    @assignments = Assignment.current.by_client.by_deacon.chronological.paginate(:page => params[:page]).per_page(15)
    @past_assignments = Assignment.past.by_deacon.by_client.paginate(:page => params[:page]).per_page(15)
  end

  def show
    @assignment = Assignment.find(params[:id])
    # get the shift history for this assignment (later; empty now)
    @interventions = Array.new
  end

  def new
    if params[:from].nil?
      if params[:id].nil?
        @assignment = Assignment.new
      else
        @assignment = Assignment.find(params[:id])
      end
    else
      @assignment = Assignment.new
      if params[:from] == "client" 
        @assignment.client_id = params[:id]
      else
        @assignment.deacon_id = params[:id]
      end
    end
  end

  def edit
    @assignment = Assignment.find(params[:id])
  end

  def create
    @assignment = Assignment.new(params[:assignment])
    if @assignment.save
      # if saved to database
      flash[:notice] = "#{@assignment.deacon.proper_name} is assigned to #{@assignment.client.name}."
      redirect_to @assignment # go to show assignment page
    else
      # return to the 'new' form
      render :action => 'new'
    end
  end

  def update
    @assignment = Assignment.find(params[:id])
    if @assignment.update_attributes(params[:assignment])
      flash[:notice] = "#{@assignment.deacon.proper_name}'s assignment to #{@assignment.client.name} is updated."
      redirect_to @assignment
    else
      render :action => 'edit'
    end
  end

  def destroy
    @assignment = Assignment.find(params[:id])
    @assignment.destroy
    flash[:notice] = "Successfully removed #{@assignment.deacon.proper_name} from #{@assignment.client.name}."
    redirect_to assignments_url
  end
end
