%Задача 3: Числа Трибоначчи
%Найти N-ое число Трибоначчи (как Фибоначчи, но сумма ТРЕХ предыдущих)
%tribonacci(0)=0, tribonacci(1)=0, tribonacci(2)=1
%tribonacci(N) = tribonacci(N-1) + tribonacci(N-2) + tribonacci(N-3)


tribonacci(N,Total):- tribonacci(N,0,0,1,Total).

tribonacci(0,Acc,_,_,Acc):- !.
tribonacci(N,C,B,A,Total):- N>0,
                            NewA is C+B+A,
                            NewB is A,
                            NewC is B,
                            NewN is N-1,
                            tribonacci(NewN, NewC,NewB,NewA,Total).

