% Вывод списка от  N до 0. Рекурсия хвостовая. 

generateList(0,[0]):-!.
generateList(N,[N|Tail]):- N>0,
                       N1 is N-1,
                       generateList(N1,Tail).

printFromZero(N):- generateList(N,List),
                   writeList(List).

writeList([]):-!.
writeList([Head|Tail]):- write(Head),nl, writeList(Tail).