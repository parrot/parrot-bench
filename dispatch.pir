# THIS IS A GENERATED FILE! DO NOT EDIT!
# Compiled with Winxed 1.9.1
# Source file: examples/benchmarks/dispatch.winxed
# Begin generated code

.namespace [ 'MyTestClass' ]

.sub 'get_integer' :method :vtable
    .return(1)

.end # get_integer


.sub 'get_int' :method
    .return(1)

.end # get_int

.sub Winxed_class_init :anon :load :init
    newclass $P0, [ 'MyTestClass' ]
.end
.namespace [ ]

.sub 'main' :subid('WSubId_1') :main
.const 'Sub' WSubId_6 = "WSubId_6"
.const 'Sub' WSubId_2 = "WSubId_2"
.const 'Sub' WSubId_3 = "WSubId_3"
.const 'Sub' WSubId_4 = "WSubId_4"
.const 'Sub' WSubId_5 = "WSubId_5"
.lex '__WLEX_1', $P1
.lex '__WLEX_2', $P3
.lex '__WLEX_3', $P2
    box $P1, 1000000
    new $P2, [ 'MyTestClass' ]
    new $P3, [ 'Integer' ]
    newclosure $P4, WSubId_2
    WSubId_6("no dispatch (base line)", $P4)
    newclosure $P4, WSubId_3
    WSubId_6("vtable calls", $P4)
    newclosure $P4, WSubId_4
    WSubId_6("method calls", $P4)
    newclosure $P4, WSubId_5
    WSubId_6("vtable_override calls", $P4)

.end # main


.sub '' :anon :subid('WSubId_2') :outer('WSubId_1')
    find_lex $P1, '__WLEX_1'
    set $I1, $P1
    null $I2
    null $I3
  __label_3: # for condition
    ge $I3, $I1, __label_2
    add $I2, $I2, 1
  __label_1: # for iteration
    inc $I3
    goto __label_3
  __label_2: # for end

.end # WSubId_2


.sub '' :anon :subid('WSubId_3') :outer('WSubId_1')
    find_lex $P1, '__WLEX_1'
    find_lex $P2, '__WLEX_2'
    set $I1, $P1
    box $P2, 1
    null $I2
    null $I3
  __label_3: # for condition
    ge $I3, $I1, __label_2
    set $I4, $P2
    add $I2, $I2, $I4
  __label_1: # for iteration
    inc $I3
    goto __label_3
  __label_2: # for end

.end # WSubId_3


.sub '' :anon :subid('WSubId_4') :outer('WSubId_1')
    find_lex $P1, '__WLEX_1'
    find_lex $P2, '__WLEX_3'
    set $I1, $P1
    null $I2
    null $I3
  __label_3: # for condition
    ge $I3, $I1, __label_2
    $P3 = $P2.'get_int'()
    set $I4, $P3
    add $I2, $I2, $I4
  __label_1: # for iteration
    inc $I3
    goto __label_3
  __label_2: # for end

.end # WSubId_4


.sub '' :anon :subid('WSubId_5') :outer('WSubId_1')
    find_lex $P1, '__WLEX_1'
    find_lex $P2, '__WLEX_3'
    set $I1, $P1
    null $I2
    null $I3
  __label_3: # for condition
    ge $I3, $I1, __label_2
    set $I4, $P2
    add $I2, $I2, $I4
  __label_1: # for iteration
    inc $I3
    goto __label_3
  __label_2: # for end

.end # WSubId_5


.sub 'count_time' :subid('WSubId_6')
        .param string __ARG_1
        .param pmc __ARG_2
    # not in 1.0
    #root_new $P1, ['parrot';'ResizablePMCArray']
    $P1 = new 'ResizablePMCArray'
    assign $P1, 1
    $P1[0] = __ARG_1
    sprintf $S1, "Starting %s", $P1
    say $S1
    time $N1
    __ARG_2()
    time $N2
    $P1 = new 'ResizablePMCArray'
    #root_new $P1, ['parrot';'ResizablePMCArray']
    assign $P1, 1
    sub $N3, $N2, $N1
    $P1[0] = $N3
    sprintf $S1, "Total time: %fs\n", $P1
    say $S1

.end # count_time

# End generated code
