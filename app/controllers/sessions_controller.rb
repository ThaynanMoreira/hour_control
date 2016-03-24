  class SessionsController < ApplicationController

	def new
	end

	def create

    if(params[:session].nil?)
      email = params[:email]
      password = params[:password]
    else
      email = params[:session][:email]
      password = params[:session][:password]
    end

    user = User.where(:email => email)[0]
		if (user && user["password_hash"] == BCrypt::Engine.hash_secret(password, user["password_salt"]))
      if(user.confirm == true)
        respond_to do |format|
          format.html {
            sign_in user
            redirect_back_or daily_path(:day => (Date.today.strftime"%Y-%m-%d"))
          }
          if params[:callback]
            token = json_sign_in user
            format.json { render :json => {:access_token => token},:status => :accepted, :result => :accepted, :callback => params[:callback]}
          else
            token = json_sign_in user
            format.json { render :json => {:access_token => token}, :status => :accepted, :result => :accepted}
          end
        end
      else
        respond_to do |format|
          format.html {
            flash[:error] = 'Você ainda não recebeu autorização de um coordenador' # Not quite right!
            redirect_to signin_path
          }
          if params[:callback]
            format.json { render :json => {:error_message => 'Você ainda não recebeu autorização de um coordenador'},:status => 401, :result => :accepted, :callback => params[:callback]}
          else
            token = json_sign_in user
            format.json { render :json => {:error_message => 'Você ainda não recebeu autorização de um coordenador'},:status => 401, :result => :accepted}
          end
        end
      end
    else
      respond_to do |format|
        format.html {
          flash[:error] = 'Invalid email/password combination' # Not quite right!
          redirect_to signin_path
        }
        if params[:callback]
          format.json { render :json => {:error_message => 'Invalid email/password combination'},:status => 401, :result => :accepted, :callback => params[:callback]}
        else
          token = json_sign_in user
          format.json { render :json => {:error_message => 'Invalid email/password combination'},:status => 401, :result => :accepted}
        end
      end
		end
	end

	def destroy
		sign_out
		redirect_to root_url
	end
	
end
