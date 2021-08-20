class Stock < ApplicationRecord

    def self.new_lookup(ticker)
        client = IEX::Api::Client.new(
            publishable_token: Rails.application.credentials.iex_cloud[:sandbox_api_key],
            endpoint: 'https://sandbox.iexapis.com/v1'
          )
        begin
            new(ticker: ticker, name: client.company(ticker).company_name, last_price: client.price(ticker))
        rescue => exception
            return nil
        end
    end

end
