# Copyright (C) 2001-2006, Parrot Foundation.
# $Id$

=head1 NAME

examples/benchmarks/stress1.pasm - GC stress-testing

=head1 SYNOPSIS

    % time ./parrot examples/benchmarks/stress1.pasm

=head1 DESCRIPTION

Creates 500 arrays with 20000 elements each. Prints out the number of
GC runs made.

=cut

# Our master loop, I20 times
	set I20, 10
	time N0
        new P10, 'ResizableIntegerArray'
mloop:

	set I0, 10
	new P0, 'ResizablePMCArray'

ol:	local_branch P10,  buildarray
	set P0[I0], P1
	dec I0
	if I0, ol

	set I0, 20
	new P2, 'ResizablePMCArray'

ol1:	local_branch P10,  buildarray
	set P2[I0], P1
	dec I0
	if I0, ol1

	set I0, 20
	new P3, 'ResizablePMCArray'

ol2:	local_branch P10,  buildarray
	set P3[I0], P1
	dec I0
	if I0, ol2

	time N1
	sub N2, N1, N0
	set N0, N1
	print N2

	interpinfo I1, 2
	print "\nA total of "
	print I1
	print " GC runs were made\n"

	dec I20
	if I20, mloop

	end


	# Our inner loop, 20000 times
buildarray:
	set I1, 20000
	new P1, 'ResizablePMCArray'
	set P1, I1	# set length => fixed sized array
loop1:	new P9, 'Integer'
	set P9, I1
	set P1[I1], P9
	dec I1
	if I1, loop1
	local_return P10

=head1 SEE ALSO

F<examples/benchmarks/stress.pasm>,
F<examples/benchmarks/stress.pl>,
F<examples/benchmarks/stress1.pl>,
F<examples/benchmarks/stress2.pl>,
F<examples/benchmarks/stress3.pasm>.

=cut

# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:
