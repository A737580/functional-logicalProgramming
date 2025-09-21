%Хвостовая рекурсия: факториал N чисел.

factorial(N,Total):- factorial(N,1,Total).

factorial(0,Acc,Acc):- !.
factorial(N,Acc,Total):- N>0,
                         Prev is N-1,
                         NewAcc is Acc*N,
                         factorial(Prev, NewAcc, Total).




