% Напишите предикат frequency(List, FreqList), который возвращает список пар [Элемент-Частота] для каждого уникального элемента.

/*
is_ElemExist(Head,[Head|_]).
is_ElemExist(Elem,[_|Tail]):-is_ElemExist(Elem,Tail).


countElem(Elem,List,Total):- countElem(Elem,List,0,Total).

countElem(_,[],Acc,Acc):-!.
countElem(Elem,[Elem|Tail],Acc,Total):- NewAcc is Acc+1, countElem(Elem,Tail,NewAcc,Total).
countElem(Elem,[_|Tail],Acc,Total):- countElem(Elem,Tail,Acc,Total). 


frequency(List,FreqList):- frequency(List,[],[],FreqList).

frequency([Head|Tail],BList,[NewElem|AList],FreqList):- 
    \+ is_ElemExist(Head,BList),!,
    countElem(Head,[Head|Tail],C),
    NewElem is [Head,C],
    frequency(Tail,[Head|BList],AList,FreqList).
    
frequency([_|Tail],BList,AList,FreqList):- 
    frequency(Tail,BList,AList,FreqList).

*/



is_ElemExist(Head, [Head|_]).
is_ElemExist(Elem, [_|Tail]) :- is_ElemExist(Elem, Tail).

countElem(Elem, List, Total) :- countElem(Elem, List, 0, Total).

countElem(_, [], Acc, Acc) :- !.
countElem(Elem, [Elem|Tail], Acc, Total) :- 
    NewAcc is Acc + 1, 
    countElem(Elem, Tail, NewAcc, Total).
countElem(Elem, [_|Tail], Acc, Total) :- 
    countElem(Elem, Tail, Acc, Total).

frequency(List, FreqList) :- frequency(List, [], FreqList).

frequency([], Acc, Acc):-!.  
frequency([Head|Tail], Seen, FreqList) :- 
    \+ is_ElemExist(Head, Seen), !,
    countElem(Head, [Head|Tail], Count),
    frequency(Tail, [Head|Seen], TempFreq),
    FreqList = [[Head, Count] | TempFreq].  
frequency([_|Tail], Seen, FreqList) :- 
    frequency(Tail, Seen, FreqList).





/*
frequency(List, FreqList) :- frequency(List, [], FreqList).

frequency([], FreqList, FreqList).
frequency([Head|Tail], Acc, FreqList) :-
    ( select([Head, Count], Acc, Rest) ->
        NewCount is Count + 1,
        frequency(Tail, [[Head, NewCount] | Rest], FreqList)
    ;
        frequency(Tail, [[Head, 1] | Acc], FreqList)
    ).
*/