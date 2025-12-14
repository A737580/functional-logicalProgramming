% =================================================================================
% TIC-TAC-TOE (Крестики-нолики) с AI  . ИИ  как то играет за первого игрока
% Учебный код для SWI-Prolog.
% Особенности: Настраиваемый размер (N), условие победы (K), точное форматирование,
% выбор стороны (X или O) при игре с Роботом, 
% две стратегии ИИ (для X и для O).
% =================================================================================

:- initialization(main).
:- use_module(library(random)). % Для random_member
:- use_module(library(lists)).   % Для delete/3

% ==========================================
% 1. ЗАПУСК И НАСТРОЙКА ИГРЫ
% ==========================================

main :-
    nl, writeln('--- КРЕСТИКИ-НОЛИКИ ---'),
    % 1. Выбор размера и условий победы
    read_number('Введите размер поля N (например, 3): ', N),
    read_number('Введите длину для победы K (например, 3): ', K),
    
    ( validate_settings(N, K) ->
        % 2. Выбор режима игры
        nl, writeln('Выберите режим игры:'),
        writeln('1. Человек против Человека (PvP)'),
        writeln('2. Человек против Робота (PvA)'),
        read_number('Ваш выбор (1 или 2): ', ModeNum),
        
        setup_game_mode(ModeNum, Mode, HumanSide),
        
        create_empty_board(N, Board),
        
        nl, writeln('Игра начинается! Крестики (X) всегда ходят первыми.'),
        ( Mode == pva -> 
            format('Вы играете за ~w.~n', [HumanSide]) 
        ; 
            writeln('Режим двух игроков.') 
        ),
        
        % Начинаем игру всегда с 'x'
        play(Board, N, K, x, Mode, HumanSide)
    ;
        writeln('Ошибка: N и K должны быть > 0, и K <= N.'),
        halt
    ).

% Проверка корректности настроек
validate_settings(N, K) :-
    integer(N), N > 0,
    integer(K), K > 0,
    K =< N.

% Настройка режима и стороны
setup_game_mode(1, pvp, both) :- !. 
setup_game_mode(2, pva, HumanSide) :-
    nl, writeln('За кого будете играть?'),
    writeln('1. За X (ходите первым)'),
    writeln('2. За O (ходите вторым)'),
    read_number('Ваш выбор: ', SideChoice),
    ( SideChoice = 1 -> HumanSide = x ; HumanSide = o ).
setup_game_mode(_, pvp, both) :- 
    writeln('Неверный выбор, по умолчанию PvP.').

% Создаем пустую доску
create_empty_board(N, Board) :-
    length(Row, N), 
    maplist(=(' '), Row),
    length(Board, N), 
    maplist(=(Row), Board).

% ==========================================
% 2. ИГРОВОЙ ЦИКЛ (LOOP)
% ==========================================

play(Board, N, K, Player, Mode, HumanSide) :-
    print_board(Board),         % 1. Показать поле
    
    % 2. Получить ход (от человека или робота)
    get_turn_move(Board, N, K, Player, Mode, HumanSide, Row, Col),
    
    ( is_valid_move(Board, Row, Col) ->
        % Если ход валиден:
        make_move(Board, Row, Col, Player, NewBoard),
        check_game_over(NewBoard, N, K, Player, Mode, HumanSide) 
    ;
        % Если ход неверен (только для человека):
        writeln('>>> Неверный ход (клетка занята или вне поля). Попробуйте снова.'),
        play(Board, N, K, Player, Mode, HumanSide) 
    ).

% --- ЛОГИКА ВЫБОРА ХОДА ---

% Случай 1: Режим PvA, и сейчас ход Робота (Player \== HumanSide)
get_turn_move(Board, N, K, Player, pva, HumanSide, Row, Col) :-
    Player \== HumanSide, !,
    format('~nХод Робота (~w)...~n', [Player]),
    
    % *** ВЫБОР ЛОГИКИ ИИ ***
    ( Player == x -> 
        % Робот ходит первым (x) -> АГРЕССИВНАЯ СТРАТЕГИЯ
        choose_ai_move_first(Board, N, K, Player, Row, Col)
    ;
        % Робот ходит вторым (o) -> ЗАЩИТНАЯ СТРАТЕГИЯ
        choose_ai_move_second(Board, N, K, Player, Row, Col)
    ),
    
    format('Робот выбрал: строка ~w, столбец ~w~n', [Row, Col]),
    true. 

% Случай 2: Все остальные (Ход человека)
get_turn_move(_, _, _, Player, _, _, Row, Col) :-
    ask_move(Row, Col, Player).


% Логика окончания игры 
check_game_over(Board, _, K, Player, _, _) :-
    check_winner(Board, K, Player), !, % Если есть победитель
    print_board(Board),
    format('>>> ИГРОК ~w ПОБЕДИЛ! ПОЗДРАВЛЯЕМ!~n', [Player]).

check_game_over(Board, _, _, _, _, _) :-
    is_board_full(Board), !,           % Если доска полная
    print_board(Board),
    writeln('>>> НИЧЬЯ! Больше нет ходов.').

check_game_over(Board, N, K, Player, Mode, HumanSide) :- 
    % Если игра не окончена, меняем игрока и продолжаем
    switch_player(Player, NextPlayer),
    play(Board, N, K, NextPlayer, Mode, HumanSide). 

% Ввод хода с защитой от ошибок (для Человека)
ask_move(Row, Col, Player) :-
    nl, format('Ваш ход [~w].~n', [Player]),
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
% 3. ЛОГИКА ИСКУССТВЕННОГО ИНТЕЛЛЕКТА (AI)
% ==========================================

% --- СТРАТЕГИЯ ИИ: ХОДИТ ПЕРВЫМ (x) ---
choose_ai_move_first(Board, N, K, Player, Row, Col) :-
    % 1. Победить сейчас
    try_win_move(Board, N, K, Player, Row, Col), !.

choose_ai_move_first(Board, N, K, Player, Row, Col) :-
    % 2. Блокировать победу соперника
    switch_player(Player, Enemy),
    try_block_move(Board, N, K, Enemy, Row, Col), !.

choose_ai_move_first(Board, N, _, _, Row, Col) :-
    % 3. Занять центр (только если это первый ход робота)
    is_board_empty(Board),
    try_center_move(Board, N, Row, Col), !.

choose_ai_move_first(Board, N, K, Player, Row, Col) :-
    % 4. Агрессивный ход (занять нецентральный, но стратегический ход)
    try_aggressive_move(Board, N, K, Player, Row, Col), !.

choose_ai_move_first(Board, N, _, _, Row, Col) :-
    % 5. Случайный ход
    try_random_move(Board, N, Row, Col).


% --- СТРАТЕГИЯ ИИ: ХОДИТ ВТОРЫМ (o) --- (Ваша старая, проверенная логика)
choose_ai_move_second(Board, N, K, Player, Row, Col) :-
    % 1. Победить сейчас
    try_win_move(Board, N, K, Player, Row, Col), !.

choose_ai_move_second(Board, N, K, Player, Row, Col) :-
    % 2. Блокировать победу соперника
    switch_player(Player, Enemy),
    try_block_move(Board, N, K, Enemy, Row, Col), !.

choose_ai_move_second(Board, N, _, _, Row, Col) :-
    % 3. Занять центр 
    try_center_move(Board, N, Row, Col), !.

choose_ai_move_second(Board, N, _, _, Row, Col) :-
    % 4. Случайный ход
    try_random_move(Board, N, Row, Col).


% --- ВСПОМОГАТЕЛЬНЫЕ ПРЕДИКАТЫ AI ---

is_board_empty(Board) :-
    \+ (member(Row, Board), member(Cell, Row), Cell \= ' ').

% АГРЕССИВНЫЙ ХОД (Для 'x')
% Ищет ход, который не является центром, чтобы развивать игру по углам/краям.
try_aggressive_move(Board, N, _, _, Row, Col) :-
    % 1. Находим все валидные ходы
    all_valid_moves(Board, N, Moves),
    
    % 2. Находим координаты центра
    Center is (N // 2) + 1,
    CenterMove = Center-Center,
    
    % 3. Фильтруем список ходов, чтобы исключить центр
    delete(Moves, CenterMove, NonCenterMoves), 
    
    ( NonCenterMoves = [] ->
        % Если остался только центр (или доска полна), берем любой ход из Moves.
        Moves = [Row-Col|_]
    ; 
        % Иначе, берем случайный ход из НЕЦЕНТРАЛЬНЫХ
        random_member(Row-Col, NonCenterMoves)
    ).

% --- 1. Попытка победить ---
try_win_move(Board, N, K, Player, Row, Col) :-
    all_valid_moves(Board, N, Moves),
    member(Row-Col, Moves), 
    make_move(Board, Row, Col, Player, TestBoard),
    check_winner(TestBoard, K, Player).

% --- 2. Попытка блокировать ---
try_block_move(Board, N, K, Enemy, Row, Col) :-
    all_valid_moves(Board, N, Moves),
    member(Row-Col, Moves),
    make_move(Board, Row, Col, Enemy, TestBoard),
    check_winner(TestBoard, K, Enemy).

% --- 3. Попытка занять центр ---
try_center_move(Board, N, Row, Col) :-
    Center is (N // 2) + 1,
    is_valid_move(Board, Center, Center),
    Row = Center, Col = Center.

% --- 4. Случайный ход ---
try_random_move(Board, N, Row, Col) :-
    all_valid_moves(Board, N, Moves),
    random_member(Row-Col, Moves).

% Генератор всех свободных клеток (Row-Col)
all_valid_moves(Board, N, Moves) :-
    findall(R-C, 
            (between(1, N, R), between(1, N, C), is_valid_move(Board, R, C)), 
            Moves).

% ==========================================
% 4. ОТРИСОВКА (FORMATTING)
% ==========================================

print_board(Board) :-
    nl, length(Board, N),
    
    % --- РАСЧЕТ ОТСТУПОВ ---
    N_Int is round(N), 
    term_to_atom(N_Int, AtomN),
    atom_length(AtomN, MaxIdxLen),
    ColWidth is MaxIdxLen + 2,
    Indent   is MaxIdxLen + 1,
    
    % --- ВЫВОД ---
    print_header(1, N, ColWidth, Indent), 
    print_separator(N, ColWidth, Indent),
    print_rows(Board, 1, N, MaxIdxLen, ColWidth, Indent),
    print_separator(N, ColWidth, Indent), 
    nl.

print_header(I, N, _, _) :- I > N, nl, !.
print_header(1, N, Width, Indent) :-
    tab(Indent), write(' '), write(' '),                     
    print_centered(1, Width),       
    Next is 1 + 1,
    print_header(Next, N, Width, Indent).
print_header(I, N, Width, Indent) :-
    I > 1,
    write(' '),                     
    print_centered(I, Width),
    Next is I + 1,
    print_header(Next, N, Width, Indent).

print_separator(N, Width, BaseIndent) :-
    RealIndent is BaseIndent + 2,   
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

print_rows([], _, _, _, _, _).
print_rows([Row|Rest], RowNum, N, MaxIdxLen, Width, Indent) :-
    print_row_index(RowNum, MaxIdxLen),
    print_row_cells(Row, Width),
    nl,
    ( Rest \= [] -> print_separator(N, Width, Indent) ; true ),
    NextRow is RowNum + 1,
    print_rows(Rest, NextRow, N, MaxIdxLen, Width, Indent).

print_row_index(Num, MaxLen) :-
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

print_centered(Content, Width) :-
    ( number(Content) -> 
        Num is round(Content),
        term_to_atom(Num, Atom) 
    ; Atom = Content ),
    atom_length(Atom, Len),
    PadLeft is Width // 2,
    PadRight is Width - PadLeft - Len,
    ( PadRight < 0 -> R = 0 ; R = PadRight ),
    format('~*c~w~*c', [PadLeft, 32, Atom, R, 32]).

% ==========================================
% 5. ЛОГИКА ИЗМЕНЕНИЯ ДОСКИ И ПРОВЕРКИ
% ==========================================

is_valid_move(Board, Row, Col) :-
    Row > 0, Col > 0,
    % Убедимся, что Row и Col инстантиированы, прежде чем использовать их 
    % для доступа к элементам списка, хотя findall это уже гарантирует
    nonvar(Row), nonvar(Col),
    nth1(Row, Board, BoardRow),    
    nth1(Col, BoardRow, Cell),     
    Cell == ' '.                   

make_move(Board, Row, Col, Player, NewBoard) :-
    nth1(Row, Board, OldRow),
    replace_in_list(OldRow, Col, Player, NewRow),
    replace_in_list(Board, Row, NewRow, NewBoard).

replace_in_list([_|T], 1, Val, [Val|T]).
replace_in_list([H|T], I, Val, [H|Rest]) :-
    I > 1, NextI is I - 1, replace_in_list(T, NextI, Val, Rest).

is_board_full(Board) :-
    \+ (member(Row, Board), member(' ', Row)).

% ==========================================
% 6. ПРОВЕРКА ПОБЕДЫ
% ==========================================

check_winner(Board, K, Player) :-
    check_rows(Board, K, Player);
    check_columns(Board, K, Player);
    check_diagonals(Board, K, Player).

check_rows(Board, K, Player) :-
    member(Row, Board),
    has_consecutive(Row, Player, K).

check_columns(Board, K, Player) :-
    length(Board, N),
    between(1, N, ColIdx),
    extract_column(Board, ColIdx, ColumnList),
    has_consecutive(ColumnList, Player, K).

extract_column(Board, ColIdx, Column) :-
    maplist(nth1(ColIdx), Board, Column).

check_diagonals(Board, K, Player) :-
    collect_all_diagonals(Board, Diagonals),
    member(Diag, Diagonals),
    has_consecutive(Diag, Player, K).

collect_all_diagonals(Board, AllDiags) :-
    length(Board, N),
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
    findall(Cell, (nth1(R, Board, Row), nth1(C, Row, Cell), Key =:= R - C), Diag).
construct_diag(Board, Key, nesw, Diag) :-
    findall(Cell, (nth1(R, Board, Row), nth1(C, Row, Cell), Key =:= R + C), Diag).

has_consecutive(List, Elem, K) :-
    scan_list(List, Elem, K, 0).

scan_list(_, _, K, CurrentCount) :- CurrentCount >= K, !.
scan_list([], _, _, _) :- fail.
scan_list([Head|Tail], Elem, K, CurrentCount) :-
    ( Head == Elem ->
        NewCount is CurrentCount + 1,
        (NewCount >= K -> true ; scan_list(Tail, Elem, K, NewCount))
    ;
        scan_list(Tail, Elem, K, 0)
    ).