% Тема недели - списки.
% Вывод списка от  0 до N. Рекурсия обычная/хвостовая.

my_member(Element|[Element|_]).
my_member(Element, [_|Tail]):- my_member(Element, Tail).
