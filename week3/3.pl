% На промежутке от -10 до 10 найти такое N для которого список от 0 до N равен списку от N до 0.

% Предикат для создания списка от A до B
create_list(A, B, []) :- A > B, !.
create_list(A, B, [A|Tail]) :-
    A =< B,
    NextA is A + 1,
    create_list(NextA, B, Tail).

% Предикат для создания списка от B до A (в обратном порядке)
create_reverse_list(A, B, []) :- A > B, !.
create_reverse_list(A, B, [A|Tail]) :-
    A =< B,
    NextA is A + 1,
    create_reverse_list(NextA, B, Tail).

remove_first([_],[]).
remove_first([_|Tail],Tail).

% Предикат для удаления последнего элемента
remove_last([_], []).
remove_last([Head|Tail], [Head|NewTail]) :-
    remove_last(Tail, NewTail).

is_equality_List(List,List).

% Основной предикат
find_n:-
    create_list(-10, 0, List1),
    create_reverse_list(0, 10, List2),
    process_lists(List1, List2).

print_ans:-
    write('Списки стали равными: '), write([0]), write(' и '), write([0]), nl,
    write('Найдено N = 0'), nl,!.

process_lists(List1, List2) :-
    write('Текущие списки: '), write(List1), write(' и '), write(List2), nl,
    remove_first(List1, NewList1),
    remove_last(List2, NewList2),
    (is_equality_List(NewList1,NewList2)->print_ans();process_lists(NewList1, NewList2)).

    
/*
prepend(Elem,List,[Elem|List]).

append(X,[],[X]).
append(X,[Head|Tail],[Head|NewTail]): - append(X,Tail,NewTail).

is_equality_List(List,List).
search_num(N):-search_num(N,0,[],[]).

search_num(N,N+1,_,_):-!.
search_num(N,Acc,L1,L2):- NewAcc is Acc+1,
                          Acc1 is -10+Acc,
                          Acc2 is 10-Acc,
                          append(Acc1,L1,NewL1),
                          prepend(Acc2,L2,NewL2),
                          search_num(N,NewAcc,NewAccL1,NewAccL2),
                          
*/
















