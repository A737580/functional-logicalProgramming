%Задача 5.1: Обратное число
%Развернуть число цифрами назад
%reverse_number(1234) = 4321
%*Подсказка: аккумулятор для результата, N//10 и N mod 10*

reverse_number(N,T):- reverse_number(N,0,T).

reverse_number(0,Acc,Acc):- !.

reverse_number(N,Acc,Total):- N>0,
                              NewAcc is Acc*10 + (N mod 10),
                              NewN is N//10,
                              reverse_number(NewN, NewAcc, Total).
                                 


