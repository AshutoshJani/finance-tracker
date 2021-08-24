class UsersController < ApplicationController
  before_action :authenticate_user!

  def my_portfolio
    @user = current_user
    @tracked_stocks = current_user.stocks
  end

  def my_friends
    @friends = current_user.friends
  end

  def show
    @user = User.find(params[:id])
    @tracked_stocks = @user.stocks
  end

  def search
    if params[:friend].present?
        @friends = User.search(params[:friend])
        @friends = current_user.except_current_user(@friends)
        if @friends.present?
          respond_to do |format|
            format.js { render partial: 'users/friend_result.js' }
          end
        else
          respond_to do |format|
            flash.now[:alert] = "Cannot find any user with that name or email"
            format.js { render partial: 'users/friend_result.js' }
          end
        end
    else
      respond_to do |format|
        flash.now[:alert] = "Please enter an email id or name to search"
        format.js { render partial: 'users/friend_result.js' }
        # render 'users/my_portfolio'
      end
    end
  end

end
