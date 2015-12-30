  class SessionsController < ApplicationController

	def new
	end

	def create
		user = User.where(:email => params[:session][:email].downcase)[0]
		if (user && user["password_hash"] == BCrypt::Engine.hash_secret(params[:session][:password], user["password_salt"]))
      if(Confirmation.where(:user_id => user.id)[0]["confirm"] == true)
			  sign_in user
      	redirect_back_or daily_path(:day => (Date.today.strftime"%Y-%m-%d"))
      else
        flash[:error] = 'Você ainda não recebeu autorização de um coordenador' # Not quite right!
        redirect_to signin_path
      end
		else
			flash[:error] = 'Invalid email/password combination' # Not quite right!
      		redirect_to signin_path
		end
	end

	def destroy
		sign_out
		redirect_to root_url
	end
	
end
