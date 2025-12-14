% Написать предикат inorder(Tree, List), который возвращает 
% в List все значения узлов дерева Tree в симметричном порядке.


%     1
%    / \
%   2   3
%  / \   \
% 4   5   6

% List = [4, 2, 5, 1, 3, 6]

% Левое поддерево → Корень → Правое поддерево
% inorder(tree(1, 
                tree(2, 
                    tree(4,nil,nil), 
                    tree(5,nil,nil)), 
                tree(3, nil, 
                    tree(6,nil,nil))), List).



inorder(nil,[]).


inorder(tree(Value,Left,Right),List):-

    inorder(Left, LeftList),

    inorder(Right, RightList),

    append(LeftList, [Value | RightList], List).



