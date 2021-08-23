class UsersController < ApplicationController
  before_action :authenticate_user!

  def my_portfolio
    @tracked_stocks = current_user.stocks
  end

end
