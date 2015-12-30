class TimetablesController < ApplicationController

	before_filter :set_timetable, :only =>  [  :edit, :update, :destroy]
  before_filter :signed_in_user, :only => [:create, :destroy]

    def edit
    end	

    def update

      if @timetable.update_attributes(params[:timetable])
        flash[:success] = "Timetable updated"
        #@timetable.updateHours
        redirect_to @timetable.project 
      else
      	flash[:error] = "Timetable updated"
        redirect_to @timetable.project 
      end

    end

  	def new
  		@timetable = Timetable.new()
  	end

	def create
		@timetable = Timetable.new(params[:timetable])
    @timetable.hours_completed = 0

    @timetable.month = Date.parse(params["date"]).month
    @timetable.year = Date.parse(params["date"]).year

		if @timetable.save
		  flash[:success] = "Timetable created!"
		  
		  redirect_to @timetable.project
		else
		  flash[:error] = "Timetable failed"
		  
		  redirect_to @timetable.project 

		end

	end



	 def destroy
      @project = @timetable.project
	    @timetable.destroy
	    redirect_to @project
	    
	  end


    

	 private
    # Use callbacks to share common setup or constraints between actions.
    def set_timetable
      @timetable = Timetable.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    #def timetable_params
    #  params.require(:timetable).permit(:hours_amount, :type_id, :project_id, :observation)
    #end


end
