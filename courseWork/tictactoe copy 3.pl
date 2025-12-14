% tictactoe.pl
% Крестики-нолики с точным форматированием под SWI-Prolog.

:- initialization(main).

% --- main (вход) ---
main :-
    writeln('Добро пожаловать в Крестики-нолики!'),
    write('Введите размер поля N (например, 3): '), read(N_Input),
    write('Введите длину последовательности для победы K (например, 3): '), read(K_Input),
    
    % АГРЕССИВНОЕ ИСПРАВЛЕНИЕ: Гарантируем, что N и K — целые.
    ( number(N_Input) -> N is round(N_Input) ; fail ),
    ( number(K_Input) -> K is round(K_Input) ; fail ),
    
    ( integer(N), N > 0, integer(K), K > 0, K =< N ->
        empty_board(N, Board),
        play(Board, N, K, x)
    ;   writeln('N и K должны быть положительными целыми числами, K <= N.'),
        writeln('Убедитесь, что вы вводите целые числа.'),
        halt
    ).

% --- игровой цикл ---
play(Board, N, K, Player) :-
    print_board(Board),
    format('Ход игрока ~w.~n', [Player]),
    read_move(Row, Col),
    ( valid_move(Board, Row, Col) ->
        make_move(Board, Row, Col, Player, NewBoard),
        ( winner(NewBoard, K, Player) ->
            print_board(NewBoard),
            format('Игрок ~w победил!~n', [Player]),
            !
        ; full_board(NewBoard) ->
            print_board(NewBoard),
            writeln('Ничья!'),
            !
        ; switch(Player, Next),
            play(NewBoard, N, K, Next)
        )
    ; writeln('Неверный ход! Попробуйте снова.'),
      play(Board, N, K, Player)
    ).

% --- ввод хода ---
read_move(Row, Col) :-
    write('Введите номер строки: '), read(Row_Input),
    write('Введите номер столбца: '), read(Col_Input),
    % АГРЕССИВНОЕ ИСПРАВЛЕНИЕ: Гарантируем, что ввод хода — целые числа.
    ( number(Row_Input) -> Row is round(Row_Input) ; fail ),
    ( number(Col_Input) -> Col is round(Col_Input) ; fail ).

% --- создание пустой доски ---
empty_board(N, Board) :-
    length(Row, N), maplist(=(' '), Row),
    length(Board, N), maplist(=(Row), Board).

% ==========================================
% ЛОГИКА ОТРИСОВКИ (FORMATTING)
% ==========================================

print_board(Board) :-
    nl,
    length(Board, N),
    
    % 1. Вычисляем параметры форматирования
    N_Int is round(N), % Используем целое N
    term_to_atom(N_Int, AtomN),
    atom_length(AtomN, MaxIdxLen),   % Длина самого длинного индекса
    ColWidth is MaxIdxLen + 2,       % Ширина столбца
    Indent is MaxIdxLen + 1,         % Отступ слева для вертикальных индексов
    
    % НОВОЕ: Расчет сдвига для горизонтальных индексов
    HorizontalShift is MaxIdxLen - 1, 

    % 2. Печать заголовков столбцов (Передаем HorizontalShift)
    print_header(1, N_Int, ColWidth, Indent, HorizontalShift),
    
    % 3. Печать верхнего разделителя
    print_separator(N_Int, ColWidth, Indent),

    % 4. Печать строк с данными
    print_rows(Board, 1, MaxIdxLen, ColWidth).

% --- Печать заголовков (индексы столбцов) ---
print_header(Current, N, _, _, _) :- Current > N, nl, !.
print_header(1, N, ColWidth, Indent, Shift) :-
    tab(Indent),
    write(' '), 
    write(' '), % Сдвиг вправо на 1 символ (как и в последней версии)
    % Используем print_shifted_centered
    print_shifted_centered(1, ColWidth, Shift),
    Next is 1 + 1,
    print_header(Next, N, ColWidth, Indent, Shift).
print_header(Current, N, ColWidth, Indent, Shift) :-
    Current > 1,
    write(' '), % Пробел над разделителем столбцов (скорректированный отступ)
    % Используем print_shifted_centered
    print_shifted_centered(Current, ColWidth, Shift),
    Next is Current + 1,
    print_header(Next, N, ColWidth, Indent, Shift).

% --- Печать горизонтального разделителя (+---+---+) ---
print_separator(N, ColWidth, BaseIndent) :-
    % Сдвиг разделителя вправо на 2 символа.
    NewIndent is BaseIndent + 2,
    tab(NewIndent),              
    write('+'),                  
    print_sep_cells(N, ColWidth),
    nl.

print_sep_cells(0, _) :- !.
print_sep_cells(N, ColWidth) :-
    N > 0,
    print_dashes(ColWidth),
    write('+'),
    N1 is N - 1,
    print_sep_cells(N1, ColWidth).

print_dashes(0) :- !.
print_dashes(K) :- write('-'), K1 is K - 1, print_dashes(K1).

% --- Печать строк доски (обертка) ---
print_rows(Board, StartIdx, MaxIdxLen, ColWidth) :-
    length(Board, N),
    Indent is MaxIdxLen + 1,
    
    print_rows_loop(Board, StartIdx, MaxIdxLen, ColWidth, N, Indent),
    
    % Закрывающий разделитель
    print_separator(N, ColWidth, Indent).

% --- Печать строк доски (рекурсивный цикл) ---
print_rows_loop([], _, _, _, _, _).
print_rows_loop([Row|Rs], RowNum, MaxIdxLen, ColWidth, N, Indent) :-
    % 1. Печать индекса строки: 
    
    RNum_Int is round(RowNum),
    term_to_atom(RNum_Int, RNum_Atom),
    atom_length(RNum_Atom, RNum_Len),
    
    PadLeft is MaxIdxLen - RNum_Len,
    ( PadLeft < 0 -> PadFinal = 0 ; PadFinal = PadLeft ),
    
    % Печатаем пробелы (PadFinal), затем целое число (RNum_Atom), затем ' |'
    format('~*c~w |', [PadFinal, 32, RNum_Atom]), 
    
    % 2. Печать содержимого строки
    print_row_cells(Row, ColWidth),
    nl,
    
    % 3. Печать разделителя между строками (если это не последняя строка)
    ( Rs \= [] -> print_separator(N, ColWidth, Indent) ; true ), 
    
    Next is RNum_Int + 1, % Инкрементируем целое число
    print_rows_loop(Rs, Next, MaxIdxLen, ColWidth, N, Indent).

% --- Печать ячеек одной строки ---
print_row_cells([], _).
print_row_cells([Cell|Cs], ColWidth) :-
    % Важно: Ячейки X/O остаются центрированными, используем 0 сдвиг.
    print_shifted_centered(Cell, ColWidth, 0),
    write('|'),
    print_row_cells(Cs, ColWidth).

% --- Выравнивание с принудительным сдвигом ---
print_shifted_centered(Content, Width, Shift) :-
    % Гарантируем, что числа преобразуются в целые и в атом.
    ( number(Content) -> 
        Num is round(Content),
        term_to_atom(Num, A)
    ; A = Content ),
    atom_length(A, Len),
    
    % 1. Исходный левый отступ для центрирования
    PadL_Center is Width // 2,
    
    % 2. Левый отступ с учетом сдвига влево (Shift)
    PadL is PadL_Center - Shift,
    ( PadL < 0 -> PadL_Final = 0 ; PadL_Final = PadL ),
    
    % 3. Правый отступ рассчитывается исходя из общей ширины
    PadR is Width - PadL_Final - Len,
    ( PadR < 0 -> PadRFinal = 0 ; PadRFinal = PadR ),
    
    format('~*c~w~*c', [PadL_Final, 32, A, PadRFinal, 32]). % 32 - код пробела


% ==========================================
% ЛОГИКА ИГРЫ (ПРОВЕРКИ)
% ==========================================

valid_move(Board, Row, Col) :-
    integer(Row), integer(Col),
    Row > 0, Col > 0,
    nth1(Row, Board, BoardRow),
    nth1(Col, BoardRow, Cell),
    Cell == ' '.

make_move(Board, Row, Col, Player, NewBoard) :-
    nth1(Row, Board, OldRow),
    replace_nth(OldRow, Col, Player, NewRow),
    replace_nth(Board, Row, NewRow, NewBoard).

replace_nth([_|T], 1, X, [X|T]).
replace_nth([H|T], I, X, [H|R]) :-
    I > 1, I1 is I - 1, replace_nth(T, I1, X, R).

switch(x, o).
switch(o, x).

full_board(Board) :-
    \+ ( member(Row, Board), member(' ', Row) ).

winner(Board, K, Player) :-
    ( row_win(Board, K, Player)
    ; column_win(Board, K, Player)
    ; diagonal_win(Board, K, Player)
    ).

row_win(Board, K, Player) :-
    member(Row, Board),
    consecutive(Row, Player, K).

column_win(Board, K, Player) :-
    length(Board, N),
    between(1, N, C),
    column(Board, C, Col),
    consecutive(Col, Player, K).

column(Board, ColIdx, Column) :-
    maplist(nth1(ColIdx), Board, Column).

diagonal_win(Board, K, Player) :-
    all_diagonals(Board, DiagsNWSE, DiagsNESW),
    ( member(D, DiagsNWSE), consecutive(D, Player, K)
    ; member(D2, DiagsNESW), consecutive(D2, Player, K)
    ).

all_diagonals(Board, DiagsNWSE, DiagsNESW) :-
    length(Board, N),
    Temp is N - 1,
    LBound is -Temp,
    UBound is Temp,
    findall(D,
            ( between(LBound, UBound, Key),
              diagonal_by_key(Board, Key, nwse, D),
              D \= []
            ),
            DiagsNWSE),
    MaxKey is 2 * N,
    findall(D2,
            ( between(2, MaxKey, Key2),
              diagonal_by_key(Board, Key2, nesw, D2),
              D2 \= []
            ),
            DiagsNESW).

diagonal_by_key(Board, Key, nwse, Diag) :-
    findall(Cell,
            ( nth1(I, Board, Row),
              nth1(J, Row, Cell),
              K is I - J, K =:= Key
            ),
            Diag).
diagonal_by_key(Board, Key, nesw, Diag) :-
    findall(Cell,
            ( nth1(I, Board, Row),
              nth1(J, Row, Cell),
              K is I + J, K =:= Key
            ),
            Diag).

consecutive(List, Elem, K) :-
    K > 0,
    consecutive_scan(List, Elem, K, 0).

consecutive_scan(_, _, K, Count) :-
    Count >= K, !.
consecutive_scan([], _, _, _) :- fail.
consecutive_scan([H|T], Elem, K, Count) :-
    ( H == Elem ->
        Count1 is Count + 1,
        ( Count1 >= K -> true ; consecutive_scan(T, Elem, K, Count1) )
    ; consecutive_scan(T, Elem, K, 0)
    ).