:- use_module(library(csv)).

read_my_data(File, Rows) :-
    csv_read_file(File, Rows, [functor(row), arity(38)]).

create_list([Row | _], List) :-
    Row =.. [_Functor | Fields],
    List = Fields.

loop_ranges([], Acc, Acc).

loop_ranges([El], Acc, Result) :-
    do_something(El, Check),
    Result is Acc + Check.

loop_ranges([El | List], Acc, Result) :-
    do_something(El, Check),
    format("Interval: ~w = ~w~n", [El, Check]),
    Acc1 is Acc + Check,
    loop_ranges(List, Acc1, Result).

do_something(El, Check) :-
    atom_string(El, String),
    sub_string(String, Before, _, After, "-"),
    sub_string(String, 0, Before, _, Low),
    sub_string(String, _, After, 0, High),
    atom_number(Low, Low_val),
    atom_number(High, High_val),
    sub_check(Low_val, High_val, Check).

sub_check(Low_val, High_val, Sum) :-
    sub_check(Low_val, High_val, 0, Sum).

sub_check(Current, High, Acc, Acc) :-
    Current > High, !.

sub_check(Current, High, Acc, Sum) :-
    Current =< High,
    (is_repetition(Current) ->
        Acc1 is Acc + Current
    ;
        Acc1 = Acc
    ),
    Next is Current + 1,
    sub_check(Next, High, Acc1, Sum).

is_repetition(Num) :-
    number_string(Num, Str),
    string_length(Str, Len),
    Len > 1,
    Len mod 2 =:= 0,
    HalfLen is Len // 2,
    sub_string(Str, 0, HalfLen, _, First),
    sub_string(Str, HalfLen, HalfLen, _, Second),
    First = Second.

go :-
    read_my_data('interv.csv', Rows),
    create_list(Rows, List),
    loop_ranges(List, 0, Result),
    format("Total sum of invalid IDs: ~w~n", [Result]).