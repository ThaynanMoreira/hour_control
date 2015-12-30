class HistoricsController < ApplicationController
  before_filter :set_historic, :only =>  [ :clone, :edit, :update, :destroy]
  before_filter :signed_in_user, :only => [:create, :clone, :new, :edit, :update, :destroy]


    def edit
      @projects = current_user.projects_followeds.collect{ |t| [t.name, t.id]}


      @tasks = Task.all.collect{ |t| [t.name, t.id]}
    end

    def clone
      @projects = current_user.projects_followeds.collect{ |t| [t.name, t.id]}


      @tasks = Task.all.collect{ |t| [t.name, t.id]}
    end

    def update
      @historic.hours_used = 0
      @historic.hours_used = ((@historic.exit_work - @historic.enter_work)/ 1.hour)


        if @historic.update_attributes(params[:historic])
          flash[:success] = "Historico foi editado"
          redirect_to daily_path(:day => (Date.parse("#{@historic.work_date}").strftime"%Y-%m-%d"))
        else
          flash[:error] = "Historic não foi editado"
          redirect_to daily_path(:day => (Date.parse("#{@historic.work_date}").strftime"%Y-%m-%d"))
        end

    end

  	def new
  		@historic = Historic.new
  	end

	def create
		@historic = Historic.new(params[:historic])
		@historic.user_id = current_user.id
    @historic.type_id = current_user.type_id
    @historic.hours_used = 0
    @historic.hours_used = ((@historic.exit_work - @historic.enter_work)/ 1.hour)

    if (@historic.hours_used != nil)
      if @historic.hours_used < 0
        flash[:error] = "Historic failed"

          redirect_to @historic.timetable.project
      else
        if @historic.save!
          flash[:success] = "Historic created!"

          #@historic.timetable.updateHours

          redirect_to daily_path(:day => (Date.parse("#{@historic.work_date}").strftime"%Y-%m-%d"))
        else
          flash[:error] = "Historic failed"

          redirect_to daily_path(:day => (Date.parse("#{@historic.work_date}").strftime"%Y-%m-%d"))

        end
      end
    else
      flash[:error] = "Historic failed"

      redirect_to daily_path(:day => (Date.parse("#{@historic.work_date}").strftime"%Y-%m-%d"))

    end

	end



	def destroy
       h = @historic
	    @historic.destroy
      flash[:success] = "Historico foi deletado."
      redirect_to daily_path(:day => (Date.parse("#{h.work_date}").strftime"%Y-%m-%d"))

	  end


	 private
	  
    # Use callbacks to share common setup or constraints between actions.
    def set_historic
      @historic = Historic.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    #def historic_params
    #  params.require(:historic).permit(:user_id, :hours_used, :project_id, :work_date, :enter_work, :exit_work, :comment, :task_id)
    #end
    
    

end
