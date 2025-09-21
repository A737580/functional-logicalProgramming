% Обычная рекурсия проверка на простое число

% обычная рекурсия
/*
prime(2).
prime(N):- N>2,
           N mod 2 =:= 1,
           not(has_divisor(N,3)).
has_divisor(N,D):- D=<N,
                   NewD is D+2,
                   has_divisor(N, NewD),
                   N mod D =:= 0.
*/


% По видимому это хвостовая рекурсия
prime(2).
prime(N):- N>2,
           N mod 2 =:= 1,
           not(has_divisor(N,3)).
has_divisor(N,D):- D*D=<N,
                   NewD is D+2,
                   N mod D =:= 0,
                   has_divisor(N, NewD).
 


























/*
prime(2).
prime(N) :- 
    N > 2,
    N mod 2 > 0,
    not(has_divisor(N, 3)).

has_divisor(N, D) :-
    D * D =< N,           
    (N mod D =:= 0        
    ;                     
    NextD is D + 2,
    has_divisor(N, NextD) 
    ).
    */