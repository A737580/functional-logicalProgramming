% Поиск max предиката в списке.

max_list([Head|Tail],MaxEl):- max_list(Head,[Head|Tail],MaxEl).

max_list(Acc,[],Acc):-!.
max_list(Acc,[Head|Tail],MaxEl):- (Acc=<Head -> NewMaxEl is Head; NewMaxEl is Acc),
                                  max_list(NewMaxEl,Tail,MaxEl).



