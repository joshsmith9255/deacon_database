class DeaconsController < ApplicationController

  def index
    @deacons = Deacon.active.alphabetical.paginate(:page => params[:page]).per_page(10)
    @inactive_deacons = Deacon.inactive.alphabetical.paginate(:page => params[:page]).per_page(10)
  end

  def show
    @deacon = Deacon.find(params[:id])
    # get the assignment history for this deacon
    @assignments = @deacon.assignments.chronological.paginate(:page => params[:page]).per_page(5)
    # get upcoming shifts for this deacon (later)
    
  end

  def new
    @deacon = Deacon.new
  end

  def edit
    @deacon = Deacon.find(params[:id])
  end

  def create
    @deacon = Deacon.new(params[:deacon])
    if @deacon.save
      # if saved to database
      flash[:notice] = "Successfully created #{@deacon.proper_name}."
      redirect_to @deacon # go to show deacon page
    else
      # return to the 'new' form
      render :action => 'new'
    end
  end

  def update
    @deacon = Deacon.find(params[:id])
    if @deacon.update_attributes(params[:deacon])
      flash[:notice] = "Successfully updated #{@deacon.proper_name}."
      redirect_to @deacon
    else
      render :action => 'edit'
    end
  end

  def destroy
    @deacon = Deacon.find(params[:id])
    @deacon.destroy
    flash[:notice] = "Successfully removed #{@deacon.proper_name} from the ACAA system."
    redirect_to deacons_url
  end
end
