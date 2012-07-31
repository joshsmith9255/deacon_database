class HomeController < ApplicationController
  def index
  end

  def about
  end

  def contact
  end

  def privacy
  end
  
  def search
    @query = params[:query]
    @deacons = Deacon.search(@query)
    @clients = Client.search(@query)
    @total_hits = @deacons.size + @clients.size
  end

end