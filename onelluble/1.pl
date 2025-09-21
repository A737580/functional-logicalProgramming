%Задача 1: Сумма квадратов
%Вычислить сумму квадратов чисел от 1 до N
%sum_squares(N) = 1² + 2² + 3² + ... + N²

%вариант решения нисходящий (сумма начинается с последнего квадрата)
/*
sum_squares(N,Total):- sum_squares(N,0,Total).

sum_squares(0,Acc,Acc):-!.
sum_squares(N,Acc,Total):- N>0,
                           Prev is N-1,
                           NewAcc is Acc+ N*N,
                           sum_squares(Prev,NewAcc,Total).
*/

%вариант решения восходящий (сумма начинается с нуля)

sum_squares(N,Total):- sum_squares(N,0,0,Total).

sum_squares(N,Acc,K,Acc):- K>N,!.
sum_squares(N,Acc,K,Total):- K=<N,
                           NewAcc is Acc+K*K,
                           NewK is K+1,
                           sum_squares(N,NewAcc,NewK,Total).


