package AccessRankingGA::L10N::ja;

use strict;
use base 'AccessRankingGA::L10N::en_us';
use vars qw( %Lexicon );

%Lexicon = (
	'as_NAME' => 'AccessRankingGA',
	'as_AUTHOR_NAME' => 'cool_ni_ikou',
	'as_DESCRIPTION' => 'Google Analyticsよりユニークビジター数のデータを抽出し、JSONデータを生成します。',
	'as_SET_DES' => 'Google Analytics　ログイン情報が必要です。プロファイルIDはWebサイトのレポート表示の際にURLの中にある数列です。詳細は<a href="http://www.google.com/support/analytics/bin/answer.py?hl=jp&answer=97705" target="_blank">Google ヘルプ › Analytics ヘルプ › 開始方法 › 用語解説 › プロファイル ID：http://www.google.com/support/analytics/bin/answer.py?hl=jp&answer=97705</a>を参照ください。',
	'as_SET_TITLE' => 'Google Analytics 詳細設定',
	'as_ASTERISK' => '* 印 必須項目',
	'as_GA_Username' => '* Google Analytics<br />ユーザ名',
	'as_GA_Password' => '* Google Analytics<br />パスワード',
	'as_GA_ProfileID' => '* Google Analytics<br />プロファイル ID',
	'as_GA_Maxresult' => 'エントリー最大表示数<br />（訪問数昇順）',
	'as_GA_ExcludeTOP' => 'トップページ除外',
	'as_GA_ExcludeTOP_Hint' => 'もしトップページデータを除外したい場合はチェックしてください。',
	'as_GA_Exclude_Path' => '除外パスリスト',
	'as_GA_Exclude_Path_Hint' => '除外したいページパスを入力してください。例）もしphotoshopカテゴリ（パス名）の場合、"photoshop"入力。 ',
	'as_token_error' => 'Google Analytics DATA API認証が取得できませんでした。プラグイン設定画面にて詳細設定項目の内容を確認ください。', 
	'as_contents_error' => 'Google Analytics DATA APIからデータ取得できませんでした。詳細設定項目の内容を確認してください。',
);

1;
