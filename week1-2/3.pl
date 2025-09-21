% Вывод простых чисел на промежутке от А до Б в консоль.


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

print_primes(A, B) :- 
    print_primes(A, B, A).

print_primes(_, B, Acc) :- 
    Acc > B, 
    !.

print_primes(A, B, Acc) :- 
    Acc =< B,
    (prime(Acc) -> 
        write('Prime: '), write(Acc), nl
    ; 
        true
    ),
    NewAcc is Acc + 1,
    print_primes(A, B, NewAcc).




















/*prime(2).
prime(N) :- 
    N > 2,
    N mod 2 > 0,
    check_divisors(N, 3).

check_divisors(N, D) :-
    D * D > N.       

check_divisors(N, D) :-
    D * D =< N,
    N mod D > 0,      
    NextD is D + 2,
    check_divisors(N, NextD).

check_prime(N, 1) :- prime(N).  
check_prime(N, 0) :- \+ prime(N).  
*/