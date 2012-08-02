class ClientsController < ApplicationController

  def index
    @clients = Client.active.alphabetical.paginate(:page => params[:page]).per_page(10)
    @inactive_clients = Client.inactive.alphabetical.paginate(:page => params[:page]).per_page(10)
  end

  def show
    @client = Client.find(params[:id])
    # get all the current assignments for this client
    @current_assignments = @client.assignments.current.by_deacon.paginate(:page => params[:page]).per_page(8)
  end

  def new
    @client = Client.new
  end

  def edit
    @client = Client.find(params[:id])
  end

  def create
    @client = Client.new(params[:client])
    if @client.save
      # if saved to database
      flash[:notice] = "Successfully created #{@client.name}."
      redirect_to @client # go to show client page
    else
      # return to the 'new' form
      render :action => 'new'
    end
  end

  def update
    @client = Client.find(params[:id])
    if @client.update_attributes(params[:client])
      flash[:notice] = "Successfully updated #{@client.name}."
      redirect_to @client
    else
      render :action => 'edit'
    end
  end

  def destroy
    @client = Client.find(params[:id])
    @client.destroy
    flash[:notice] = "Successfully removed #{@client.name} from the ACAC system."
    redirect_to clients_url
  end
end
