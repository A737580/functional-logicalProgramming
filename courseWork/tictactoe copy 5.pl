% =================================================================================
% TIC-TAC-TOE (Крестики-нолики) упрощенный код с комментарими и форматированием поля
% Учебный код для SWI-Prolog.
% Особенности: Настраиваемый размер (N) и условие победы (K), точное форматирование.
% =================================================================================

:- initialization(main).

% ==========================================
% 1. ЗАПУСК И НАСТРОЙКА ИГРЫ
% ==========================================

main :-
    nl, writeln('--- КРЕСТИКИ-НОЛИКИ ---'),
    % Читаем и сразу проверяем ввод
    read_number('Введите размер поля N (например, 3): ', N),
    read_number('Введите длину для победы K (например, 3): ', K),
    
    ( validate_settings(N, K) ->
        start_game(N, K)
    ;
        writeln('Ошибка: N и K должны быть > 0, и K <= N.'),
        halt
    ).

% Проверка корректности настроек
validate_settings(N, K) :-
    integer(N), N > 0,
    integer(K), K > 0,
    K =< N.

start_game(N, K) :-
    create_empty_board(N, Board),
    play(Board, N, K, x).

% Создаем список из N строк, где каждая строка — список из N пробелов
create_empty_board(N, Board) :-
    length(Row, N), 
    maplist(=(' '), Row),
    length(Board, N), 
    maplist(=(Row), Board).

% ==========================================
% 2. ИГРОВОЙ ЦИКЛ (LOOP)
% ==========================================

play(Board, N, K, Player) :-
    print_board(Board),         % 1. Показать поле
    ask_move(Row, Col, Player), % 2. Спросить ход
    
    ( is_valid_move(Board, Row, Col) ->
        % Если ход валиден:
        make_move(Board, Row, Col, Player, NewBoard),
        check_game_over(NewBoard, N, K, Player)
    ;
        % Если ход неверен:
        writeln('>>> Неверный ход (клетка занята или вне поля). Попробуйте снова.'),
        play(Board, N, K, Player)
    ).

% Логика окончания игры
check_game_over(Board, _, K, Player) :-
    check_winner(Board, K, Player), !, % Если есть победитель
    print_board(Board),
    format('>>> ИГРОК ~w ПОБЕДИЛ! ПОЗДРАВЛЯЕМ!~n', [Player]).

check_game_over(Board, _, _, _) :-
    is_board_full(Board), !,           % Если доска полная
    print_board(Board),
    writeln('>>> НИЧЬЯ! Больше нет ходов.').

check_game_over(Board, N, K, Player) :-
    % Если игра не окончена, меняем игрока и продолжаем
    switch_player(Player, NextPlayer),
    play(Board, N, K, NextPlayer).

% Ввод хода с защитой от ошибок
ask_move(Row, Col, Player) :-
    nl, format('Ход игрока [~w].~n', [Player]),
    read_number('Номер строки: ', Row),
    read_number('Номер столбца: ', Col).

% Утилита для чтения числа (гарантирует integer)
read_number(Prompt, Value) :-
    write(Prompt),
    read(Input),
    ( number(Input) -> Value is round(Input) ; Value = -1 ).

switch_player(x, o).
switch_player(o, x).

% ==========================================
% 3. ОТРИСОВКА (FORMATTING)
% Самая сложная часть для соблюдения визуальных требований.
% ==========================================

print_board(Board) :-
    nl, length(Board, N),
    
    % --- РАСЧЕТ ОТСТУПОВ ---
    N_Int is round(N), 
    term_to_atom(N_Int, AtomN),
    atom_length(AtomN, MaxIdxLen),  % Длина индекса (например, "10" -> 2)
    ColWidth is MaxIdxLen + 2,      % Ширина ячейки
    Indent   is MaxIdxLen + 1,      % Отступ слева для сетки
    
    % --- ВЫВОД ---
    % 1. Заголовки столбцов
    print_header(1, N, ColWidth, Indent), 
    
    % 2. Печатаем верхний разделитель
    print_separator(N, ColWidth, Indent),
    
    % 3. Печатаем строки
    print_rows(Board, 1, N, MaxIdxLen, ColWidth, Indent),
    
    % 4. НОВОЕ: ПЕЧАТАЕМ ЗАКРЫВАЮЩИЙ РАЗДЕЛИТЕЛЬ СНИЗУ
    print_separator(N, ColWidth, Indent),

    nl.

% ------------------------------------------------------------------
% --- ЛОГИКА ДЛЯ ГОРИЗОНТАЛЬНЫХ ИНДЕКСОВ (print_header) ---
% ------------------------------------------------------------------

% -- Заголовки столбцов (1 2 3 ...) --
print_header(I, N, _, _) :- I > N, nl, !.
print_header(1, N, Width, Indent) :-
    % Первый отступ: Indent + 1 + ' '
    tab(Indent), write(' '),        
    write(' '),                     % Сдвиг вправо на 1 символ 
    print_centered(1, Width),       % Печать первого числа
    Next is 1 + 1,
    print_header(Next, N, Width, Indent).
print_header(I, N, Width, Indent) :-
    I > 1,
    write(' '),                     % Пробел над разделителем
    print_centered(I, Width),
    Next is I + 1,
    print_header(Next, N, Width, Indent).

% -- Горизонтальный разделитель (+---+---+) --
print_separator(N, Width, BaseIndent) :-
    RealIndent is BaseIndent + 2,   % Сдвиг вправо под начало ячеек
    tab(RealIndent),
    write('+'),
    print_separator_cells(N, Width),
    nl.

print_separator_cells(0, _) :- !.
print_separator_cells(Count, Width) :-
    print_dashes(Width),
    write('+'),
    Next is Count - 1,
    print_separator_cells(Next, Width).

print_dashes(0) :- !.
print_dashes(K) :- write('-'), K1 is K - 1, print_dashes(K1).

% -- Вывод строк с данными --
print_rows([], _, _, _, _, _).
print_rows([Row|Rest], RowNum, N, MaxIdxLen, Width, Indent) :-
    % 1. Печать индекса строки (выровнен вправо)
    print_row_index(RowNum, MaxIdxLen),
    
    % 2. Печать ячеек (| x | o |)
    print_row_cells(Row, Width),
    nl,
    
    % 3. Печать разделителя (МЕЖДУ СТРОКАМИ, но не после последней)
    ( Rest \= [] -> print_separator(N, Width, Indent) ; true ),
    
    NextRow is RowNum + 1,
    print_rows(Rest, NextRow, N, MaxIdxLen, Width, Indent).

print_row_index(Num, MaxLen) :-
    % ЛОГИКА для вертикальных индексов
    RNum_Int is round(Num),
    term_to_atom(RNum_Int, Atom),
    atom_length(Atom, Len),
    Pad is MaxLen - Len,
    tab(Pad), write('  '), write(Atom), write(' |').

print_row_cells([], _) :- !.
print_row_cells([Cell|Rest], Width) :-
    print_centered(Cell, Width),
    write('|'),
    print_row_cells(Rest, Width).

% -- Универсальное центрирование --
print_centered(Content, Width) :-
    ( number(Content) -> 
        Num is round(Content),
        term_to_atom(Num, Atom) 
    ; Atom = Content ),
    atom_length(Atom, Len),
    PadLeft is Width // 2,
    PadRight is Width - PadLeft - Len,
    % Защита от отрицательного отступа
    ( PadRight < 0 -> R = 0 ; R = PadRight ),
    format('~*c~w~*c', [PadLeft, 32, Atom, R, 32]).

% ==========================================
% 4. ЛОГИКА ИЗМЕНЕНИЯ ДОСКИ
% ==========================================

is_valid_move(Board, Row, Col) :-
    Row > 0, Col > 0,
    nth1(Row, Board, BoardRow),    % Получаем строку
    nth1(Col, BoardRow, Cell),     % Получаем ячейку
    Cell == ' '.                   % Проверяем, что она пуста

make_move(Board, Row, Col, Player, NewBoard) :-
    nth1(Row, Board, OldRow),
    replace_in_list(OldRow, Col, Player, NewRow),
    replace_in_list(Board, Row, NewRow, NewBoard).

% Вспомогательный предикат для замены N-го элемента списка
replace_in_list([_|T], 1, Val, [Val|T]).
replace_in_list([H|T], I, Val, [H|Rest]) :-
    I > 1, 
    NextI is I - 1, 
    replace_in_list(T, NextI, Val, Rest).

is_board_full(Board) :-
    % Не существует строки, в которой есть пробел
    \+ (member(Row, Board), member(' ', Row)).

% ==========================================
% 5. ПРОВЕРКА ПОБЕДЫ
% ==========================================

check_winner(Board, K, Player) :-
    check_rows(Board, K, Player);
    check_columns(Board, K, Player);
    check_diagonals(Board, K, Player).

% 1. Строки: просто проверяем каждый список
check_rows(Board, K, Player) :-
    member(Row, Board),
    has_consecutive(Row, Player, K).

% 2. Столбцы: извлекаем столбец и проверяем его как список
check_columns(Board, K, Player) :-
    length(Board, N),
    between(1, N, ColIdx),          % Генерируем индекс от 1 до N
    extract_column(Board, ColIdx, ColumnList),
    has_consecutive(ColumnList, Player, K).

extract_column(Board, ColIdx, Column) :-
    maplist(nth1(ColIdx), Board, Column).

% 3. Диагонали: собираем все диагонали и проверяем
check_diagonals(Board, K, Player) :-
    collect_all_diagonals(Board, Diagonals),
    member(Diag, Diagonals),
    has_consecutive(Diag, Player, K).

% Сбор диагоналей (математический метод)
collect_all_diagonals(Board, AllDiags) :-
    length(Board, N),
    % Диагонали NW-SE (слева-направо вниз) определяются формулой: I - J = Const
    % Диагонали NE-SW (слева-направо вверх) определяются формулой: I + J = Const
    findall(D, get_diag(Board, N, nwse, D), D1),
    findall(D, get_diag(Board, N, nesw, D), D2),
    append(D1, D2, AllDiags).

get_diag(Board, N, Dir, Diag) :-
    limit_range(N, Dir, Min, Max),
    between(Min, Max, Key),
    construct_diag(Board, Key, Dir, Diag),
    Diag \= [].

limit_range(N, nwse, Min, Max) :- Min is 1 - N, Max is N - 1.
limit_range(N, nesw, Min, Max) :- Min is 2,     Max is 2 * N.

construct_diag(Board, Key, nwse, Diag) :-
    findall(Cell, 
            (nth1(R, Board, Row), nth1(C, Row, Cell), Key =:= R - C), 
            Diag).
construct_diag(Board, Key, nesw, Diag) :-
    findall(Cell, 
            (nth1(R, Board, Row), nth1(C, Row, Cell), Key =:= R + C), 
            Diag).

% --- Проверка K элементов подряд ---
% Это "сканирование" списка
has_consecutive(List, Elem, K) :-
    scan_list(List, Elem, K, 0).

scan_list(_, _, K, CurrentCount) :- 
    CurrentCount >= K, !. % Нашли нужное количество!
scan_list([], _, _, _) :- fail.
scan_list([Head|Tail], Elem, K, CurrentCount) :-
    ( Head == Elem ->
        NewCount is CurrentCount + 1,
        (NewCount >= K -> true ; scan_list(Tail, Elem, K, NewCount))
    ;
        % Если цепочка прервалась, сбрасываем счетчик в 0
        scan_list(Tail, Elem, K, 0)
    ).