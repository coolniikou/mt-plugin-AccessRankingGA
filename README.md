# About the AccessRankingGA plugin for Movable Type and Melody
AccessRankingGA is a plugin for Movable Type and Melody provides accessranking data from Google Analytics(GA) Data.
AccessRankingGA pluginは、Google Analyticsレポート情報からユニークビジター数データを取得し、JSONファイルを出力生成します。
jQueryオリジナルプラグインを使い、JSONデータをコンテンツ内にリスト表示させます。
簡単にGoogleAnalyticsデータを利用したアクセスランキングを実装できます。
## Documentation
AccessRankingGAインストール・設定までの流れ


 1.プラグインフォルダにAccessRankingGAフォルダを追加。
 2.プラグインページにて必要情報を設定。（ログインアカウント名、パスワード、レポートID、最大表示件数）
 3.新規インデックステンプレート作成（jsonファイル)
 4.ヘッダー部分にjQueryコードを追加。
 5.フッター部分に外部スクリプト（オリジナルプラグイン）読み込みコードを追加。
 6.jQueryスクリプトをjsフォルダ（任意）にアップロード。
 7.新規でウィジットテンプレート作成。
 8.作成したウィジットテンプレートをウィジットセットの任意の位置に追加。
 9.再構築することでアクセスランキングが任意の位置に表示されます。


##追加されるテンプレートタグ
     <mt:AccessRankingGA>
**span属性で任意の期間から現在までのデータ取得を指定することができます。**
*デフォルト：属性指定無しは、week(7日間集計)となります。
 1ヶ月間の集計からJSONアクセスランキングデータを生成したい場合は、
     <mt:JSONAccessRanking span='30'>



##$BDI2C$5$l$k%F%s%W%l!<%H%?%0(B
	<mt:AccessRankingGA>
**span$BB0@-$GG$0U$N4|4V$+$i8=:_$^$G$N%G!<%?<hF@$r;XDj$9$k$3$H$,$G$-$^$9!#(B**
*$B%G%U%)%k%H!'B0@-;XDjL5$7$O!"(Bweek(7$BF|4V=87W(B)$B$H$J$j$^$9!#(B
1$B%v7n4V$N=87W$+$i(BJSON$B%"%/%;%9%i%s%-%s%0%G!<%?$r@8@.$7$?$$>l9g$O!"(B
	<mt:JSONAccessRanking span='month'>
