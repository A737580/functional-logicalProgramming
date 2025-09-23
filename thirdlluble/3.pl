% Сумма элементов списка.

sum_list(List,Total):- sum_list(0,List,Total).

sum_list(Acc,[],Acc):-!.
sum_list(Acc,[Head|Tail],Total):- NewAcc is Acc+Head,
                                  sum_list(NewAcc,Tail,Total).


