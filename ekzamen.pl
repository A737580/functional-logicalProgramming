% Структура дерева: nil или tree(Left, Pair, Right)
% Pair = (First, Second)

% Предикат для проверки делимости на 3
divisible_by_three(First) :-
    First mod 3 =:= 0.

% Основной предикат: сумма Second, где First делится на 3
sum_second_div_by_three(Tree, Sum) :-
    sum_second_div_by_three(Tree, 0, Sum).

% Базовый случай: пустое дерево
sum_second_div_by_three(nil, Acc, Acc).

% Рекурсивный случай: обход дерева
sum_second_div_by_three(tree(Left, (First, Second), Right), Acc, Sum) :-
    % Обрабатываем левое поддерево
    sum_second_div_by_three(Left, Acc, Acc1),
    % Обрабатываем текущий узел
    (   divisible_by_three(First)
    ->  Acc2 is Acc1 + Second
    ;   Acc2 = Acc1
    ),
    % Обрабатываем правое поддерево
    sum_second_div_by_three(Right, Acc2, Sum).


tree_example(
    tree(
        tree(nil, (2, 5), nil),
        (6, 10),
        tree(
            tree(nil, (3, 7), nil),
            (9, 20),
            nil
        )
    )
).


tree_example(T), sum_second_div_by_three(T, Sum).










