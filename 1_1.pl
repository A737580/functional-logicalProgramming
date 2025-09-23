% Тема недели - списки. week3
% Создать и вывести список от  0 до N. Рекурсия хвостовая. 


printFromZero(N):- generateAndWriteList(0,N,_).

generateAndWriteList(N,N,[N]):-!.
generateAndWriteList(Cur,N,[Cur|Tail]):- Cur =<N,
                                         NewCur is Cur+1,
                                         write(Cur),nl,
                                         generateAndWriteList(NewCur,N,Tail).
SS
/*
generateList(N,List):-generateList(0,N,List).

generateList(N,N,[N]):-!.
generateList(Cur,N,[Cur|Tail]):- Cur=<N,
                       NewCur is Cur+1,
                       generateList(NewCur,N,Tail).

printFromZero(N):- generateList(N,List),
                   writeList(List).

writeList([]):-!.
writeList([Head|Tail]):- write(Head),nl, writeList(Tail).
*/