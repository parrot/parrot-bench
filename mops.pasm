# Copyright (C) 2001-2005, Parrot Foundation.

=head1 NAME

examples/benchmarks/mops.pasm - Calculate a benchmark for Integer PMCs

=head1 SYNOPSIS

    % ./parrot examples/benchmarks/mops.pasm

=head1 DESCRIPTION

Calculates a value for M ops/s (million operations per second) using
C<Integer> PMCs.

=cut

        new    P1, 'Integer'
        new    P2, 'Integer'
        new    P3, 'Integer'
        new    P4, 'Integer'
        new    P5, 'Integer'

        set    P2, 0
        set    P3, 1
        set    P4, 10000000

        print  "Iterations:    "
        print  P4
        print  "\n"

        # Eeevil hack.
        add    P5, P5, P4
        add    P5, P5, P4

        print  "Estimated ops: "
        print  P5
        print  "\n"

        time   N1

REDO:   sub    P4, P4, P3
        if     P4, REDO

        print  "done\n"
DONE:   time   N5

        sub    N2, N5, N1

        print  "Elapsed time:  "
        print  N2
        print  "\n"

        set    N1, P5
        div    N1, N1, N2
        set    N2, 1000000.0
        div    N1, N1, N2

        print  "M op/s:        "
        print  N1
        print  "\n"

        end

=head1 SEE ALSO

F<examples/mops/mops.c>,
F<examples/mops/mops.cs>,
F<examples/mops/mops.il>,
F<examples/mops/mops.p6>,
F<examples/mops/mops.pl>,
F<examples/mops/mops.ps>,
F<examples/mops/mops.py>,
F<examples/mops/mops.rb>,
F<examples/mops/mops.scheme>.

=cut

# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:
