use contigfilter::contigfilterImpl;

use contigfilter::contigfilterServer;
use Plack::Middleware::CrossOrigin;



my @dispatch;

{
    my $obj = contigfilter::contigfilterImpl->new;
    push(@dispatch, 'contigfilter' => $obj);
}


my $server = contigfilter::contigfilterServer->new(instance_dispatch => { @dispatch },
				allow_get => 0,
			       );

my $handler = sub { $server->handle_input(@_) };

$handler = Plack::Middleware::CrossOrigin->wrap( $handler, origins => "*", headers => "*");
