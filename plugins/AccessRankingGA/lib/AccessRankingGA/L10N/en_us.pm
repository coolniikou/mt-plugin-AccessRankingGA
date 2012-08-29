package AccessRankingGA::L10N::en_us;

use strict;
use base 'AccessRankingGA::L10N';
use vars qw( %Lexicon );
%Lexicon = (
	'as_NAME' => 'AccessRankingGA',
	'as_AUTHOR_NAME' => 'cool_ni_ikou',
	'as_DESCRIPTION' => 'AcessRankingGA makes it easy to publish JSON Data of Access Ranking from Google Analytics, thus you can easily put AccessRanking List based on GADATA into contents.  ',
	'as_SET_DES' => 'require initial setup your Google analytics Profile ID.',
	'as_SET_TITLE' => 'Setting Google Analytics Detail',
	'as_ASTERISK' => '* mark required configuration',
	'as_GA_Username' => '* Google Analytics<br />username',
	'as_GA_Password' => '* Google Analytics<br />password',
	'as_GA_ProfileID' => '* Google Analytics<br />ProfileID',
	'as_DATA_SET_DETAIL' => 'Setting GADATA Preview Detail',
	'as_GA_Maxresult' => 'Maximum number of listing entries',
	'as_token_error' => 'Cannot get token, please confirm your settigs of Google Analytics login (as of login account or password).', 
	'as_contents_error' => 'Cannot get contents, please confirm your settigs of Google Analytics login (as of profileID).',
);

1;
