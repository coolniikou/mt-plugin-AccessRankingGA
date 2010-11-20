 About the AccessRankingGA plugin for Movable Type and Melody
AccessRankingGA is a plugin for Movable Type and Melody provides accessranking data from Google Analytics(GA) Data.
<<<<<<< HEAD
AccessRankingGA pluginは、Google Analyticsレポート情報からユニークビジター数データを取得し、JSONファイルを出力生成します。jQueryプライベートプラグインをを使って、JSONデータをブログコンテンツ内にリスト表示させます。簡単にアクセスランキングを実装できます。
## Documentation
AccessRankingGAインストール設定までの流れ
=======

AccessRankingGA pluginは、Google Analyticsレポート情報からユニークビジター数データを取得し、JSONファイルを出力生成します。
jQueryオリジナルプラグインを使い、JSONデータをコンテンツ内にリスト表示させます。
簡単にGoogleAnalyticsデータを利用したアクセスランキングを実装できます。
## Documentation
AccessRankingGAインストール・設定までの流れ

>>>>>>> origin/master

 1.プラグインフォルダにAccessRankingGAフォルダを追加。
 2.プラグインページにて必要情報を設定。（ログインアカウント名、パスワード、レポートID、最大表示件数）
 3.新規インデックステンプレート作成（jsonファイル)
 4.ヘッダー部分にjQueryコードを追加。
 5.フッター部分に外部スクリプト（オリジナルプラグイン）読み込みコードを追加。
 6.jQueryスクリプトをjsフォルダ（任意）にアップロード。
 7.新規でウィジットテンプレート作成。
 8.作成したウィジットテンプレートをウィジットセットの任意の位置に追加。
 9.再構築することでアクセスランキングが任意の位置に表示されます。

<<<<<<< HEAD
1.プラグインフォルダにAccessRankingGAフォルダを追加。
2.プラグインページにて必要情報を設定。（ログインアカウント名、パスワード、レポートID、最大表示件数）
3.新規インデックステンプレート作成（jsonファイル)
4.ヘッダー部分にjQueryコードを追加。
5.フッター部分に外部スクリプト読み込みコードを追加。
6.jQueryスクリプトをjsフォルダ（任意）にアップロード。
7.新規でウィジットテンプレート作成。
8.作成したウィジットテンプレートをウィジットセットの任意の位置に追加。
9.再構築することでアクセスランキングが任意の位置に表示されます。

##追加されるテンプレートタグ
	<mt:AccessRankingGA>
**span属性で任意の期間から現在までのデータ取得を指定することができます。**
*デフォルト：属性指定無しは、week(7日間集計)となります。
1ヶ月間の集計からJSONアクセスランキングデータを生成したい場合は、
	<mt:JSONAccessRanking span='month'>
=======

##追加されるテンプレートタグ
     <mt:AccessRankingGA>
**span属性で任意の期間から現在までのデータ取得を指定することができます。**
*デフォルト：属性指定無しは、week(7日間集計)となります。
 1ヶ月間の集計からJSONアクセスランキングデータを生成したい場合は、
     <mt:JSONAccessRanking span='30'>
>>>>>>> origin/master
