module SessionsHelper

  	def sign_in(user)
    		remember_token = User.new_remember_token
    		cookies.permanent[:remember_token] = remember_token
    		user.update_attribute(:remember_token, User.hash(remember_token))
    		self.current_user=(user)

    end

    def json_sign_in(user)
      remember_token = user.remember_token
      remember_token ||= User.new_remember_token
      user.update_attribute(:remember_token, User.hash(remember_token))
      self.current_user=(user)
      return remember_token
    end

    def signed_in?
    	if !current_user.nil?
        user = User.find(current_user.id)
        if(user.confirm == false)
          sign_out
          return false
        else
          return true
        end
      else
         return false
      end

    end

    def is_coordinator?

      if current_user.type.id == 1
        return true
      else
        redirect_to current_user
        return false
      end

    end

    def confirmed_user?
      @user = User.where(:id => params[:id])[0]
      if @user != nil
        if @user.confirm == true
          return true
        else
          respond_to do |format|
            #flash[:success] = "Perfil Atualizado"
            format.html { redirect_to root_path, :notice => 'Usuário Inválido'}
            format.json { head :no_content }
          end
        end
      else
        respond_to do |format|
          #flash[:success] = "Perfil Atualizado"
          format.html { redirect_to root_path, :notice => 'Usuário Inexistente'}
          format.json { head :no_content }
        end
      end

    end

    def json_confirmed_user?
      @user = User.where(:id => params[:id])[0]
      @confirm = @user.confirm
      if @confirm != nil
        if @confirm.confirm == true
          return true
        else
          if params[:callback]
            render :json => {"status"=>"unauthorized"}, :callback => params[:callback], :status => :accepted
          else
            render :json => {"status"=>"unauthorized"}, :status => :accepted
          end
        end
      else
        if params[:callback]
          render :json => {"status"=>"unauthorized"}, :callback => params[:callback], :status => :accepted
        else
          render :json => {"status"=>"unauthorized"}, :status => :accepted
        end
      end

    end

    def signed_in_user
      if signed_in? == false
        store_location
        if(params[:access_token])
          if params[:callback]
            render :json => {"status"=>"unauthorized"}, :callback => params[:callback], :status => :accepted
          else
            render :json => {"status"=>"unauthorized"}, :status => :accepted
          end
        else
          redirect_to signin_url, :notice => "Faça o login."
        end
      end
    end

    def json_signed_in_user
      if signed_in? == false
        store_location
        render :json => { :notice => "Faça o login." }, :status => :not_acceptable
      end
    end


    def current_user=(user)
    	@current_user = user
  	end

    def current_user
      if(params[:access_token])
        remember_token = User.hash(params[:access_token])
        return @current_user ||= User.where(:remember_token => remember_token)[0]
      else
        remember_token = User.hash(cookies[:remember_token])
        return @current_user ||= User.where(:remember_token => remember_token)[0]
      end

    end


    def sign_out
      if !current_user.nil?
        current_user.update_attribute(:remember_token, User.hash(User.new_remember_token))
      end
      cookies.delete(:remember_token)
      self.current_user = nil
      if(params[:access_token])
        if params[:callback]
          render :json => {"menssage"=>"unauthorized"}, :callback => params[:callback], :status => :accepted
        else
          render :json => {"menssage"=>"unauthorized"}, :status => :accepted
        end
      else
        redirect_to signin_url, :notice => "Faça o login."
      end
    end

    def current_user?(user)
      user == current_user
    end

    def redirect_back_or(default)
      redirect_to(session[:return_to] || default)
      session.delete(:return_to)
    end

    def store_location
      session[:return_to] = request.url if request.get?
    end
    

end
