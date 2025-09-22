% Проверка наличия элемента в списке


my_member(Element, [Element|_]).
my_member(Element, [_|Tail]):- my_member(Element, Tail).