% Вычисления N-го числа фибоначчи

fibonacci(1,0).
fibonacci(2,1).

fibonacci(N, F):- N>2, 
                  PrevNN is N-2,
                  PrevN is N-1,
                  fibonacci(PrevNN, F2),
                  fibonacci(PrevN, F1),
                  F is F2+F1.

                  

