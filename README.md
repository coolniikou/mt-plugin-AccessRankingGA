#About the AccessRankingGA plugin for Movable Type and Melody
AccessRankingGA is a plugin for Movable Type and Melody provides accessranking data from Google Analytics(GA) Data.  

AccessRankingGA プラグインは、Google Analyticsレポート情報からユニークビジター数データを取得し、JSONファイルを出力生成します。 
jQueryオリジナルプラグインを使い、JSONデータをコンテンツ内にリスト表示させます。  
簡単にGoogleAnalyticsデータを利用したアクセスランキングをMovable Typeに実装できrるようになります。  

##AccessRankingGAインストール・設定までの流れ    
 1. **インストール**    
	* プラグインフォルダ($MT_HOME/plugin)にAccessRankingGAプラグインフォルダを追加。    
	* jQueryスクリプトをjsフォルダ（任意）にアップロード。[mt_static/js/jquery.rankingtag.js]  
	* cssフォルダ（任意）にアップロード。[mt_static/css/rankinglist_widget.css]  
 2. **プラグイン設定**    
	* プラグインページにて必要情報を設定。（ログインアカウント名、パスワード、レポートID、最大表示件数）   
 3. **デザインテンプレート編集・作成**   
	* 新規インデックステンプレート作成 [下記参照：インデックステンプレート作成]    
	* ヘッダーテンプレート編集。ヘッダー部分にjQueryコードを追加。 [下記参照: jQueryコード設置]    
	* ヘッダーテンプレート編集。ヘッダー部分にcssを追加。 [下記参照: jQueryコード設置]    
	* フッターテンプレート編集。フッター部分に外部スクリプト（オリジナルプラグイン）読み込みコードを追加。    [下記参照: jQueryコード設置]  
	* 新規でウィジットテンプレート作成。   
	* 作成したウィジットテンプレートをウィジットセットの任意の位置に追加。   
 4. **再構築**    
	* インデックステンプレートを再構築することでアクセスランキングが任意の位置に表示されます。     
 5. **定期実行スケジュール設定**    
	* 定期でのスケジュールタスク実行(\*1) を設定することで最新データからアクセスランキング表示が可能となります。  

##追加されるテンプレートタグ
     <mt:AccessRankingGA>
###span モディファイア
**span属性で任意の期間から現在までのデータ取得を指定することができます。**   
レポート取得期間をspanモディファイアで任意の期間を指定することができます。 
インデックステンプレートに新規ファイル作成し、その中にテンプレートタグを記述することで任意の期間のGoogle Analytics レポートJSONデータが生成されることになります。    
3パターンの期間指定したインデックスファイルを作成することで(昨日、今週、月間)と期間別でのアクセスランキング表示も可能となります。（jQueryランキング表示プラグインもタブ形式で数パターンのアクセスランキングを表示できます。）  


*デフォルト：属性指定無しは、week(7日間集計)となります。*   
 1週間集計でのJSONアクセスランキングデータを生成したい場合は  

	<mt:AccessRankingGA>

 1ヶ月間集計でのJSONアクセスランキングデータを生成したい場合は  

	<mt:AccessRankingGA span="30">

 昨日(1日)集計でのJSONアクセスランキングデータを生成したい場合は  

	<mt:AccessRankingGA span="1">

##プラグイン設定    
AccessRankingGAでは、GoogleAnalyticsレポートからデータを取り出す際に詳細設定することができるようになっています。　        
**トップページをランキング表示から除外したい場合**     
「トップページ除外」にチェックをつけてください。     
**特定フォルダ、ファイル（アドレス）を除外したい場合**     
特定のフォルダもしくは、ページ（アドレス）を除外したい場合は、フォルダ名（パス名）、ファイル名を「除外パスリスト」に入力ください。     
**ワードマッチするパス、ファイルについては除外**したデータを出力できるようになります。       
例：ページ分割を実装しているブログ記事      
一つのエントリーで長文対応で複数ページにて分割している場合など、アドレス末尾が(
-2.html もしくは -3.htmlなど)同ページがアクセスランキングにて表示されてします可能性が考えられます。
「除外パスリスト」に　-2.html または、-3.html　と入力することで除外したデータを表示することできるようになります。


##インデックステンプレート作成
JSONファイル出力用に新規インデックステンプレートを作成します。  
出力ファイル名を期間毎にわかりやすく命名することを推奨します。  
以下を参考にインデックスファイル新規作成ください。  

* 昨日（1日）集計でのJSONアクセスランキングファイル作成  
	* テンプレート名: 昨日アクセスランキング
	* テンプレート記述: `	<mt:AccessRankingGA span="1">	`
	* 出力名：accssranking_dayago.json  
	* 公開： 公開キュー経由    

* 1週間集計でのJSONアクセスランキング作成  
	* テンプレート名: 週間アクセスランキング  
	* テンプレート記述: `	<mt:AccessRankingGA>	`
	* 出力名：accssranking_week.json  
	* 公開： 公開キュー経由    

* 月間集計でのJSONアクセスランキング作成  
	* テンプレート名: 月間アクセスランキング  
	* テンプレート記述: `	<mt:AccessRankingGA span="30">		`
	* 出力名：accssranking_month.json  
	* 公開： 公開キュー経由    
  
上記ファイル作成後にインデックスファイルの再構築を実行後に公開ファイル名にアクセスし、実際にGoogleAnalyticsデータが取得出来ているか確認してください。
データ取得出来ていない場合は、システムログの確認とプラグイン設定項目を再確認してください。

##jQueryプラグインコード設置  
MTシステム側でGoogleAnalyticsレポートからデータを取得し、JSONファイルを生成します。生成されたJSONファイルをjQueryプラグインを使って読み込み、ブログ（HTMLページ）上に表示させます。  
jQueryプラグイン設置は以下の手順で行ってください。    
1. ヘッダ（テンプレートモジュール）にjQuery読み込み用のコードを追加します。以下のコードを参考に。  
最新のjQuery libraryを読み込むように [Google Libraries API * Developer's Guide * Google Libraries API * Google Code](http://code.google.com/intl/ja/apis/libraries/devguide.html#jquery) を参照し内容を適宜変更してください。 
(2011/5/26日現在)  

    <script type="text/javascript" src="http://www.google.com/jsapi"></script>
    <script type="text/javascript">
        google.load("jquery", "1.6.1");
    </script>     

2.ヘッダーもしくは、フッター（テンプレートモジュール）</body>後に以下のコードを外部スクリプトとして読み込むように設定します。  

    <script type="text/javascript" src="http://your-domain.com/js-folder/jquery.rankingtab.js"></script>     
	$(document).ready( function() {
			$('div.ranking').rankingtab({
				baseurl: 'http://your-domain.com blog-index/accessranking_',
				trunc: 60
			});
 	});

jQuery rankingtab プラグイン設定    

 * baseurl: jsonファイルが生成されるアドレスを指定します。    
 (注: baseurlに設定するurlとインデックステンプレートに新規作成したjsonファイルの出力urlが一致している必要があります。)
 * trunk: 表示するタイトルを任意の文字数で区切ります。    

##ウィジット作成例
下記のコードを参考に新規にウィジットテンプレート（アクセスランキング表示用）を作成します。作成後は、ウィジットセットに追加します。

    <div class="widget-ranking-entries widget-archives widget">
    	<h3 class="widget-header">人気アクセスランキング</h3>
    		<div class="ranking">
        		<ul class="rktab">
                	<li><a href="#day_ago"><em>昨日</em></a></ll>
                	<li><a href="#week"><em>今週</em></a></li>
                	<li><a href="#month"><em>今月</em></a></ll>
        		</ul>
        	<div class="widget-content accessranking">
        	</div>
			</div>
	</div>

##ウィジットデザイン整形(CSS)    
インデックステンプレート編集ファイル名スタイルシートに以下のコードを追加することでアクセスランキングウィジットのデザインが整形されます。　　　　　

	/* ranking widget  StyleCatcher imports */
	@import url(/your-utility-css-folder/rankinglist_widget.css);    

		
***
			

####\*1: スケジュールタスクの実行
* cron等で定期で$MT_HOME/tools/run_periodic_tasksを実行する(linux or Unix)  
* タスク・スケジューラで$MT_HOME/tools/run_periodic_tasksを実行する(windows)  
* ログフィードを定期的に取得するようにする(	フィードリーダ等で定期的に読み込むように設定する)  
* XML-RPCのAPI、mt.runPeriodicTasksを定期的に利用する  

####　更新履歴
 * 2011/6/19 README編集 パージョン0.4リリース
 * 2011/6/18 README編集。バージョン別内部文字エンコード対応。
 * 2011/5/25 READMEファイル修正、文字エンコード部分修正。
