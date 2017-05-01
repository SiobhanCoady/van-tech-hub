class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def create
      user_params = params.require(:user).permit([:first_name, :last_name, :email, :password, :organization_id])
      @user = User.new(user_params)
      if @user.save
        session[:user_id] = @user.id
        redirect_to directory_index_path, notice: 'Thank you for signing up'
    else
      redirect_to new_user_path, alert: 'passwords must match!'
    end
  end

  def edit
  @user = User.find params[:id]

  end

  def update
  @user = User.find params[:id]
  user_params = params.require(:user).permit([:first_name, :last_name, :email, :password, :is_admin, :organization_id, :org_approved ])
  @user.update(user_params)
  redirect_to admin_index_path, notice: 'User updated!'

  end

  def destroy
    @user = User.find params[:id]
    @user.destroy
    redirect_to admin_index_path, notice: 'User deleted!'
  end



end
