class StocksController < ApplicationController

    def search
        if params[:stock].present?
            @stock = Stock.new_lookup(params[:stock])
            if @stock
                respond_to do |format|
                    format.js { render partial: 'users/result.js' }
                end
            else
                flash.now[:alert] = "Please enter a valid ticker symbol to search"
                # render 'users/my_portfolio'
            end
        else
            flash.now[:alert] = "Please enter a ticker symbol to search"
            # render 'users/my_portfolio'
        end
    end
    
end