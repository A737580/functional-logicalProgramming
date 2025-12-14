% Тема раздела - матрицы

% Проверка что все строки матрицы одинаковой длины

length_my([],0):-!.
length_my([_|T],NewLen):- length_my(T,Len),NewLen is Len+1.

is_list_my([_|_]).


is_matrix([]).
is_matrix([Row|Rows]):-
    is_list_my(Row),
    length_my(Row, Len),
    check_row_length(Rows,Len).

check_row_length([],_).
check_row_length([Row|Rows],Length):-
    length_my(Row,Length),
    check_row_length(Rows,Length).


% Решение с проверкой что все элементы списка, являются числами
/*
% Проверка что все элементы списка - числа (не списки)
all_numbers([]).
all_numbers([H|T]) :-
    number(H),
    all_numbers(T).

% Проверка что строка состоит только из чисел
is_flat_row(Row) :-
    all_numbers(Row).

% Проверка матрицы
is_matrix([]).
is_matrix([Row|Rows]) :-
    is_flat_row(Row),
    length_my(Row, Len),
    check_row_length(Rows, Len).

check_row_length([], _).
check_row_length([Row|Rows], Length) :-
    is_flat_row(Row),
    length_my(Row, Length),
    check_row_length(Rows, Length).

% Тестирование
% ?- is_matrix([[2,2,2],[3,[34,2,2],[2,2,2]]]).
% false



*/


