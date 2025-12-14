% Деревья

count(empty,0).
count(tree(_,Left,Right),C):-
    count(Left,L), count(Right,R),C is L+R+1.

getTree(T):-
    T=tree(1,
            tree(2,
                tree(4,empty,empty),
                tree(5,empty,empty),
            tree(3,
                empty,
                tree(6,empty,empty)))).