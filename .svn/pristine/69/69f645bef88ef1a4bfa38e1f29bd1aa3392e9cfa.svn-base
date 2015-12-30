class ConfirmationsController < ApplicationController

	before_filter :signed_in_user, :only => [:create, :destroy]



	def new
  end

  def edit
  end

  def update
  end

  def destroy
    @confirm = Confirmation.where(:user_id => params[:user_id])[0]
    @confirm.destroy
  end



  def create

		#@relation = Relations.new
		#@relation.project_id = relationship_params[:project_id]
		#@relation.user_id = current_user.id

		@confirm = Confirmation.where(:user_id => params[:user_id])[0]
    @confirm.confirm = true
		if @confirm.save
		  flash[:success] = "Confirmation successful!"

		  redirect_to users_config_path
		else
		  flash[:error] = "Confirmation failed"
		  
		  redirect_to users_config_path

		end
	end



end
