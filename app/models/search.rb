class Search < ActiveRecord::Base
   attr_reader :date, :status, :search_word, :all_status

  def initialize(params)
    @all_status = ["day", "month", "year", "all", "most_recent"]
    @objects_to_search

    params ||= {}
    if(!params[:date].nil?)
      @date = params[:date]
    else
      @date = Date.today.to_s
    end
    if(!params[:status].nil?)
      @status = params[:status]
    else
      @status = @all_status[1]
    end

    if(params[:search_word] != nil)
      @search_word = params[:search_word]
    else
      @search_word = ""
    end

    params[:search_word] ={}
    params = {}

  end



   def search(objects_to_search)
    #time_conditions(objects_to_search).first
    objects_to_search.where(["name LIKE ? ", "%#{@search_word}%"]).where(time_conditions(objects_to_search).first)
   end

   def search_by_name(objects_to_search)
     #time_conditions(objects_to_search).first
     (objects_to_search).where(["name LIKE ? ", "%#{@search_word}%"])
   end

   def createChartToUsers(user, of_date, to_date)
     #listHistorics = user.historics.where(:work_date => (of_date.beginning_of_day..to_date.end_of_day))

     if (!user.projects_followeds.blank?)

       listProjects = user.projects_followeds

       data_table = GoogleVisualr::DataTable.new
       data_table.new_column('string', 'Task')
       data_table.new_column('number', 'Hours')
       data_table.add_rows(listProjects.length)
       @i = 0
       for project in listProjects

         data_table.set_cell(@i, 0, project.name )
         historics = project.historics.where(:user_id => user.id).where(:work_date => (of_date..to_date))
         hours_user = 0
         for historic in historics
           hours_user += historic.hours_used
         end
         data_table.set_cell(@i, 1, hours_user )
         @i +=1
       end

       opts   = { :width => 400, :height => 240, :title => "#{user.name} Horas, #{of_date.strftime"%m/%Y"}", :is3D => true  }
       return @chart = GoogleVisualr::Interactive::PieChart.new(data_table, opts)
     end

   end

   def createChartToProjects(project, of_date, to_date, type)

     if (!project.users_followeds.blank?)

       listUsers = project.users_followeds.where(:type_id => type)

       data_table = GoogleVisualr::DataTable.new
       data_table.new_column('string', 'User')
       data_table.new_column('number', 'Hours')
       data_table.add_rows(listUsers.length)
       @i = 0
       for user in listUsers

         data_table.set_cell(@i, 0, user.name )
         historics = project.historics.where(:user_id => user.id).where(:work_date => (of_date..to_date))
         hours_user = 0
         for historic in historics
           hours_user += historic.hours_used
         end
         data_table.set_cell(@i, 1, hours_user )
         @i +=1
       end

       opts   = { :width => 400, :height => 240, :title => "#{project.name} Horas, #{of_date.strftime"%m/%Y"}", :is3D => true }
       return @chart = GoogleVisualr::Interactive::PieChart.new(data_table, opts)
     end
   end


   def createChartToReports(lista)



     data_table = GoogleVisualr::DataTable.new
     data_table.new_column('string', 'Cargo')
     data_table.new_column('number', 'Horas Contratadas')
     data_table.new_column('number', 'Horas Cumpridas')
     data_table.add_rows(lista.count)
     i = 0
     for l in lista

       data_table.set_cell(i, 0, l[0])
       data_table.set_cell(i, 1, l[1])
       data_table.set_cell(i, 2, l[2])
       i += 1
     end


     opts   = { :width => 600, :height => 240, :title => 'Performance', :hAxis => { :title => 'Cargo', :titleTextStyle => {:color => 'black'} } }
     @chart = GoogleVisualr::Interactive::ColumnChart.new(data_table, opts)

   end




   def listDays(hisorics, date)

       date_range = (Date.parse(date).beginning_of_month..Date.parse(date).end_of_month)

       date_months = date_range.map {|d| Date.new(d.year, d.month, d.day) }.uniq

       return date_months



   end



  private

  def search_by_time(object)

    if(@status == @all_status[0])
      return object.for_day(Date.parse(@date))
    end

    if(@status == @all_status[1])
      return object.for_month(Date.parse(@date))
    end

    if(@status == @all_status[2])
      return   object.for_year(Date.parse(@date))
    end

    if(@status == @all_status[3])
      return   ['']
    end

    if(@status == @all_status[4])
      return  object.most_recent
    end

  end






   def name_conditions
     [:name => "%#{keywords}%"] unless @objects_to_search.name.untrust?
   end

   def time_conditions(objects)
     if(@date == "")

       if(@status == @all_status[3] || @status == @all_status[4])
         search_by_time(objects)
       end

     else
       search_by_time(objects)
     end
   end





end
