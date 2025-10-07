%Напишите предикат deep_sum(List, Sum), который вычисляет сумму всех чисел во вложенном списке.


deep_sum([],0).
deep_sum([Head|Tail],NewSum):- 
    is_list(Head),!,
    deep_sum(Head,Sum1),
    deep_sum(Tail,Sum2),
    NewSum is Sum1+Sum2.

deep_sum([Head|Tail],NewSum):- 
    deep_sum(Tail, Sum),
    NewSum is Sum + Head.




/*

deep_sum([], 0).
deep_sum([Head|Tail], NewSum):- 
    is_list(Head), !,
    deep_sum(Head, Sum1),
    deep_sum(Tail, Sum2),
    NewSum is Sum1 + Sum2.
deep_sum([Head|Tail], NewSum):- 
    number(Head), !,           % ← ДОБАВЛЕНО: проверка, что Head - число
    deep_sum(Tail, Sum),
    NewSum is Sum + Head.
deep_sum([_|Tail], Sum):-      % ← ДОБАВЛЕНО: обработка нечисловых элементов
    deep_sum(Tail, Sum).
*/



%Компактная версия
/*
deep_sum([], 0).
deep_sum([Head|Tail], Sum) :-
    ( number(Head) -> 
        deep_sum(Tail, TailSum), Sum is Head + TailSum
    ; is_list(Head) -> 
        deep_sum(Head, HeadSum), deep_sum(Tail, TailSum), Sum is HeadSum + TailSum
    ; 
        deep_sum(Tail, Sum)
    ).
*/