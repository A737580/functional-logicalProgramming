%Задача 6: N Число Падована
%1P(n) = P(n-2) + P(n-3) с тремя аккумуляторами


podovan(N,T):-podovan(N,1,1,1,T).

podovan(N,_,_,Acc,Acc):- N>=0,N=<2,!.
podovan(N,C,B,A,Total):- N>2,
                         NewA is C+B,
                         NewB is A,
                         NewC is B,
                         NewN is N-1,
                         podovan(NewN, NewC,NewB,NewA,Total).






