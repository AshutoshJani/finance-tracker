class StocksController < ApplicationController
    respond_to :html, :json

    def search
        if params[:stock].present?
            @stock = Stock.new_lookup(params[:stock])
            if @stock
                respond_to do |format|
                    format.js { render partial: 'users/result.js' }
                end
            else
                respond_to do |format|
                    flash.now[:alert] = "Please enter a valid ticker symbol to search"
                    format.js { render partial: 'users/result.js' }
                    # render 'users/my_portfolio'
                end
            end
        else
            respond_to do |format|
                flash.now[:alert] = "Please enter a ticker symbol to search"
                format.js { render partial: 'users/result.js' }
                # render 'users/my_portfolio'
            end
        end
    end

    def update
        @stock = Stock.find(params[:stock])
        @stock.last_price = Stock.update_prices(@stock.ticker)
        @stock.save

        redirect_to my_portfolio_path
    
    end
    
end