use strict;
use warnings;
use utf8;
use File::Spec;
use File::Basename;
use lib File::Spec->catdir(dirname(__FILE__), '../lib');
use Crawldiff;
use LWP::UserAgent;

my $chatname = '';
my $tacochan_url = 'http://localhost:4969';

my $url = shift or die "Usage: $0 URL\n";

my $ua = LWP::UserAgent->new();

my $crawler = Crawldiff->new();
$crawler->crawl($url);

my $diff = $crawler->diff_last($url);
if ($diff) {
    notify('diff:');
    notify($diff);
}

sub notify {
    my ($message) = @_;
    $message =~ s/\A(.{500}).+/$1.../ms;
    $ua->post("$tacochan_url/send",
        Content => {
            chat    => $chatname,
            message => $message,
        },
    );
}

