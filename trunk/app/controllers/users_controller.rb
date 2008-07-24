class UsersController < ApplicationController

  

  # render new.rhtml
  def new
  end

  def create
    cookies.delete :auth_token
    # protects against session fixation attacks, wreaks havoc with 
    # request forgery protection.
    # uncomment at your own risk
    # reset_session
    @user = User.new(params[:user])
    @user.save
    if @user.errors.empty?
      self.current_user = @user
      redirect_back_or_default('/')
    else
      render :action => 'new'
    end
  end
  
  def show
    @user = User.find_by_username(params[:id])
    
    @recommendations = Recommendation.find(:all, :conditions => ["user_id = ?", @user.id], :limit => 10, :order => "created_at DESC")
    
    @descriptions = Description.find(:all, :conditions => ["user_id = ?", @user.id], :limit => 10, :order => "created_at DESC")

    @justifications = Justification.find(:all, :conditions => ["user_id = ?", @user.id], :limit => 10, :order => "created_at DESC")

    
  end

end
