% Список из четных чисел. хвостовая рекурсия, инвертироанный/неинвертированный ответ.

% Решение с аккумулятором, что дает переворот в обратную сторону, дает возможность остановиться и вренуть результат.
filter_even(List, RevList):- filter_even(List, [], EvenList), reverse_tail(EvenList,RevList).

reverse_tail(List, Reversed) :- 
    reverse_tail(List, [], Reversed).

reverse_tail([], Acc, Acc):-!.  
reverse_tail([Head|Tail], Acc, Reversed) :-
    reverse_tail(Tail, [Head|Acc], Reversed).  

filter_even([],AList,AList):-!.
filter_even([Head|Tail], AList, EvenList):- 
                (Head mod 2 =:= 0 -> filter_even(Tail,[Head|AList],EvenList)
                ; filter_even(Tail,AList,EvenList)).


% Решение без условного оператора, без аккумулятора
/*
filter_even([], []).
filter_even([Head|Tail], [Head|EvenTail]) :- 
    Head mod 2 =:= 0,  
    filter_even(Tail, EvenTail).
filter_even([Head|Tail], EvenList) :- 
    Head mod 2 =:= 1, 
    filter_even(Tail, EvenList). 

*/*/



% Решение с условным оператором, без аккумулятора
/*
filter_even([],[]):-!.
filter_even([Head|Tail],Result):- 
                (Head mod 2 =:= 0 -> 
                Result = [Head|EvenList],
                filter_even(Tail,EvenList)
                ; 
                filter_even(Tail,Result)
                ).
*/