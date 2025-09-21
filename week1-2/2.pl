% Хвостовая рекурсия проверка на простое число

prime(2).
prime(N) :- 
    N > 2,
    N mod 2 > 0,
    check_divisors(N, 3).

check_divisors(N, D) :-
    D * D > N,      
    !.

check_divisors(N, D) :-
    N mod D > 0,     
    NextD is D + 2,  
    check_divisors(N, NextD).