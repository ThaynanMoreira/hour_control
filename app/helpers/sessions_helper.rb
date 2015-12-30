module SessionsHelper

  	def sign_in(user)
    		remember_token = User.new_remember_token
    		cookies.permanent[:remember_token] = remember_token
    		user.update_attribute(:remember_token, User.hash(remember_token))
    		self.current_user=(user)

  	end

    def signed_in?
    	if !current_user.nil?
        confirmation = Confirmation.where(:user_id => current_user.id)[0]
        if(confirmation["confirm"] == false)
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
      @confirm = Confirmation.where(:user_id => params[:id])[0]
      if @confirm != nil
        if @confirm.confirm == true
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

    def signed_in_user
      if signed_in? == false
        store_location
        redirect_to signin_url, :notice => "Please sign in."
      end
    end

    def current_user=(user)
    	@current_user = user
  	end

  	def current_user
      remember_token = User.hash(cookies[:remember_token])
      @current_user ||= User.where(:remember_token => remember_token)[0]

  	end


  	def sign_out
    	current_user.update_attribute(:remember_token, User.hash(User.new_remember_token))
    	cookies.delete(:remember_token)
    	self.current_user = nil
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
