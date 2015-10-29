package contigfilter::contigfilterImpl;
use strict;
use Bio::KBase::Exceptions;
# Use Semantic Versioning (2.0.0-rc.1)
# http://semver.org 
our $VERSION = "0.1.0";

=head1 NAME

contigfilter

=head1 DESCRIPTION

A KBase module: contigfilter
This sample module contains one small method - count_contigs.

=cut

#BEGIN_HEADER
use Bio::KBase::AuthToken;
use Bio::KBase::workspace::Client;
use Config::IniFiles;
use Data::Dumper;
#END_HEADER

sub new
{
    my($class, @args) = @_;
    my $self = {
    };
    bless $self, $class;
    #BEGIN_CONSTRUCTOR
    
    my $config_file = $ENV{ KB_DEPLOYMENT_CONFIG };
    my $cfg = Config::IniFiles->new(-file=>$config_file);
    my $wsInstance = $cfg->val('contigfilter','workspace-url');
    die "no workspace-url defined" unless $wsInstance;
    
    $self->{'workspace-url'} = $wsInstance;
    
    #END_CONSTRUCTOR

    if ($self->can('_init_instance'))
    {
	$self->_init_instance();
    }
    return $self;
}

=head1 METHODS



=head2 count_contigs

  $return = $obj->count_contigs($workspace_name, $contigset_id)

=over 4

=item Parameter and return types

=begin html

<pre>
$workspace_name is a contigfilter.workspace_name
$contigset_id is a contigfilter.contigset_id
$return is a contigfilter.CountContigsResults
workspace_name is a string
contigset_id is a string
CountContigsResults is a reference to a hash where the following keys are defined:
	contig_count has a value which is an int

</pre>

=end html

=begin text

$workspace_name is a contigfilter.workspace_name
$contigset_id is a contigfilter.contigset_id
$return is a contigfilter.CountContigsResults
workspace_name is a string
contigset_id is a string
CountContigsResults is a reference to a hash where the following keys are defined:
	contig_count has a value which is an int


=end text



=item Description

Count contigs in a ContigSet
contigset_id - the ContigSet to count.

=back

=cut

sub count_contigs
{
    my $self = shift;
    my($workspace_name, $contigset_id) = @_;

    my @_bad_arguments;
    (!ref($workspace_name)) or push(@_bad_arguments, "Invalid type for argument \"workspace_name\" (value was \"$workspace_name\")");
    (!ref($contigset_id)) or push(@_bad_arguments, "Invalid type for argument \"contigset_id\" (value was \"$contigset_id\")");
    if (@_bad_arguments) {
	my $msg = "Invalid arguments passed to count_contigs:\n" . join("", map { "\t$_\n" } @_bad_arguments);
	Bio::KBase::Exceptions::ArgumentValidationError->throw(error => $msg,
							       method_name => 'count_contigs');
    }

    my $ctx = $contigfilter::contigfilterServer::CallContext;
    my($return);
    #BEGIN count_contigs
    
    my $token=$ctx->token;
    my $wshandle=Bio::KBase::workspace::Client->new($self->{'workspace-url'},token=>$token);
    my $wsobj=$wshandle->get_objects([{workspace=>$workspace_name,name=>$contigset_id}]);
    my $contigcount=scalar (@{$wsobj->[0]{data}{contigs}});

    $return = { 'contig_count' => $contigcount };
    
    #END count_contigs
    my @_bad_returns;
    (ref($return) eq 'HASH') or push(@_bad_returns, "Invalid type for return variable \"return\" (value was \"$return\")");
    if (@_bad_returns) {
	my $msg = "Invalid returns passed to count_contigs:\n" . join("", map { "\t$_\n" } @_bad_returns);
	Bio::KBase::Exceptions::ArgumentValidationError->throw(error => $msg,
							       method_name => 'count_contigs');
    }
    return($return);
}




=head2 version 

  $return = $obj->version()

=over 4

=item Parameter and return types

=begin html

<pre>
$return is a string
</pre>

=end html

=begin text

$return is a string

=end text

=item Description

Return the module version. This is a Semantic Versioning number.

=back

=cut

sub version {
    return $VERSION;
}

=head1 TYPES



=head2 contigset_id

=over 4



=item Description

A string representing a ContigSet id.


=item Definition

=begin html

<pre>
a string
</pre>

=end html

=begin text

a string

=end text

=back



=head2 workspace_name

=over 4



=item Description

A string representing a workspace name.


=item Definition

=begin html

<pre>
a string
</pre>

=end html

=begin text

a string

=end text

=back



=head2 CountContigsResults

=over 4



=item Definition

=begin html

<pre>
a reference to a hash where the following keys are defined:
contig_count has a value which is an int

</pre>

=end html

=begin text

a reference to a hash where the following keys are defined:
contig_count has a value which is an int


=end text

=back



=cut

1;
