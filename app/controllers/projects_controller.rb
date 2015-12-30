class ProjectsController < ApplicationController
  before_filter :set_project, :only => [:show, :edit, :update, :destroy]
  before_filter :signed_in_user
  before_filter :correct_project,   :only => [:edit, :update]
  before_filter :is_coordinator?, :only => [:new, :create, :edit, :update]
  #autocomplete(:project, :name, :full => true)

  def index
    @search = Search.new(params[:search])
    @types = Type.all.collect{ |t| [t.name, t.id]}

    #@projects = Project.all
    @project = current_user.projects.build()

    @list_projects = Project.all.collect{ |t| [t.name, t.id]}
    @projects = @search.search_by_name(Project)
    if(params[:pr] == nil || params[:of_date] == nil) || (params[:to_date] == nil || params[:type] == nil)
      @chart = @search.createChartToProjects(Project.first, Date.today.beginning_of_month, Date.today.end_of_month, current_user.type.id)

    else
      @chart = @search.createChartToProjects(Project.find(params[:pr].last), Date.parse(params[:of_date]),
                                          Date.parse(params[:to_date]), (params[:type].last))
      params = {}
    end

    params = {}
  end

  def new
    @projects = Project.new
    @types = Type.all.collect{ |t| [t.name, t.id]}
    @clients = Client.all.collect{ |t| [t.name, t.id]}
    
  end

  def create
    @project = current_user.projects.build(params[:project])


    if @project.save
      flash[:success] = "Project created!"

      timetable_save(0, @project)



      @relation = current_user.relations.build(:project_id => @project.id)
      @relation.save
      
      redirect_to @project
    else
      flash[:error] = "Project failed"
      redirect_to new_project_path
    end
  end

  def edit
  end

  def update

      respond_to do |format|
        if @project.update_attributes(params(:project))
          flash[:success] = "Profile updated"
          format.html { redirect_to @user, :notice => 'User was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render :action => 'edit' }
          format.json { render :json => @user.errors, :status => :unprocessable_entity }
        end
      end
    end
  

  def show
    @timetable = @project.timetables.build
    @types = Type.all.collect{ |t| [t.name, t.id]}
    @listTimetables = @project.timetables.paginate(:page => params[:page], :per_page => 10)

    @tasks = Task.all.collect{ |t| [t.name, t.id]}

    @search = Search.new(params[:search])

    @feedHistorics =  @project.historics


    @meses = {1 => "Janeiro", 2 => "Fevereiro", 3 => "Março", 4 => "Abril", 5 => "Maio", 6 => "Junho",
              7 => "Julho", 8 => "Agosto", 9 => "Setembro", 10 => "Outubro", 11 => "Novembro",12  => "Dezembro"}

    if(params[:date] == nil)
      @date = Date.today
      @month = Date.today.month
      @mes = @meses[Date.today.month]
      @days = @search.listDays(current_user.historics_followeds, @date.to_s)

    else
      @month = params[:month]
      @date = Date.parse(Date.parse(params[:date]).strftime"%m/01/%Y")
      @mes = @meses[@date.month]
      @days = @search.listDays(current_user.historics_followeds, @date.to_s )
      params = {}
    end




    params = {}

    @download =  project_path(:format => "xls")
    respond_to do |format|
      format.html { render }
      format.xls
    end

  end

  def correct_project
    @project = Project.where(:id => params[:id])[0]
    redirect_to(root_url) unless current_user?(@project.user)
  end

  private
    # Use callbacks to share common setup or constraints between actions.

    def set_project
      @project = Project.find(params[:id])
    end

     #def project_params
     # params.require(:project).permit(:name)
     #end

    def timetable_save(timetable_num, project)

      timetable_name = "timetable#{timetable_num}"

      timetable = Timetable.new(:hours_amount => params[timetable_name][:hours_amount], :type_id => params[timetable_name][:type_id], :project_id => project.id, :hours_completed => 0, :month => Date.today.month, :year => Date.today.year )
      #timetable.hours_completed = 0

      if timetable.save

      else
        flash[:error] = "Timetable failed"
      end

      if  params["timetable#{timetable_num+1}"] != nil
        timetable_save(timetable_num+1, project)
      end

    end

    
    

end
