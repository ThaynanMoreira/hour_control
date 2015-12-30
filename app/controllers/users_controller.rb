class UsersController < ApplicationController
    before_filter  :set_user, :only => [:show, :edit, :update, :destroy]
    before_filter  :correct_user,   :only => [:edit, :update]
    before_filter  :signed_in_user, :only => [:index, :show, :edit, :update]
    before_filter :confirmed_user?, :only => [:show]

    #autocomplete(:user, :name, :full => true)

  def show
	    @user = User.where(:id => params[:id])[0]

	    #@feedHistorics = @user.historics.where(:work_date => (Time.now.beginning_of_month..Time.now.end_of_month)).paginate(page: params[:page], :per_page => 25)
       @search = Search.new(params[:search])

       if(!params[:date].nil?)
         @date = Date.parse(Date.parse(params[:date]).strftime"%m/01/%Y")
       else
         @date = Date.today
       end


       @meses = {1 => "Janeiro", 2 => "Fevereiro", 3 => "Março", 4 => "Abril", 5 => "Maio", 6 => "Junho",
                 7 => "Julho", 8 => "Agosto", 9 => "Setembro", 10 => "Outubro", 11 => "Novembro",12  => "Dezembro"}


       @feedHistorics =  User.where(:id => params[:id])[0].historics.where(:work_date => (@date.beginning_of_month..@date.end_of_month))

       if(params[:date] == nil)
         @date = Date.today.to_s
         @month = Date.today.month
         @mes = @meses[Date.today.month]
         @days = @search.listDays(@user.historics, @date)
         @chart = @search.createChartToUsers(@user, Time.now.beginning_of_month, Time.now.end_of_month)

       else
         @month = params[:month]
         @mes = @meses[@date.month]
         @days = @search.listDays(@user.historics, @date.to_s )
         @chart = @search.createChartToUsers(@user, @date.beginning_of_month, @date.end_of_month)
         params = {}
       end


       respond_to do |format|
         format.js
         format.html
       end

    end

	  def index

      #@search = Search.new({"search"=>{"search_word"=>{}}})
      @search = Search.new(params[:search])

      @users_confirm = Confirmation.where(:confirm => true)
      @list_search_users = @search.search_by_name(User)
      @users = []#@list_search_users.where(:id => @users_confirm.id)
      @list_search_users.each do |user|
           #@confirm = Confirmation.where(:user_id => user.id).first
           if @users_confirm.where(:user_id => user.id)[0] != nil
             if @users_confirm.where(:user_id => user.id)[0].confirm == true
               @users.append(user)
             end
           end

      end
      @chart_user = User.all.first
      if(!@users.blank?)
        @list_users = @users.collect{ |t| [t.name, t.id]}
        @chart_user = @users.first
      else
        @list_users = User.all.collect{ |t| [t.name, t.id]}
      end

      if(params[:user] == nil || params[:of_date] == nil) || (params[:to_date] == nil)
        if(!@chart_user.nil?)
          @chart = @search.createChartToUsers(@chart_user, Date.today.beginning_of_month, Date.today.end_of_month)
        else
          @chart = @search.createChartToUsers(User.first, Date.today.beginning_of_month, Date.today.end_of_month)
        end

      else
        @chart = @search.createChartToUsers(User.find(params[:user].last), Date.parse(params[:of_date]),
                                     Date.parse(params[:to_date]))
        params = {}
      end

      params = {}

      respond_to do |format|
        format.js
        format.html
      end

	  end

	  def new
	  	@user = User.new
	  	@types = Type.all.collect{ |t| [t.name, t.id]}
	  end

	  def edit
	  	@user = User.find(params[:id])
	  	@types = Type.all.collect{ |t| [t.name, t.id]}
	  end


	  def update
	    respond_to do |format|
	      if @user.update_attributes(params[:user])
	        flash[:success] = "Perfil Atualizado"
	        format.html { redirect_to @user, :notice => 'Usuário foi atualizado com sucesso .' }
	        format.json { head :no_content }
	      else
	        format.html { render :action => 'edit' }
	        format.json { render :json => @user.errors, :status => :unprocessable_entity }
	      end
	    end
	  end

	def create
	    @user = User.new(params[:user])

      respond_to do |format|
        if @user.save

          @confirm = Confirmation.create(:user_id => @user.id)

          flash[:success] = "Aguarde a aprovação de um coordenador"
          format.html { redirect_to root_path, :notice => 'Aguarde a aprovação de um coordenador' }
          format.json { head :no_content }
        else
          flash[:error] = "Erro ao se cadastrar"
          format.html { render :action => 'new' }
          format.json { render :json => @user.errors, :status => :unprocessable_entity }
        end
      end
	  end


	private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    #def user_params
    #  params.require(:user).permit(:name, :email, :password, :password_confirmation, :type_id)
    #end

    
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
    

end
