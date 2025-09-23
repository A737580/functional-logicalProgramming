% Проверка списка на палиндром.

is_palindrome(List):- lenList(List,0,N),
                      N>1,
                      reverse_list(List,[],Reversed),
                      is_equalElem(List,Reversed).

lenList([],N,N):-!.
lenList([_|Tail],Acc,N):- NewAcc is Acc+1, 
                         lenList(Tail,NewAcc, N).

reverse_list([],Reversed,Reversed):-!.
reverse_list([Head|Tail],AList,Reversed):- reverse_list(Tail,[Head|AList],Reversed).

is_equalElem(List,List).
