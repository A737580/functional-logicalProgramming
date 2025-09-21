%Задача 4.1: Сумма цифр числа
%Найти сумму цифр числа N
%digit_sum(1234) = 1+2+3+4 = 10


digit_sum(N,Total):- digit_sum(N,0,Total).

digit_sum(0,Acc,Acc):-!.    
digit_sum(N,Acc,Total):- N>0,
                         NewAcc is Acc + (N mod 10),
                         NewN is N//10,
                         digit_sum(NewN,NewAcc,Total).




