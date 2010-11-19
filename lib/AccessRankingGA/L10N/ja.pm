package AccessRankingGA::L10N::ja;

use strict;
use base 'AccessRankingGA::L10N::en_us';
use vars qw( %Lexicon );

%Lexicon = (
	'as_NAME' => 'AccessRankingGA',
	'as_AUTHOR_NAME' => 'cool_ni_ikou',
	'as_DESCRIPTION' => 'Google Analyticsよりユニークビジター数のデータを抽出し、JSONデータを生成します。',
	'as_SET_DES' => 'Google Analytics　ログイン情報が必要です。プロファイルIDはWebサイトのレポート表示の際にURLの中にある数列です。詳細は<a href="http://www.google.com/support/analytics/bin/answer.py?hl=jp&answer=97705" target="_blank">Google ヘルプ › Analytics ヘルプ › 開始方法 › 用語解説 › プロファイル ID：http://www.google.com/support/analytics/bin/answer.py?hl=jp&answer=97705</a>を参照ください。',
	'as_Google_Analytics_Username' => 'Google Analytics<br />ユーザ名',
	'as_Google_Analytics_Password' => 'Google Analytics<br />パスワード',
	'as_Google_Analytics_ProfileID' => 'Google Analytics<br />プロファイル ID',
	'as_Google_Analytics_Maxresult' => 'エントリー最大表示数<br />（訪問数昇順）',
	'Cannot get token, please confirm your settigs of Google Analytics login (as of login account or password).' => 'tokenを取得することができません。プラグイン設定画面にて、Google Analytics login情報（ログイン、パスワード）の設定を確認してください。', 
	'Cannot get contents, please confirm your settigs of Google Analytics login (as of profileID).' => 'アクセス情報を取得することができません。プラグイン設定画面にて、Google Analytics login情報（プロファイルIDもしくは、ログイン、パスワード）の設定を確認してください。',
);

1;
