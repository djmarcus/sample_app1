class UsersController < ApplicationController
  before_filter :authenticate,       :only => [:index, :edit, :update, :destroy]
  before_filter :correct_user,       :only => [:edit, :update]
  before_filter :admin_user,         :only => :destroy

  def show
    @user = User.find(params[:id])
    @title = @user.name
  end 

  def new
    unless signed_in?
      @user = User.new
      @title = "Sign up"
    else
      flash[:info] = "Must log out to create new user!"
      redirect_to root_path
    end
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      @user.password = nil
      @user.password_confirmation = nil
      @title = "Sign up"
      render 'new'
    end
  end
  
  def edit
    @title = "Edit user"
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated."
      redirect_to @user
    else
      @title = "Edit user"
      render 'edit'
    end
  end

  def index
    @title = "All users"
    @users = User.paginate(:page => params[:page])
  end 
 
  def destroy
    if User.find(params[:id]).admin?
      flash[:info] = "Admins cannot delete themselves!"
    elsif
      User.find(params[:id]).destroy
      flash[:success] = "User destroyed."
    end  
    redirect_to users_path
  end
 
private
    
    def not_signed_in_user
      deny_access unless !signed_in?
    end
    
    def authenticate
      deny_access unless signed_in?
    end
  
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end
   
    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
end
