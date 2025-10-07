% Напишите предикат flatten_list(NestedList, FlatList), который преобразует вложенный список в плоский.
/*

?- flatten_list([1, [2, [3, 4]], 5], F).
F = [1, 2, 3, 4, 5].

*/

flatten_list([],[]).
flatten_list([Head|Tail], CList):- 
    is_list(Head),!,
    flatten_list(Head,RList1),
    flatten_list(Tail,RList2),
    my_append(RList1,RList2, CList).

flatten_list([Head|Tail], [Head|RList1]):- 
    flatten_list(Tail, RList1).

my_append([],List,List).
my_append([Head|Tail],List,[Head|CList]):-my_append(Tail,List,CList).


