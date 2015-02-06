requires 'perl', '5.008001';
requires 'Moo';
requires 'File::Find::Rule';
requires 'LWP::UserAgent';
requires 'Path::Tiny';
requires 'Text::Diff';

on 'test' => sub {
    requires 'Test::More', '0.98';
};

