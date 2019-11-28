class UsersController < ApplicationController
  API_KEY = 'RGAPI-edea006b-ed33-4f76-a347-41f71ad6ea9a' #取得したAPIKEY
  require 'net/http'
  require 'uri'
  require 'json'
  def index
  end

  def result
    @input = ActiveSupport::OrderedOptions.new
    @input = serch_params[:name]
    if @input == nil
      redirect_to root_path
    else
    #@input = "ぐんぐん太郎"#APIのテスト用にサモナー名を入力
    @kekka_data = serch(@input)#id.accountid,name,summonerLevel,revisionDate,profilelconid,puuid
    
    #@kekka_dataから必要なデータを取得
    @summoner_name = @kekka_data["name"]#名前取得
    @icon = @kekka_data["profileIconId"]
    @account_id = @kekka_data["accountId"]#アカウントID取得 検索に使う
    @id = @kekka_data["id"]#id取得 検索に使う
    #idから勝敗やrankを取得
    @rank_kekka_data = rank_serch(@id)
    @rank_kekka_data = @rank_kekka_data[0]

    
    @win = @rank_kekka_data["wins"]
    @lose = @rank_kekka_data["losses"]
    @rank = @rank_kekka_data["tier"]
    #account_idから戦績を取得
    senseki = senseki_serch(@account_id)
    senseki_hairetu = senseki["matches"]
    end
    
    

  end


  private
  def serch(input)#フォームで入力した名前からidなどの情報を取得
    uri = URI.parse URI.encode("https://jp1.api.riotgames.com/lol/summoner/v4/summoners/by-name/#{input}?api_key=#{API_KEY}")
    return_data = Net::HTTP.get(uri)#uriからデータを取得
    #サモナーデータ
    summoner_data = JSON.parse(return_data)#ハッシュに変換して取得
  end

  def senseki_serch(account_id)#account_idから戦績を取得
    senseki_uri = URI.parse URI.encode("https://jp1.api.riotgames.com/lol/match/v4/matchlists/by-account/#{account_id}?api_key=#{API_KEY}")
    senseki_return_data = Net::HTTP.get(senseki_uri)#uriからデータを取得
    senseki_data = JSON.parse(senseki_return_data)
  end

  def rank_serch(id)#idから勝敗やrankをサーチ
    rank_uri = URI.parse URI.encode("https://jp1.api.riotgames.com/lol/league/v4/entries/by-summoner/#{id}?api_key=#{API_KEY}")
    rank_return_data = Net::HTTP.get(rank_uri)
    rank_data = JSON.parse(rank_return_data)
  end

  def hashchamp(senseki_hairetu)
    hairetu = []
    senseki_hairetu.each do |hash|
      hairetu << hash[:champion]
    end
  end




  

  def serch_params#入力フォームで入力されたものを取得
    params.permit(:name)
  end
end
