class UsersController < ApplicationController
  API_KEY = ENV["API_KEY"] #取得したAPIKEY
  require 'net/http'
  require 'uri'
  require 'json'
  def index
  end

  def result
    @input = ActiveSupport::OrderedOptions.new
    @input = serch_params[:name]
    #結果画面で再読み込みすると入力フォームの値がなくなるのでトップへ戻る
    if @input == nil
      redirect_to root_path and return
    end
    
    @kekka_data = serch(@input)#id.accountid,name,summonerLevel,revisionDate,profilelconid,puuid

    #検索したプレイヤーの名前や各idを変数に割り振る。存在しないプレイヤー等、エラーが出た場合は検索ページへ戻る
    if @kekka_data["name"]
      #@kekka_dataから必要なデータを取得
      @summoner_name = @kekka_data["name"]#名前取得
      @icon = @kekka_data["profileIconId"]
      @account_id = @kekka_data["accountId"]#アカウントID取得 検索に使う
      @id = @kekka_data["id"]#id取得 検索に使う
      
      #idから勝敗やrankを取得
      @rank_kekka_data = rank_serch(@id)
      @rank_kekka_data = @rank_kekka_data[0]

      else
      flash[:nameerror] = '名前を再入力してください'
      redirect_to root_path and return 
      
    end

    #勝敗とランクを持ってくる無しなら０を入れる
    if @rank_kekka_data == nil
      @win = 0
      @lose = 0
      @rank = "UNRANKED"
      
      else
      @win = @rank_kekka_data["wins"]
      @lose = @rank_kekka_data["losses"]
      @rank = @rank_kekka_data["tier"]
      #account_idから戦績を取得
      senseki = senseki_serch(@account_id)
      senseki_hairetu = senseki["matches"]
      @senseki_hairetu = senseki_hairetu[0]
      @last_champion = @senseki_hairetu["champion"]
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
