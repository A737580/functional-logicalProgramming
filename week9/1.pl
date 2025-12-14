% обход дерева вывести в файл, при этом  нарисовать структуру линиями



% Предикат для записи дерева в файл
write_tree_to_file(FileName, Tree) :-
    open(FileName, write, Stream),
    write_tree(Stream, Tree, 0, []),
    close(Stream).

% Базовый случай: пустое дерево
write_tree(Stream, nil, _, _).

% Основной случай: дерево с корнем и поддеревьями
write_tree(Stream, tree(Value, Left, Right), Depth, IsLastList) :
    % Вычисляем отступы и соединительные линии
    calculate_indentation(Depth, IsLastList, Indent, Connectors),
    
    % Записываем текущий узел
    format(Stream, '~w~w~n', [Indent, Value]),
    
    % Определяем, является ли правое поддерево последним
    (Right == nil -> NextIsLast = true ; NextIsLast = false),
    
    % Добавляем информацию о текущем узле в список
    append(IsLastList, [NextIsLast], NewIsLastList),
    
    % Рекурсивно обрабатываем левое поддерево
    (Left \== nil ->
        NewDepth is Depth + 1,
        write_tree(Stream, Left, NewDepth, NewIsLastList)
    ; true),
    
    % Рекурсивно обрабатываем правое поддерево
    (Right \== nil ->
        NewDepth is Depth + 1,
        write_tree(Stream, Right, NewDepth, NewIsLastList)
    ; true).

% Вычисление отступов и соединительных линий
calculate_indentation(Depth, IsLastList, Indent, Connectors) :-
    Depth > 0,
    calculate_connectors(IsLastList, Connectors),
    calculate_spaces(Depth, Spaces),
    atom_concat(Connectors, Spaces, Indent).

calculate_indentation(0, _, '', '').

% Вычисление соединительных линий
calculate_connectors([], '').
calculate_connectors([IsLast], Connector) :-
    (IsLast -> Connector = '    ' ; Connector = '│   ').
calculate_connectors([IsLast|Rest], Result) :-
    calculate_connectors(Rest, RestResult),
    (IsLast -> 
        atom_concat('    ', RestResult, Result)
    ; 
        atom_concat('│   ', RestResult, Result)
    ).

% Вычисление пробелов для отступов
calculate_spaces(Depth, Spaces) :-
    (Depth > 0 ->
        NextDepth is Depth - 1,
        calculate_spaces(NextDepth, NextSpaces),
        atom_concat('    ', NextSpaces, Spaces)
    ; 
        Spaces = ''
    ).

% Альтернативная версия с более простой визуализацией
write_tree_simple(Stream, Tree, Prefix, IsLast) :-
    Tree = tree(Value, Left, Right),
    
    % Записываем текущий узел
    format(Stream, '~w~w~n', [Prefix, Value]),
    
    % Вычисляем новый префикс
    (IsLast -> 
        atom_concat(Prefix, '    ', NewPrefix)
    ; 
        atom_concat(Prefix, '│   ', NewPrefix)
    ),
    
    % Обрабатываем правое поддерево (последнее)
    (Right \== nil ->
        (Left == nil -> 
            atom_concat(Prefix, '└── ', RightPrefix)
        ; 
            atom_concat(Prefix, '├── ', RightPrefix)
        ),
        write_tree_simple(Stream, Right, RightPrefix, true)
    ; true),
    
    % Обрабатываем левое поддерево
    (Left \== nil ->
        atom_concat(Prefix, '└── ', LeftPrefix),
        write_tree_simple(Stream, Left, LeftPrefix, true)
    ; true).

write_tree_simple(Stream, nil, _, _).

% Предикат для записи дерева в файл (простая версия)
write_tree_to_file_simple(FileName, Tree) :-
    open(FileName, write, Stream),
    write_tree_simple(Stream, Tree, '', true),
    close(Stream).

% Примеры деревьев для тестирования
% Простое дерево
tree1(tree(1, 
          tree(2, 
               tree(4, nil, nil), 
               tree(5, nil, nil)), 
          tree(3, 
               tree(6, nil, nil), 
               nil))).

% Более сложное дерево
tree2(tree('A',
          tree('B',
               tree('D', nil, nil),
               tree('E',
                    tree('G', nil, nil),
                    nil)),
          tree('C',
               nil,
               tree('F',
                    tree('H', nil, nil),
                    tree('I', nil, nil))))).

% Предикат для демонстрации
demo :-
    tree1(Tree1),
    write_tree_to_file('tree1_output.txt', Tree1),
    write('Дерево 1 записано в tree1_output.txt'), nl,
    
    tree2(Tree2),
    write_tree_to_file('tree2_output.txt', Tree2),
    write('Дерево 2 записано в tree2_output.txt'), nl,
    
    % Простая версия
    write_tree_to_file_simple('tree1_simple.txt', Tree1),
    write('Дерево 1 (простая версия) записано в tree1_simple.txt'), nl.

% Запуск демо
:- initialization(demo).





test_tree(T) :-
    T = tree(root,
            tree(left_child,
                 tree(left_grandchild, nil, nil),
                 nil),
            tree(right_child,
                 nil,
                 tree(right_grandchild, nil, nil))).