% Разворот списка.

reverse_list(List, Reversed):- reverse_list(List,[],Reversed).

reverse_list([],Reversed,Reversed):-!.
reverse_list([Head|Tail],AList,Reversed):- reverse_list(Tail,[Head|AList],Reversed).
