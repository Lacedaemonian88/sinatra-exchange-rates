require "sinatra"
require "sinatra/reloader"
require "http"

get("/") do
  @raw = HTTP.get("https://api.exchangerate.host/list?access_key=#{ENV.fetch("EXCHANGE_RATE_KEY")}")
  @string =  @raw.to_s
  @parsed_response = JSON.parse(@string)

  @currencies = @parsed_response.fetch("currencies")

  erb(:homepage)
end

get("/:origin") do
  @symbol = params.fetch("origin")
  @raw = HTTP.get("https://api.exchangerate.host/list?access_key=#{ENV.fetch("EXCHANGE_RATE_KEY").chomp}")
  @string =  @raw.to_s
  @parsed_response = JSON.parse(@string)

  @currencies = @parsed_response.fetch("currencies")
erb(:step_one)
end

get("/:origin/:destination") do

  @from = params.fetch("origin")
  @to = params.fetch("destination")

  @url = "https://api.exchangerate.host/convert?access_key=#{ENV.fetch("EXCHANGE_RATE_KEY").chomp}&from=#{@from}&to=#{@to}&amount=1"

  @raw= HTTP.get(@url)
  @string = @raw.to_s
  @parsed_response = JSON.parse(@string)

  @amount = @parsed_response.fetch("result")

erb(:step_two)
end
