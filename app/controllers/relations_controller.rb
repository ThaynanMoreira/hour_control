class RelationsController < ApplicationController

  before_filter :signed_in_user, :only => [:create, :destroy]


	def edit
    end	

	def update
    end	

	def new
    end	


	def create

		#@relation = Relations.new
		#@relation.project_id = relationship_params[:project_id]
		#@relation.user_id = current_user.id
    @user = User.find(params[:user_id])
    @project = Project.find(params[:project_id])
		@relation = @user.relations.build(:project_id => params[:project_id])

		if @relation.save
		  #flash[:success] = "Relationship created!"
      @user_id = @user.id
      @project_id = @project.id
      respond_to do |format|
        format.html { redirect_to add_projects_path(:id => params[:user_id]) }
        format.js
      end
		else
		  #flash[:error] = "Relationship failed"

      respond_to do |format|
        format.html { redirect_to add_projects_path(:id => params[:user_id]) }
        format.js
      end
		end
	end


	def destroy

    relation = Relation.where(:id => params[:id])[0]
    @user = relation.user
    @user_id = @user.id
    @project = relation.project
    @project_id = @project.id

    relation.destroy


    respond_to do |format|
      format.html { redirect_to add_projects_path(:id => @user.id) }
      format.js
    end
	end



	private

    # Never trust parameters from the scary internet, only allow the white list through.
    #def relations_params
    #  params.require(:relation).permit(:project_id)
    #end
end
