%Задача 2: Произведение четных чисел
%Найти произведение всех четных чисел от 2 до N
%product_evens(N) = 2 * 4 * 6 * ... * (N или N-1)


product_evens(N, Total):- product_evens(N,1,Total).

product_evens(0,Acc,Acc):- !.
product_evens(N,Acc,Total):- N>0, N mod 2 =:= 1, NewN is N-1, product_evens(NewN,Acc,Total).
product_evens(N,Acc,Total):- N>1,
                             N mod 2 =:= 0,
                             NewAcc is Acc*N,
                             NewN is N-2,
                             product_evens(NewN,NewAcc,Total).                             

% хитрый вариант.
/*
product_evens(N, Total) :- 
    MaxEven is N // 2 * 2,  % Находим ближайшее четное ≤ N
    product_evens(MaxEven, 1, Total).

product_evens(2, Acc, Acc) :- !.
product_evens(N, Acc, Total) :- 
    N > 2,
    NewAcc is Acc * N,
    NewN is N - 2,          !!! Только четные числа
    product_evens(NewN, NewAcc, Total).

*/
