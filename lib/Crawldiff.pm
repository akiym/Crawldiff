package Crawldiff;
use 5.008001;
use strict;
use warnings;
use Moo;
use File::Basename;
use File::Find::Rule;
use File::stat;
use LWP::UserAgent;
use Path::Tiny;
use Text::Diff ();
use Time::Piece;

our $VERSION = "0.01";

has agent => (
    is => 'ro',
    default => sub {
        my $ua = LWP::UserAgent->new();
        return $ua;
    },
);

has log_dir => (
    is => 'rw',
    default => sub { 'log' },
);

sub crawl {
    my ($self, $url) = @_;
    my $t = localtime();
    my $uri = URI->new($url);
    my $filename = basename($url);
    $filename =~ s/\.html?$//;
    $filename = sprintf '%s-%s-%s.html', $uri->host, $filename, $t->strftime('%Y%m%d-%H%M%S');
    my $path = path($self->log_dir, $filename);
    $self->agent->get($url,
        ':content_file' => $path->stringify,
    );
}

sub diff {
    my ($self, $file1, $file2) = @_;
    my $diff = Text::Diff::diff($file1, $file2);
    return $diff;
}

sub diff_last {
    my ($self, $url) = @_;

    my $uri = URI->new($url);

    my @files = sort { stat($b)->mtime <=> stat($a)->mtime }
        File::Find::Rule->file()
            ->name($uri->host . '-*.html')
            ->in($self->log_dir);

    return if @files < 2;

    my ($file1, $file2) = @files;
    return $self->diff($file1, $file2);
}

1;
__END__

=encoding utf-8

=head1 NAME

Crawldiff - Crawl and diff for you

=head1 SYNOPSIS

    use Crawldiff;

=head1 DESCRIPTION

Crawldiff is ...

=head1 LICENSE

Copyright (C) Takumi Akiyama.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Takumi Akiyama E<lt>t.akiym@gmail.comE<gt>

=cut
