% Напишите предикат remove_duplicates(List, UniqueList), который удаляет повторяющиеся элементы из списка.  Удаление элементов с конца или с начала.

my_member(X,[X|_]).
my_member(X,[_|Tail]):-my_member(X,Tail).


reverse_tail(List, Reversed) :- 
    reverse_tail(List, [], Reversed).

reverse_tail([], Acc, Acc):-!.  
reverse_tail([Head|Tail], Acc, Reversed) :-
    reverse_tail(Tail, [Head|Acc], Reversed).  


remove_duplicates(List, RList):- remove_duplicates(List,[],UList), reverse_tail(UList, RList).

remove_duplicates([],Acc,Acc).
remove_duplicates([Head|Tail],Acc,UList):- 
    (my_member(Head, Acc) -> remove_duplicates(Tail,Acc,UList); remove_duplicates(Tail,[Head|Acc],UList)).

/*
remove_duplicates([],[]).
remove_duplicates([Head|Tail], RList):-
    my_member(Head,Tail),!,
    remove_duplicates(Tail,).

*/



/*
remove_duplicates([], []).
remove_duplicates([Head|Tail], Result) :-
    member(Head, Tail), !,           % Если голова есть в хвосте - удаляем её
    remove_duplicates(Tail, Result).
remove_duplicates([Head|Tail], [Head|Result]) :-
    remove_duplicates(Tail, Result). % Если головы нет в хвосте - сохраняем её
*/


% "\+" с отрицанием. Альтернатива это отсечение или с условным оператором. С отрицанием операция считается вотрой раз.
% Отсечение - Пролог ВСЕГДА начинает проверку с ПЕРВОГО подходящего правила
/*
remove_duplicates([], []).
remove_duplicates([Head|Tail], Result) :-
    member(Head, Tail),
    remove_duplicates(Tail, Result).
remove_duplicates([Head|Tail], [Head|Result]) :-
    \+ member(Head, Tail),
    remove_duplicates(Tail, Result).
*/

% С сохранением порядка элементов в списке
/*
remove_duplicates(List, Unique) :-
    rd_helper(List, [], Unique).

rd_helper([], _, []).
rd_helper([Head|Tail], Seen, [Head|Result]) :-
    \+ member(Head, Seen), !,
    rd_helper(Tail, [Head|Seen], Result).
rd_helper([_|Tail], Seen, Result) :-
    rd_helper(Tail, Seen, Result).

*/