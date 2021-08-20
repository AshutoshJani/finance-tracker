class UsersController < ApplicationController
  before_action :authenticate_user!

  def my_portfolio
  end

end
