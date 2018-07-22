require 'rest-client'
require 'json'

class ExchangeService
  def initialize(source_currency, target_currency, amount)
    @source_currency = source_currency
    @target_currency = target_currency
    @amount = amount.to_f
  end

 
  def perform
    if [@source_currency, @target_currency].include? 'BTC'
      bitCoinCurrency()
    else
      normalCurrency()
    end
  end


  private

  def bitCoinCurrency
    if @source_currency.eql? 'BTC'
      value = requestApiBitCoin(@target_currency)
      
      value * @amount
    elsif @target_currency.eql? 'BTC'
      value = requestApiBitCoin(@source_currency)

      @amount / value
    end 
  end

  def requestApiBitCoin(currency)
    begin
      url = "https://api.coindesk.com/v1/bpi/currentprice/#{currency}.json"
      res = RestClient.get url

      value = JSON.parse(res.body)['bpi'][currency]['rate_float'].to_f
    rescue RestClient::ExceptionWithResponse => e
      e.response
    end
  end

  def normalCurrency
    begin
      exchange_api_url = Rails.application.credentials[Rails.env.to_sym][:currency_api_url]
      exchange_api_key = Rails.application.credentials[Rails.env.to_sym][:currency_api_key]
      url = "#{exchange_api_url}?token=#{exchange_api_key}&currency=#{@source_currency}/#{@target_currency}"
      res = RestClient.get url
      value = JSON.parse(res.body)['currency'][0]['value'].to_f
      
      value * @amount
    rescue RestClient::ExceptionWithResponse => e
      e.response
    end
  end
end