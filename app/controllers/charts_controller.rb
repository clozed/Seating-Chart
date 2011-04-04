class ChartsController < ApplicationController
  # GET /charts
  # GET /charts.xml
  def index
    #Find a seat that someone clicked on in the chart
    #only if they are logged in
    if params[:id] != nil && session[:user_id] != nil
         @seat = Chart.first(:conditions => {:seat=>params[:id]})

         # Check that the seat is empty
         if @seat.user_id == nil && @seat.id != nil
	     # The seat is empty, add this user to it
            # but first remove the user from any other seat
            Chart.update_all({:user_id => nil}, {:user_id => session[:user_id]})
            Chart.update(params[:id], {:user_id => session[:user_id]})

            # Display success message
            flash.now[:success] = "You are now sitting in seat #{params[:id]}!"
         elsif @seat.user_id == session[:user_id]
            # The user is already is that seat, so remove them
            Chart.update(params[:id], {:user_id => nil})
            flash.now[:success] = "You are no longer sitting in seat #{params[:id]}!"
         else
            # Display error message, seat taken
            flash.now[:error] = "Sorry, but that seat is currently occupied."
         end
    end

    # Get all seats in the chart
    @charts = Chart.all
    @charts.each_with_index do |seat, index|
	if seat.user_id != nil
		@charts[index].username = User.first(:conditions => {:id=>seat.user_id}).username
	end
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @charts }
    end
  end

  # GET /charts/1
  # GET /charts/1.xml
  def show
    @chart = Chart.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @chart }
    end
  end

  # GET /charts/new
  # GET /charts/new.xml
  def new
    @chart = Chart.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @chart }
    end
  end

  # GET /charts/1/edit
  def edit
    @chart = Chart.find(params[:id])
  end

  # POST /charts
  # POST /charts.xml
  def create
    @chart = Chart.new(params[:chart])

    respond_to do |format|
      if @chart.save
        format.html { redirect_to(@chart, :notice => 'Chart was successfully created.') }
        format.xml  { render :xml => @chart, :status => :created, :location => @chart }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @chart.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /charts/1
  # PUT /charts/1.xml
  def update
    @chart = Chart.find(params[:id])

    respond_to do |format|
      if @chart.update_attributes(params[:chart])
        format.html { redirect_to(@chart, :notice => 'Chart was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @chart.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /charts/1
  # DELETE /charts/1.xml
  def destroy
    @chart = Chart.find(params[:id])
    @chart.destroy

    respond_to do |format|
      format.html { redirect_to(charts_url) }
      format.xml  { head :ok }
    end
  end
end
