% Вывод колличества чисел на промежутке от А до Б, которые без остатка делятся на 3,на консоль.




three_divisible(N):- N mod 3=:=0,!.

print_numbers(A,B,Total):- print_numbers(A,B,A,0,Total).

print_numbers(_,B,Acc,C,C):- Acc>B,!.
print_numbers(A,B,Acc,C,Total):- Acc=<B,
                         (three_divisible(Acc)->NewC is C+1,nl;NewC is C, true),
                         NewAcc is Acc+1,
                         print_numbers(A,B,NewAcc,NewC,Total).

