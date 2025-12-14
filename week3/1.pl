% Тема недели - списки. week3
% Вывод списка. Рекурсия обычная/хвостовая. 

writeList([]):-!.
writeList([FirstEl|Tail]):- write(FirstEl),nl, writeList(Tail).
