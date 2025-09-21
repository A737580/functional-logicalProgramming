% Хвостовая рекурсия: сумма непрерывной последовательности чисел от 0 до N.
sum(N, Total):- sum(N,0,Total).

sum(0,Acc,Acc):-!.
sum(N,Acc,Total):-  N>0,
                    Prev is N-1, 
                    NewAcc is Acc+N,
                    sum(Prev, NewAcc, Total).
                    
