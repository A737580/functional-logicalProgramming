% На промежутке от -10 до 10 найти такое N для которого список от 0 до N равен списку от N до 0.

prepend(Elem,List,[Elem|List]).

append(X,[],[X]).
append(X,[Head|Tail],[Head|NewTail]): - append(X,Tail,NewTail).

is_equality_List(List,List).
search_num(N):-search_num(N,0,[],[]).

search_num(N,N,_,_).
search_num(_,10,_,_).
search_num(_,-10,_,_).
search_num(N,Acc,L1,L2):- NewAccL1 is Acc+1,
                          NewAccL2 is -(Acc+1),
                          prepend(NewAccL1,L1,NewL1),
                          prepend(NewAccL2,L2,NewL2),
                          write(L1),write(" равен "), write(L2),nl,
                          search_num(N,NewAccL1,NewL1,NewL2),!.
go_list([_|T],T).












