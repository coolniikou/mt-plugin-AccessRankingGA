package AccessRankingGA::Plugin;

use strict;
use warnings;
use base qw(MT::Plugin);
use MT;
use MT::Util qw( start_end_day epoch2ts format_ts trim );
use XML::Simple;
use JSON;
use Data::Dumper;
sub doLog {
    my ($msg) = @_; 
    return unless defined($msg);

    use MT::Log;
    my $log = MT::Log->new;
    $log->message($msg) ;
    $log->save or die $log->errstr;
}

sub _hdlr_analytic_tags {
	my ($ctx, $args) = @_;
	my $plugin = MT->component('AccessRankingGA');
	my $blog =  $ctx->stash('blog') or return '';
	my $blog_id =  $ctx->stash('blog_id');
	my $span = $args->{span};
	my $user = $plugin->get_config_value('GA_username', "blog:" . $blog_id);
	my $pass = $plugin->get_config_value('GA_password', "blog:" . $blog_id);
	my $profileid = $plugin->get_config_value('GA_profile_id', "blog:" . $blog_id);
	my $maxresult = $plugin->get_config_value('GA_maxresult', "blog:" . $blog_id);
	my $exclude = trim($plugin->get_config_value('GA_exclude_path', "blog:" . $blog_id));
	my @excludes = ($exclude =~ /(\S+)/g);
	foreach my $exc (@excludes) {
		doLog($exc);
	}
	my $token = &get_token($user, $pass);
	
	my $now = time;
	my $today = start_end_day(epoch2ts($blog, $now));
	   $today = format_ts('%Y-%m-%d', $today, $blog);
	my $week_ago = start_end_day(epoch2ts($blog, $now - (60 * 60 * 24 * 7)));
	   $week_ago = format_ts('%Y-%m-%d', $week_ago, $blog);
	my $mod_ago = start_end_day(epoch2ts($blog, $now - (60 * 60 * 24 * $span)));
	   $mod_ago = format_ts('%Y-%m-%d', $mod_ago, $blog);
	my $data;   
	if ($span) {
		$data = &get_data($token, $profileid, $mod_ago, $today, $maxresult);
	} else {
		$data = &get_data($token, $profileid, $week_ago, $today, $maxresult);
	}
	my $parser = XML::Simple->new(Forcearray => 1);
	my $xml = $parser->XMLin($data);
	my $json = to_json($xml->{entry});

	#my $enc = MT::I18N::guess_encoding($json);  ## deal with your situation that character encoding
	#my $json = MT::I18N::encode_text($json, $enc, 'utf-8');

	return $json;
}

sub get_token{
	my ($user, $pass) = @_;
	my $plugin = MT->component('AccessRankingGA');
	my $token;
	my $ua = MT->new_ua({ agent => join("/", $plugin->name, $plugin->version) });
	my $token_url = 'https://www.google.com/accounts/ClientLogin';
	my $tk_con = {
		accountType => 'GOOGLE',
		Email => $user,
		Passwd => $pass,
		service => 'analytics',
		source => 'companyName-applicationName-versionID',
	};
	my $res = $ua->post($token_url, Content => $tk_con);
	if ($res->is_success) {
		if ( $res->content =~ /Auth\=(.+)/i ) {
			return $1;
 		}
	} else {
		MT->log({
			message => $plugin->translate('Cannot get token, please confirm your settigs of Google Analytics login (as of login account or password).'). $res->status_line,
			class => 'system',
			level => MT::Log::ERROR(), 
		});
		die $plugin->translate('Cannot get token, please confirm your settigs of Google Analytics login (as of login account or password).'). $res->status_line;
	}
}

sub get_data{
	my ($token, $profileid, $start, $end, $maxresult) = @_;
	my $plugin = MT->component('AccessRankingGA');
	my $ua = MT->new_ua({ agent => join("/", $plugin->name, $plugin->version) });
	my $url = "https://www.google.com/analytics/feeds/data?"
		."ids=ga%3A$profileid&"
		."dimensions=ga%3ApagePath%2Cga%3ApageTitle&"
		."metrics=ga%3AuniquePageviews&"
		."sort=-ga%3AuniquePageviews&"
		."filters=ga%3ApagePath%3D~/weblog/photoshop/&" #;gd%3ApagePath!%3D%2Fweblog%2Fcss%2F&" ## add filter option, if would like to exclude TOP Page's data 
		."start-date=$start&"
		."end-date=$end&"
		."max-results=$maxresult";
	my @headers = (Authorization => "GoogleLogin Auth=$token");
	my $res = $ua->get($url, @headers);
	if ($res->is_success) {
		return $res->content;
	} else {
		MT->log({
			message => $plugin->translate('Cannot get contents, please confirm your settigs of Google Analytics login (as of profileID).'). $res->status_line,
			class => 'system',
			level => MT::Log::ERROR(),
		});
		die $plugin->translate('Cannot get contents, please confirm your settigs of Google Analytics login (as of profileID).'). $res->status_line;
	}
}

1;
