% Вывод диапозона случайных чисел на промежутке от А до Б на консоль, чтобы два соседние числа были различны.


print_randoms(A,B,N):- (N>=1->rand_int(A,B,First),
                        write(First),nl,
                        write_randoms(A,B,N-1,First);false).

rand_int(A,B,Ans):- random(X), Ans is A + floor(X*(B-A+1)),!.

write_randoms(_,_,N,_):- N=<0,!.
write_randoms(A,B,N,Buff):- N>0,
                        rand_int(A,B,Ans),
                        (Buff=:=Ans-> rand_int(A,B, NewAns), write(NewAns),nl,NewBuff = NewAns
                        ;
                        write(Ans),nl, NewBuff = Ans),
                        NewN is N-1,
                        write_randoms(A,B,NewN,NewBuff).
