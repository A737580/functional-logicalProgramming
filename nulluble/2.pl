parent(ann, bob).
parent(bob, carl).


grandparent(X, Y):- parent(X,Z), parent(Z,Y).  