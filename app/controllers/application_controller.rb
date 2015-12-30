require "extend_helper"

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery :with => :exception
def correct_project?
      @project = Project.where(:id => params[:id])[0]
      redirect_to(root_url) unless current_user?(@project.user)
    end
  include SessionsHelper
  
end
