:- use_module(library(csv)).

read_my_data(File, Rows) :-
    csv_read_file(File, Rows, [functor(row), arity(1)]).

normalize(Pos, FinalPos, Count) :-
    normalize_helper(Pos, 0, FinalPos, Count).

normalize_helper(Pos, Acc, FinalPos, Count) :-
    Pos >= 100,
    !,
    Count1 is Acc + 1,
    NewPos is Pos - 100,
    normalize_helper(NewPos, Count1, FinalPos, Count).
    
normalize_helper(Pos, Acc, FinalPos, Count) :-
    Pos < 0,
    !,
    Count1 is Acc + 1,
    NewPos is Pos + 100,
    normalize_helper(NewPos, Count1, FinalPos, Count).

normalize_helper(Pos, Acc, Pos, Acc).

parse_instruction(Atom, Dir, Value) :-
    atom_string(Atom, String),
    string_chars(String, [DirChar | ValueChars]),
    atom_string(Dir, [DirChar]),
    string_chars(ValueStr, ValueChars),
    number_string(Value, ValueStr).

apply_rotation(0, Dir, Value, FinalPos, 0) :-
    Value < 101,
    !,
    (Dir = 'R' ->
        NewPos is 0 + Value
    ;
        NewPos is 0 - Value
    ),
    normalize(NewPos, FinalPos, _),
    format('Using 1.~n').

apply_rotation(Start, Dir, Value, Out, 0) :-
    Value < 101,
    Start \= 0,
    (Dir = 'R' ->
        NewPos is Start + Value
    ;
        NewPos is Start - Value
    ),
    normalize(NewPos, FinalPos, _),
    format('Using 2 ~n'),
    FinalPos == 0,
    !,
    format('Finishing 2~n'),
    Out is 0.
    
apply_rotation(Start, Dir, Value, FinalPos, CrossCount) :-
    (Dir = 'R' ->
        NewPos is Start + Value
    ;
        NewPos is Start - Value
    ),
    NewPos < 0,
    !,
    normalize(NewPos, FinalPos, Temp),
    CrossCount is Temp - 1,
    format('Using 3 ~n').


apply_rotation(Start, Dir, Value, FinalPos, CrossCount) :-
    (Dir = 'R' ->
        NewPos is Start + Value
    ;
        NewPos is Start - Value
    ),
    normalize(NewPos, FinalPos, CrossCount),
    format('Using 4: ~n').

count_zeros([], _, 0) :- !.
count_zeros([row(Instruction)|Rest], CurrentPos, ZeroCount) :-
    parse_instruction(Instruction, Dir, Value),
    apply_rotation(CurrentPos, Dir, Value, FinalPos, CrossCount),
    format('After ~w: position ~w (crossed 0: ~w times)~n', [Instruction, FinalPos, CrossCount]),
    count_zeros(Rest, FinalPos, RestCount),
    (FinalPos = 0 ->
        ZeroCount is CrossCount + RestCount + 1  % Add 1 for landing on 0
    ;
        ZeroCount is CrossCount + RestCount
    ).

main :-
    read_my_data('data.txt', Rows),
    count_zeros(Rows, 50, Count),
    format('Times pointing at 0: ~w~n', [Count]).