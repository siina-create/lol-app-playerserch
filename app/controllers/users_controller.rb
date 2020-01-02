class UsersController < ApplicationController
API_KEY = ENV["API_KEY"] #取得したAPIKEY
  require 'net/http'
  require 'uri'
  require 'json'
  def index
  end

  def result
    #フォームで入れた名前
    @input = serch_params[:name]
    #結果画面で再読み込みすると入力フォームの値がなくなるのでトップへ戻る
    if @input == nil
      redirect_to root_path and return
    end
    #id.accountid,name,summonerLevel,revisionDate,profilelconid,puuid
    @kekka_data = serch(@input)

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
      flash[:nameerror] = '試合データがありません'
      redirect_to root_path and return 
      @win = 0
      @lose = 0
      @rank = "UNRANKED"
      
      else
      @win = @rank_kekka_data["wins"]
      @lose = @rank_kekka_data["losses"]
      @rank = @rank_kekka_data["tier"]

      #account_idから戦績を取得
      @senseki = senseki_serch(@account_id)
      #最後の試合のgameidを取得
      lastgameid = @senseki["matches"][0]["gameId"]
      @lastgamedata = gameget(lastgameid)
      @winlose =@lastgamedata["teams"][0]["win"]
      participantIdentities = @lastgamedata["participantIdentities"]
      #@nameicon = teamplayerget(participantIdentities)
      @playerdata = teamplayerget(@lastgamedata)
      #["participantIdentities"]#[0]["player"]["summonerName"]

      #最後使ったチャンピオンのkeyを取得
      last_champion = @senseki["matches"][0]["champion"]
      
      #全てのチャンピオンの全てのデータ
      @all = dataget()
      data = @all["data"]
      #keyとチャンピオン名の対応リスト
      keydata = keyname(data)
      #last_championのkeyを対応する名前にする
      @last_champion_name = keydata["#{last_champion}"] 
      @keydata = keydata
    end
    
    
  end
    

  #APIで特定のデータを持ってくる
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

  def gameget(lastgameid)
    game_uri = URI.parse URI.encode("https://jp1.api.riotgames.com/lol/match/v4/matches/#{lastgameid}?api_key=#{API_KEY}")
    game_return_data = Net::HTTP.get(game_uri)
    game_data = JSON.parse(game_return_data)
  end

  def teamplayerget(lastgamedata)
    i=0
    hash = {}
    10.times do
      hash["summonerName#{i}"] = lastgamedata["participantIdentities"][i]["player"]["summonerName"]
      hash["plofileicon#{i}"] = lastgamedata["participantIdentities"][i]["player"]["profileIcon"]
      hash["teamId#{i}"] = lastgamedata["participants"][i]["teamId"]
      hash["participantId#{i}"] = lastgamedata["participants"][i]["participantId"]
      hash["championId#{i}"] = lastgamedata["participants"][i]["championId"]
      i+=1
    end
    return hash
  end
    
  #datadragonにアクセス
  def dataget
    dragon_uri = URI.parse URI.encode("http://ddragon.leagueoflegends.com/cdn/9.3.1/data/ja_JP/champion.json")
    return_data = Net::HTTP.get(dragon_uri)
    rank_data = JSON.parse(return_data)
  end

  #keyとチャンピオン名を関連付けるハッシュをつくる
  def keyname(data)
    hash = {}
    data.each {|key,value|
    num = value["key"]
    hash[num] = value ["id"]}
    return hash
    
  end
  

  def serch_params#入力フォームで入力されたものを取得
    params.permit(:name)
  end
end
