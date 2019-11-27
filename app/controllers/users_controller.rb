class UsersController < ApplicationController
  API_KEY = 'RGAPI-869d9712-abe9-4177-84a2-90c7afb337b3' #取得したAPIKEY
  require 'net/http'
  require 'uri'
  require 'json'
  def index
  end

  def result
    @input = ActiveSupport::OrderedOptions.new
    @input = serch_params[:name]
    @input = "ぐんぐん太郎"#テスト用にサモナー名を入力
    @kekka_data = serch(@input)#id.accountid,name,summonerLevel,revisionDate,profilelconid,puuid
    @summoner_name = @kekka_data["name"] 
  end

  private
  def serch(input)
  uri = URI.parse URI.encode("https://jp1.api.riotgames.com/lol/summoner/v4/summoners/by-name/#{input}?api_key=#{API_KEY}")
  return_data = Net::HTTP.get(uri)#uriからデータを取得
  #サモナーデータ
  summoner_data = JSON.parse(return_data)#ハッシュに変換して取得
  end

 def serch_params
   params.permit(:name)
 end
end
