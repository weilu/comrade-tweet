class UsersController < ApplicationController

  def edit
  end

  def update
    current_user.filter_regex = params[:user][:filter_regex]
    if current_user.save
      current_user.messages.destroy_all
      flash[:notice] = 'Filter updated'
    else
      flash[:warning] = 'Failed to update filter'
    end

    redirect_to edit_user_path(current_user)
  end

end