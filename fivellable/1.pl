% тема недели деревья
% Написать предикат preorder(Tree, List), который возвращает в List все значения узлов дерева Tree 
% в прямом порядке.
% Корень → Левое поддерево → Правое поддерево.
% preorder(tree(1,tree(2,nil,nil),tree(3,nil,nil)), List)
%     1
%    / \
%   2   3
% -> [1,2,3]


% Базовый случай: пустое дерево
preorder(nil, []).

% Рекурсивный случай: непустое дерево
preorder(tree(Value, Left, Right), List) :-
    
    % Рекурсивно обходим левое поддерево
    preorder(Left, LeftList),

    % Рекурсивно обходим правое поддерево  
    preorder(Right, RightList),

    % Собираем итоговый список: Value + LeftList + RightList
    append([Value | LeftList], RightList, List).
