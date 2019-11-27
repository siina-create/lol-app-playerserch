API_KEY = 'RGAPI-cd4bee2c-07b7-4051-a014-122bdcbb8bcd' #取得したAPIKEY
#region = "jp"


uri = URI.parse URI.encode("https://jp1.api.riotgames.com/lol/summoner/v4/summoners/by-name/#{@input}?api_key=#{API_KEY}")
return_data = Net::HTTP.get(uri)#uriからデータを取得

  #サモナーデータ
summoner_data = JSON.parse(return_data)#ハッシュに変換して取得


#サモナーネーム取り出し
#summoner_name = summoner_data["name"]
