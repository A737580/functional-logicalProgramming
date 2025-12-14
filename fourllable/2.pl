% проверка что матрица не пустая
/*
length_my([],0):-!.
length_my([_|T],NewLen):- length_my(T,Len),NewLen is Len+1.

is_empty_row([_]).
is_empty_row([_|_]).


is_not_empty_matrix([Row|Rows]):-
    \+ is_empty_row(Row),
    length_my(Row,Len),
    length_rowsMatrix(Rows,Len).

length_rowsMatrix([],_).
length_rowsMatrix([Row|Rows],Len):-
    \+ is_empty_row(Row),
    length_my(Row,Len),
    length_rowsMatrix(Rows,Len).

*/



% проверка что матрица не пустая и валидная

length_my([], 0) :- !.
length_my([_|T], NewLen) :- 
    length_my(T, Len), 
    NewLen is Len + 1.

is_empty_row([]) :- !.
is_empty_row([_|_]).

is_not_empty_matrix([Row|Rows]) :-
    \+ is_empty_row(Row),
    length_my(Row, Len),
    check_rows_length(Rows, Len).

check_rows_length([], _).
check_rows_length([Row|Rows], Len) :-
    \+ is_empty_row(Row),
    length_my(Row, CurrentLen),
    CurrentLen =:= Len,
    check_rows_length(Rows, Len).

