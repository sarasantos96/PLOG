:- use_module(library(clpfd)).
:- use_module(library(lists)).

%Every red peg must be next to exactly one yellow peg, no more no less
%Every yellow peg must be next to exactly one green, no more no less
%Every green peg must be next to exactly one blue, no more no less
%Every blue peg must be next to exactly one red, no more no less

%The colours of its other neighbours do not matter

%Red = 1, Yellow = 2, Green = 3, Blue = 4,
cuMadness(Cube,N):-
	build_cube(Cube,N).

build_cube(Cube,N):-
	Cube = [F1, F2, F3, F4, F5, F6],
	Units is N * N,
	Max is Units + 1,
	Num is N * 2,
	length(F1, Units),
	length(F2, Units),
	length(F3, Units),
	length(F4, Units),
	length(F5, Units),
	length(F6, Units),
	domain(F1,1,4),
	domain(F2,1,4),
	domain(F3,1,4),
	domain(F4,1,4),
	domain(F5,1,4),
	domain(F6,1,4),
	count(1,F1,#=,SumF1),
	count(1,F2,#=,SumF2),
	count(1,F3,#=,SumF3),
	count(1,F4,#=,SumF4),
	count(1,F5,#=,SumF5),
	count(1,F6,#=,SumF6),
	validate_face_1(F1,1,Units,N,[F2,F3,F4,F5]),
	validate_face_2(F2,1,Units,N,[F1,F3,F5,F6]),
	validate_face_3(F3,1,Units,N,[F1,F2,F4,F6]),
	validate_face_4(F4,1,Units,N,[F1,F3,F5,F6]),
	validate_face_5(F5,1,Units,N,[F1,F2,F4,F6]),
	validate_face_6(F6,1,Units,N,[F2,F3,F4,F5]),
	labeling([maximize(SumF1)],F1),
	labeling([maximize(SumF2)],F2),
	labeling([maximize(SumF3)],F3),
	labeling([maximize(SumF4)],F4),
	labeling([maximize(SumF5)],F5),
	labeling([maximize(SumF6)],F6),
	print_top_lines(Num),
	print_face(F4, 1, N, Max),!.

validate_face_1(_, Len,Len,_,_).
validate_face_1(List,Index,Length,N,[F2,F3,F4,F5]):-
	get_neighbours_1(Index,[T,B,L,R],N,List, [F2,F3,F4,F5]),
	element(Index, List, P),
	validate([T,B,L,R],P),
	NewIndex is Index + 1,
	validate_face_1(List,NewIndex,Length,N,[F2,F3,F4,F5]).

get_neighbours_1(Pos,[T,B,Le,R],N,L, [F2,F3,F4,F5]):-
	Top is Pos - N,
	Bot is Pos + N,
	Left is Pos -1,
	Right is Pos + 1,
	(Top > 0 -> element(Top,L,T) ; (Pos == 1 -> element(3, F5, T) ; (Pos == 2 -> element(2, F5, T) ; (Pos == 3 , element(1, F5, T))))),
	(Bot =< (N * N) -> element(Bot,L,B) ; (Pos == 7 -> element(1, F3, B) ; (Pos == 8 -> element(2, F3, B) ; (Pos == 9 , element(3, F3, B))))),
	((Pos \== 1 ,X is Left mod N, X \== 0)-> element(Left,L,Le) ; (Pos == 1 -> element(1, F2, Le) ; (Pos == 4 -> element(2, F2, Le) ; (Pos == 7 , element(3, F2, Le))))),
	((Y is Pos mod N, Y \== 0) -> element(Right,L,R) ; (Pos == 3 -> element(3,F4,R) ; (Pos == 6 -> element(2,F4,R) ; (Pos == 9 , element(1,F4,R))))).	

validate_face_2(_, Len,Len,_,_).
validate_face_2(List,Index,Length,N,[F1,F3,F5,F6]):-
	get_neighbours_2(Index,[T,B,L,R],N,List,[F1,F3,F5,F6]),
	element(Index, List, P),
	validate([T,B,L,R],P),
	NewIndex is Index + 1,
	validate_face_2(List,NewIndex,Length,N,[F1,F3,F5,F6]).

get_neighbours_2(Pos,[T,B,Le,R],N,L,[F1,F3,F5,F6]):-
	Top is Pos - N,
	Bot is Pos + N,
	Left is Pos -1,
	Right is Pos + 1,
	(Top > 0 -> element(Top,L,T) ; (Pos == 1 -> element(1, F1, T) ; (Pos == 2 -> element(4, F1, T) ; (Pos == 3 , element(7, F1, T))))),
	(Bot =< (N * N) -> element(Bot,L,B) ; (Pos == 7 -> element(7, F6, B) ; (Pos == 8 -> element(4, F6, B) ; (Pos == 9 , element(1, F6, B))))),
	((Pos \== 1 ,X is Left mod N, X \== 0)-> element(Left,L,Le) ; (Pos == 1 -> element(3, F5, Le) ; (Pos == 4 -> element(6, F5, Le) ; (Pos == 7 , element(9, F5, Le))))),
	((Y is Pos mod N, Y \== 0) -> element(Right,L,R) ; (Pos == 3 -> element(1, F3, R) ; (Pos == 6 -> element(4, F3, R) ; (Pos == 9 , element(7, F3, R))))).

validate_face_3(_, Len,Len,_,_).
validate_face_3(List,Index,Length,N,[F1,F2,F4,F6]):-
	get_neighbours_3(Index,[T,B,L,R],N,List,[F1,F2,F4,F6]),
	element(Index, List, P),
	validate([T,B,L,R],P),
	NewIndex is Index + 1,
	validate_face_3(List,NewIndex,Length,N,[F1,F2,F4,F6]).

get_neighbours_3(Pos,[T,B,Le,R],N,L,[F1,F2,F4,F6]):-
	Top is Pos - N,
	Bot is Pos + N,
	Left is Pos -1,
	Right is Pos + 1,
	(Top > 0 -> element(Top,L,T) ; (Pos == 1 -> element(7, F1, T) ; (Pos == 2 -> element(8, F1, T) ; (Pos == 3 , element(9, F1, T))))),
	(Bot =< (N * N) -> element(Bot,L,B) ; (Pos == 7 -> element(1, F6, B) ; (Pos == 8 -> element(2, F6, B) ; (Pos == 9 , element(3, F6, B))))),
	((Pos \== 1 ,X is Left mod N, X \== 0)-> element(Left,L,Le) ; (Pos == 1 -> element(3, F2, Le) ; (Pos == 4 -> element(6, F2, Le) ; (Pos == 7 , element(9, F2, Le))))),
	((Y is Pos mod N, Y \== 0) -> element(Right,L,R) ; (Pos == 3 -> element(1, F4, R) ; (Pos == 6 -> element(4, F4, R) ; (Pos == 9 , element(7, F4, R))))).	

validate_face_4(_, Len,Len,_,_).
validate_face_4(List,Index,Length,N,[F1,F3,F5,F6]):-
	get_neighbours_4(Index,[T,B,L,R],N,List,[F1,F3,F5,F6]),
	element(Index, List, P),
	validate([T,B,L,R],P),
	NewIndex is Index + 1,
	validate_face_4(List,NewIndex,Length,N,[F1,F3,F5,F6]).

get_neighbours_4(Pos,[T,B,Le,R],N,L,[F1,F3,F5,F6]):-
	Top is Pos - N,
	Bot is Pos + N,
	Left is Pos -1,
	Right is Pos + 1,
	(Top > 0 -> element(Top,L,T) ; (Pos == 1 -> element(9, F1, T) ; (Pos == 2 -> element(6, F1, T) ; (Pos == 3 , element(3, F1, T))))),
	(Bot =< (N * N) -> element(Bot,L,B) ; (Pos == 7 -> element(3, F6, B) ; (Pos == 8 -> element(6, F6, B) ; (Pos == 9 , element(9, F6, B))))),
	((Pos \== 1 ,X is Left mod N, X \== 0)-> element(Left,L,Le) ; (Pos == 1 -> element(3, F3, Le) ; (Pos == 4 -> element(6, F3, Le) ; (Pos == 7 , element(9, F3, Le))))),
	((Y is Pos mod N, Y \== 0) -> element(Right,L,R) ; (Pos == 3 -> element(1, F5, R) ; (Pos == 6 -> element(4, F5, R) ; (Pos == 9 , element(7, F5, R))))).	

validate_face_5(_, Len,Len,_,_).
validate_face_5(List,Index,Length,N,[F1,F2,F4,F6]):-
	get_neighbours_5(Index,[T,B,L,R],N,List,[F1,F2,F4,F6]),
	element(Index, List, P),
	validate([T,B,L,R],P),
	NewIndex is Index + 1,
	validate_face_5(List,NewIndex,Length,N,[F1,F2,F4,F6]).

get_neighbours_5(Pos,[T,B,Le,R],N,L,[F1,F2,F4,F6]):-
	Top is Pos - N,
	Bot is Pos + N,
	Left is Pos -1,
	Right is Pos + 1,
	(Top > 0 -> element(Top,L,T) ; (Pos == 1 -> element(3, F1, T) ; (Pos == 2 -> element(2, F1, T) ; (Pos == 3 , element(1, F1, T))))),
	(Bot =< (N * N) -> element(Bot,L,B) ; (Pos == 7 -> element(9, F6, B) ; (Pos == 8 -> element(8, F6, B) ; (Pos == 9 , element(7, F6, B))))),
	((Pos \== 1 ,X is Left mod N, X \== 0)-> element(Left,L,Le) ; (Pos == 1 -> element(3, F4, Le) ; (Pos == 4 -> element(6, F4, Le) ; (Pos == 7 , element(9, F4, Le))))),
	((Y is Pos mod N, Y \== 0) -> element(Right,L,R) ; (Pos == 3 -> element(1, F2, R) ; (Pos == 6 -> element(4, F2, R) ; (Pos == 9 , element(7, F2, R))))).	

validate_face_6(_, Len,Len,_,_).
validate_face_6(List,Index,Length,N,[F2,F3,F4,F5]):-
	get_neighbours_6(Index,[T,B,L,R],N,List,[F2,F3,F4,F5]),
	element(Index, List, P),
	validate([T,B,L,R],P),
	NewIndex is Index + 1,
	validate_face_6(List,NewIndex,Length,N, [F2,F3,F4,F5]).

get_neighbours_6(Pos,[T,B,Le,R],N,L,[F2,F3,F4,F5]):-
	Top is Pos - N,
	Bot is Pos + N,
	Left is Pos -1,
	Right is Pos + 1,
	(Top > 0 -> element(Top,L,T) ; (Pos == 1 -> element(7, F3, T) ; (Pos == 2 -> element(8, F3, T) ; (Pos == 3 , element(9, F3, T))))),
	(Bot =< (N * N) -> element(Bot,L,B) ; (Pos == 7 -> element(9, F5, B) ; (Pos == 8 -> element(8, F5, B) ; (Pos == 9 , element(7, F5, B))))),
	((Pos \== 1 ,X is Left mod N, X \== 0)-> element(Left,L,Le) ; (Pos == 1 -> element(9, F2, Le) ; (Pos == 4 -> element(8, F2, Le) ; (Pos == 7 , element(7, F2, Le))))),
	((Y is Pos mod N, Y \== 0) -> element(Right,L,R) ; (Pos == 3 -> element(7, F4, R) ; (Pos == 6 -> element(8, F4, R) ; (Pos == 9 , element(9, F4, R))))).		
	
validate([T,B,L,R],P):-
	count(1,[T,B,L,R],#=,RedNeighbours),
	count(2,[T,B,L,R],#=,YellowNeighbours),
	count(3,[T,B,L,R],#=,GreenNeighbours),
	count(4,[T,B,L,R],#=,BlueNeighbours),
	(P #= 1 #=> YellowNeighbours #= 1),
	(P #= 2 #=> GreenNeighbours #= 1),
	(P #= 3 #=> BlueNeighbours #= 1),
	(P #= 4 #=> RedNeighbours #= 1).
	
translate(1,' R ').
translate(2,' Y ').
translate(3,' G ').
translate(4,' B ').		
	
print_top_lines(0):- nl.
print_top_lines(N):- 
	write(' -'),
	NewN is N - 1,
	print_top_lines(NewN).
	
print_bot_lines(0):- nl.
print_bot_lines(N):- 
	write(' -'),
	NewN is N - 1,
	print_bot_lines(NewN).

print_line(_, _, 0):- write('|'), nl.
print_line(L, Index, N):-
	element(Index, L, C),
	write('|'), translate(C,V), write(V),
	NewI is Index + 1, NewN is N - 1,
	print_line(L, NewI, NewN).

print_face(_, Max, _, Max).
print_face(L, Index, N, Max):-
	print_line(L, Index, N),
	Num is N * 2,
	print_bot_lines(Num),
	NewI is Index + N,
	print_cube(L, NewI, N, Max).