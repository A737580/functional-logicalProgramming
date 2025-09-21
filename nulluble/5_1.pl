% Вычисления N-го числа фибоначчи
       
fibonacci(N, F) :-
    fibonacci(N, 0, 1, F).  

fibonacci(0, A, _, A) :- !. 
fibonacci(N, A, B, F) :-
    N > 0,
    NewA is B,          % Сдвигаем: новый A = старый B
    NewB is A + B,      % Новый B = A + B
    NewN is N - 1,
    fibonacci(NewN, NewA, NewB, F). % Хвостовой вызов






