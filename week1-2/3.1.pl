%Хвостовая рекурсия: нахождение факториала в обратную сторону.

factorial(N,Total):- factorial(N,1,1,Total).

factorial(0,_,Acc,Acc):- !.
factorial(N,K,Acc,Total):- N>0,
                           NewAcc is Acc*K,
                           NewK is K+1,
                           NewN is N-1,
                           factorial(NewN, NewK, NewAcc, Total).




