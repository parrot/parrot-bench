# Copyright (C) 2001-2006, Parrot Foundation.

=head1 NAME

examples/benchmarks/stress3.pasm - GC stress-testing

=head1 SYNOPSIS

    % time ./parrot examples/benchmarks/stress3.pasm

=head1 DESCRIPTION

Creates a lot of PMCs, and then prints out some statistics indicating:

=over 4

=item * the total number of GC runs made

=item * the number of active PMCs

=item * the total number of PMC created

=back

Note that a command-line argument of 1 is supposed to cause the PMCs to
be destroyed before a 2nd loop is run. However, this seems to be broken
at the moment:

    FixedPMCArray: Entry not an integer!

=cut

.pcc_sub :main main:

# How can I get to the command line args?

	#set I10, P5
	#lt I10, 2, noarg
	#set I11, P5[1]
	set I11, 0
        new P10, 'ResizableIntegerArray'
noarg:
	set I0, 100
	new P0, 'ResizablePMCArray'

ol:	local_branch P10, buildarray
	set P0[I0], P1
	dec I0
	if I0, ol

# now check reusage, destroy them depending on I11
	unless I11, no_dest
	new P0, 'Undef'
no_dest:
	set I0, 5000000
	new P3, 'ResizablePMCArray'
l2:
	new P1, 'Integer'
	set P3[0], P1
	dec I0
	if I0, l2

	interpinfo I1, 2
	print "A total of "
	print I1
	print " GC runs were made\n"
	interpinfo I1, 4
	print I1
	print " active PMCs\n"
	interpinfo I1, 6
	print I1
	print " total  PMCs\n"

	end


	# Our inner loop, 10000 times
buildarray:
	set I1, 10000
	new P1, 'ResizablePMCArray'
loop1:	new P9, 'Integer'
	set P9, I1
	set P1[I1], P9
	dec I1
	if I1, loop1
	local_return P10

=head1 SEE ALSO

F<examples/benchmarks/stress.pasm>,
F<examples/benchmarks/stress.pl>,
F<examples/benchmarks/stress1.pasm>,
F<examples/benchmarks/stress1.pl>,
F<examples/benchmarks/stress2.pasm>,
F<examples/benchmarks/stress2.pl>,
F<examples/benchmarks/stress3.pasm>.

=cut

# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:
