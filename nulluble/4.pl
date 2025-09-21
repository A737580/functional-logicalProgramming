% Рекурсивный факториал N чисел.

factorial(0,1).
factorial(N, Total):-   N>0, 
                        Prev is N-1,
                        factorial(Prev, Res),
                        Total is N * Res.