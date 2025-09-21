% Вывод N случайных чисел на промежутке от А до Б на консоль.


print_randoms(A,B,N):- write_randoms(A,B,N).

rand_int(A,B,Ans):- random(X), Ans is A + floor(X*(B-A+1)),!.

write_randoms(_,_,N):- N=<0,!.
write_randoms(A,B,N):- N>0,
                        rand_int(A,B,Ans),
                        write(Ans),nl,
                        NewN is N-1,
                        write_randoms(A,B,NewN).
