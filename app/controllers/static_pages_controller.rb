class StaticPagesController < ApplicationController
  before_filter :signed_in_user, :only => [:daily_view, :users_config, :add_project, :reports]
  before_filter :confirmed_user?, :only => [:add_project]



  def home
    if signed_in?

      redirect_to daily_path


    end
  end

  def monthly_view
  	if signed_in?
      #params ||= {}
      @url_search = monthly_view_path
      #@types = Type.all.collect{ |t| [t.name, t.id]}
      #@search2 = Search.new(params[:search2])
      @listProjects = current_user.projects_followeds.where(["name LIKE ? ", "%#{params[:search2]}%"])

      @tasks = Task.all.collect{ |t| [t.name, t.id]}
      @search = Search.new(params[:search])

      @feedHistorics =  current_user.historics

      @meses = {1 => "Janeiro", 2 => "Fevereiro", 3 => "Março", 4 => "Abril", 5 => "Maio", 6 => "Junho",
                7 => "Julho", 8 => "Agosto", 9 => "Setembro", 10 => "Outubro", 11 => "Novembro",12  => "Dezembro"}



      if(params[:date] == nil)
        @date = Date.today
        @days = @search.listDays(current_user.historics_followeds, @date.to_s)
        @chart = @search.createChartToUsers(current_user, Time.now.beginning_of_month, Time.now.end_of_month)

      else
        @date = Date.parse(Date.parse(params[:date]).strftime"%m/01/%Y")
        @days = @search.listDays(current_user.historics_followeds, @date.to_s )
        @chart = @search.createChartToUsers(current_user, @date.beginning_of_month, @date.end_of_month)
        params = {}
      end

      params = {}
  	end
  end

  def daily_view

    if signed_in?

      @url_search = daily_path

      if(params[:day] == nil)
        @work_date = Date.today.strftime"%Y-%m-%d"
        @days = [Date.parse(Date.today.strftime"%Y-%m-%d")]
      else
        @work_date = params[:day]
        @days = [Date.parse(params[:day])]
      end

      @feedHistorics = current_user.historics_followeds

      @projects = current_user.projects_followeds.collect{ |t| [t.name, t.id]}


      @tasks = Task.all.collect{ |t| [t.name, t.id]}

      @daily = true
    end

  end


  def users_config

    if signed_in?
      if is_coordinator?
        #@projects = Project.all
        #@search = Search.new(params[:search])
        #@users = @search.search_by_name(User)

        @search = Search.new(params[:search])

        @list_search_users = @search.search_by_name(User)
        @users = @list_search_users.where(:confirm => true)
        @no_confirms = User.where(:confirm => false)

      end


    end

  end


  def add_project

    if signed_in?
      if is_coordinator?
        @user = User.find(params[:id])
        @search = Search.new(params[:search])
        @projects = @search.search_by_name(Project)


      end
    end

  end


  def reports

    if signed_in?
      if is_coordinator?
        @types = Type.all.collect{ |t| [t.name, t.id]}
        @projects = Project.all
        @search = Search.new(params[:search])
        @meses = {1 => "Janeiro", 2 => "Fevereiro", 3 => "Março", 4 => "Abril", 5 => "Maio", 6 => "Junho",
                  7 => "Julho", 8 => "Agosto", 9 => "Setembro", 10 => "Outubro", 11 => "Novembro",12  => "Dezembro"}


        if(params[:date] == nil)
          @date = Date.today
          @month = Date.today.month
          @mes = @meses[@date.month]
          @timetables = Timetable.where(:year => Time.now.year).where(:month => Time.now.month)
          @historics = Historic.where(:work_date => @date.beginning_of_month..@date.end_of_month)
          @mes = @meses[Date.today.month]
        else
          @month = params[:month]
          @date = Date.parse(Date.parse(params[:date]).strftime"%m/01/%Y")
          @mes = @meses[@date.month]
          @historics = Historic.where(:work_date => @date.beginning_of_month..@date.end_of_month)
          @timetables = Timetable.where(:year => @date.year).where(:month => @date.month)


          params = {}
        end
        @download = reports_path(:month => @month.to_i, :format => "xls")
        respond_to do |format|
          format.html
          format.xls
        end

      end
    end

  end


end