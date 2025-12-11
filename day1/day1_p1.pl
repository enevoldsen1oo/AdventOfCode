:- use_module(library(csv)).

read_my_data(File, Rows) :-
    csv_read_file(File, Rows, [functor(row), arity(1)]).


normalize(Pos, Normalized) :-
    Normalized is Pos mod 100.

parse_instruction(Atom, Dir, Value) :-
    atom_string(Atom, String),
    sub_string(String, 0, 1, After, DirStr),
    sub_string(String, 1, After, 0, ValueStr),
    atom_string(Dir, DirStr),
    number_string(Value, ValueStr).


apply_rotation(Start, Dir, Value, End) :-
    (Dir = 'R' ->
        NewPos is Start + Value
    ;
        NewPos is Start - Value
    ),
    normalize(NewPos, End).

count_zeros([], _, 0) :- !.
count_zeros([row(Instruction)|Rest], CurrentPos, ZeroCount) :-
    parse_instruction(Instruction, Dir, Value),
    apply_rotation(CurrentPos, Dir, Value, NewPos),
    format('After ~w: position ~w~n', [Instruction, NewPos]),
    count_zeros(Rest, NewPos, RestCount),
    (NewPos = 0 ->
        ZeroCount is RestCount + 1
    ;
        ZeroCount = RestCount
    ).


mainlul :-
    read_my_data('data.csv', Rows),
    count_zeros(Rows, 50, Count),
    format('Times pointing at 0: ~w~n', [Count]).