% Рекурсивная сумма непрерывной последовательности чисел от 0 до N.
sum(0, 0).
sum(N, Total):- N>0, 
                Prev is N-1, 
                sum(Prev, SumPrev), 
                Total is N + SumPrev.