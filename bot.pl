#! /usr/bin/perl</code>
 
use strict;
use warnings;
use Net::XMPP;

my $username  = "";
my $password  = "";
my $resource  = "";
my $recipient = "";
my $message   = "";

my $conn   = Net::XMPP::Client->new;

$conn->SetCallBacks(receive=>\&messageUser);

$conn->SetMessageCallBacks(
	normal=>\&messageUser,
	chat=>\&messageUser);

my $status = $conn->Connect(
    hostname => 'talk.google.com',
    port => 5222,
    componentname => 'gmail.com',
    connectiontype => 'tcpip',
    tls => 1,
);
die "Connection failed: $!" unless defined $status;

my ($res,$msg) = $conn->AuthSend(
    username => $username,
    password => $password,
    resource => $resource, 
);
die "Auth failed ",
    defined $msg ? $msg : '',
    " $!"
    unless defined $res and $res eq 'ok';

$conn->MessageSend(
	    to => $recipient,
	    resource => $resource,
	    subject => 'message via ' . $resource,
	    type => 'chat',
	    body => $message,
	);

$conn->PresenceSend(show=>"available");

sub messageUser {
	$conn->MessageSend(
	    to => $recipient,
	    resource => $resource,
	    subject => 'message via ' . $resource,
	    type => 'chat',
	    body => 'Hello',
	);
}