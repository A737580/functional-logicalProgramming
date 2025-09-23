%Удвоение всех элементов.

double_list([],[]):-!.
double_list([Head|Tail], [NewHead|NewTail]):- NewHead is Head*2,
                                              double_list(Tail,NewTail).