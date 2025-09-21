% Вывод диапозона случайных чисел на промежутке от А до Б на консоль.


print_randoms(A,B):- write_randoms(A,B,A).

rand_int(A,B,Ans):- random(X), Ans is A + floor(X*(B-A+1)),!.

write_randoms(_,B,Acc):- Acc>B,!.
write_randoms(A,B,Acc):- Acc=<B,
                         rand_int(A,B,Ans),
                         write(Ans),nl,
                         NewAcc is Acc+1,
                         write_randoms(A,B,NewAcc).
