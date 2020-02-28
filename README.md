# README

## 概要
このアプリはゲームleague of legendのプレイヤー検索アプリです  
プレイヤー名からプロフィール、戦績、一番最近の試合結果探し、表示させます
## 作成した目的
APIを使用してアプリ作ってみたかったこと、大好きなleague of legendのコミュニティにプラスになることをしたかったという思いがあります  
また、日本人でleague of legendのアプリを作っている方が少なく、作成した経験や苦労を共有することでアプリ開発の敷居を下げたいと感じたためです
## 使用した言語
ruby(APIを使ってデータの取得)  
haml、css（トップ画面、結果画面の見た目）
## 使い方
1.https://poppyhammer.herokuapp.com にアクセスしてください  
2.トップ画面が表示されるので中央の検索欄にleague of legenのアカウント名を入力して「検索する」を押してください
例として isurugiと入力してみてください（日本のトッププレイヤーです）
<img width="1300" alt="スクリーンショット 2020-02-27 12 50 01" src="https://user-images.githubusercontent.com/57381866/75410660-f24b2e80-595f-11ea-9b37-fe3a4b8fae63.png">

3.戦績やプロフィールが表示されます
<img width="1409" alt="スクリーンショット 2020-02-28 15 13 09" src="https://user-images.githubusercontent.com/57381866/75515676-efbf0680-5a3d-11ea-80ca-047c22dff069.png">

①名前と一番最近の試合の勝敗です
②設定しているプロフィールアイコンです
③プレイヤーのランキングです　どのようなランクがあるかはランキングのマークにカーソルを合わせて確認して見てください
④プレイヤーの戦績です
⑤プレイヤーが最後に使ったキャラクターの名前とそのアイコンです
⑥最後の試合のメンバーリストです
  キャラクターアイコンと名前、プレイヤーの名前がわかります
## 検索時のエラーについて
検索時に次のエラーが表示された場合、以下のことを確認してください  
・名前を再入力してください  
存在しないアカウント名です 名前を確認してください  
・試合データがありません  
一度も試合をしていないアカウントです ランクマッチのみカウントされるため、フリーマッチのみで試合をしているアカウントもこのエラーが発生します  
ランクマッチを行った後、もう一度確認してください
・プロフィールアイコンやキャラクターアイコンが標示されない
新しいキャラクターやアイコンは標示されない場合があります 更新をお待ちください

