% Конкатенация списков. обычная рекурсия

my_append([],List,List).

my_append([Head|Tail],List2,[Head|ResultTail]):- my_append(Tail,List2,ResultTail).



