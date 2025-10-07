% Напишите предикат split_list(List, N, FirstPart, SecondPart), который разбивает список на две части после N-го элемента.



split_list(List, 0, [], List).
split_list([Head|Tail], N, [Head|FirstPart], SecondPart) :-
    N > 0,
    NewN is N - 1,
    split_list(Tail, NewN, FirstPart, SecondPart).


/*

split_list(List,N,FirstPart,SecondPart):- split_list(List,0,N,FirstPart,SecondPart).

split_list(List,N,N,[],List):-!.
split_list([Head|Tail],Acc,N,FirstPart,SecondPart):- Acc<=N,
    NewAcc is Acc+1,
    split_list(Tail,NewAcc,N,[Head|FirstPart],SecondPart).
    
*/

