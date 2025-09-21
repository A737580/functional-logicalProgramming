% Вывод чисел на промежутке от А до Б, которые без остатка делятся на 3,на консоль.




three_divisible(N):- N mod 3=:=0,!.

print_numbers(A,B):- print_numbers(A,B,A).

print_numbers(_,B,Acc):- Acc>B,!.
print_numbers(A,B,Acc):- Acc=<B,
                         (three_divisible(Acc)->write(Acc),nl;true),
                         NewAcc is Acc+1,
                         print_numbers(A,B,NewAcc).

