% Обойти дерево обратным порядком. Левое поддерево → Правое поддерево → Корень
% Написать предикат postorder(Tree, List), который возвращает в List все значения 
% узлов дерева Tree в обратном порядке.

% Левое поддерево → Правое поддерево → Корень.

%     1
%    / \
%   2   3
%  / \   \
% 4   5   6
% [4, 5, 2, 6, 3, 1]

postorder(nil,[]).
postorder(tree(Value,Left,Right),List):- 
    postorder(Left,LeftList),

    postorder(Right,RightList),
    
    append(LeftList, RightList, Temp),

    append(Temp, [Value], List).



