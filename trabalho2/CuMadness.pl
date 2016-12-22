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
	validate_face(F1,1,Units,N),
	validate_face(F2,1,Units,N),
	validate_face(F3,1,Units,N),
	validate_face(F4,1,Units,N),
	validate_face(F5,1,Units,N),
	validate_face(F6,1,Units,N),
	labeling([maximize(SumF1)],F1),
	labeling([maximize(SumF2)],F2),
	labeling([maximize(SumF3)],F3),
	labeling([maximize(SumF4)],F4),
	labeling([maximize(SumF5)],F5),
	labeling([maximize(SumF6)],F6),
	print_cuMadness(F1,F2,F3,F4,F5,F6,Max,Num,N),!.
	
validate_face(_, Len,Len,_).
validate_face(List,Index,Length,N):-
	get_neighbours(Index,[T,B,L,R],N,List),
	element(Index, List, P),
	validate([T,B,L,R],P),
	NewIndex is Index + 1,
	validate_face(List,NewIndex,Length,N).
	
get_neighbours(Pos,[T,B,Le,R],N,L):-
	Top is Pos - N,
	Bot is Pos + N,
	Left is Pos -1,
	Right is Pos + 1,
	(Top > 0 -> element(Top,L,T) ; T is -1),
	(Bot =< (N * N) -> element(Bot,L,B) ; B is -1),
	((Pos \== 1 ,X is Left mod N, X \== 0)-> element(Left,L,Le) ; Le is -1),
	((Y is Pos mod N, Y \== 0) -> element(Right,L,R) ; R is -1).
	
validate([T,B,L,R],P):-
	count(1,[T,B,L,R],#=,RedNeighbours),
	count(2,[T,B,L,R],#=,YellowNeighbours),
	count(3,[T,B,L,R],#=,GreenNeighbours),
	count(4,[T,B,L,R],#=,BlueNeighbours),
	(P #= 1 #=> YellowNeighbours #= 1),
	(P #= 2 #=> GreenNeighbours #= 1),
	(P #= 3 #=> BlueNeighbours #= 1),
	(P #= 4 #=> RedNeighbours #= 1).
	
%=====================================================================
%PRINT FUNCTIONS
%=====================================================================

print_cuMadness(Face1,Face2,Face3,Face4,Face5,Face6,Limits,Number,N):-
	SpaceLim is Limits +1,
	print_spaces(1,SpaceLim,1),
	print_top_lines(Number),
	print_face(Face1, 1, N, Limits,1),nl,
	print_bot_lines(Number),write(' '),print_bot_lines(Number),write(' '),print_bot_lines(Number),print_bot_lines(Number),nl,
	print_middle_faces(Face2,Face3,Face4,Face5,1,N,Limits),
	print_spaces(1,SpaceLim,6),
	print_top_lines(Number),
	print_face(Face6,1,N,Limits,6).

translate(1,' R ').
translate(2,' Y ').
translate(3,' G ').
translate(4,' B ').	
	
print_top_lines(0):- nl.
print_top_lines(N):- 
	write(' -'),
	NewN is N - 1,
	print_top_lines(NewN).
	
print_bot_lines(0).
print_bot_lines(N):- 
	write(' -'),
	NewN is N - 1,
	print_bot_lines(NewN).

print_line(_, _, 0):- write('|').
print_line(L, Index, N):-
	element(Index, L, C),
	write('|'), translate(C,V), write(V),
	NewI is Index + 1, NewN is N - 1,
	print_line(L, NewI, NewN).

print_spaces(_,_,2).
print_spaces(_,_,3).
print_spaces(_,_,4).
print_spaces(_,_,5).
print_spaces(Lim,Lim,_).
print_spaces(I,Lim,FaceNumber):-
	NextI is I + 1,
	write(' '),
	print_spaces(NextI,Lim,FaceNumber).

print_face(_, Max, _, Max,FNumber).
print_face(L, Index, N, Max,FNumber):-
	SpaceLim is Max +1,
	print_spaces(1,SpaceLim,FNumber),
	print_line(L, Index, N),nl,
	Num is N * 2,
	print_spaces(1,SpaceLim,FNumber),
	NewI is Index + N,
	(NewI \== Max -> print_bot_lines(Num),nl ; print_bot_lines(Num)),
	print_face(L, NewI, N, Max,FNumber).
	
print_middle_faces(_,_,_,_,Max, _, Max).
print_middle_faces(F2,F3,F4,F5,Index, N, Max):-
	print_line(F2, Index, N),
	print_line(F3, Index, N),
	print_line(F4, Index, N),
	print_line(F5, Index, N),nl,
	Num is N * 2,
	print_spaces(1,Max,FNumber),
	NewI is Index + N,
	print_bot_lines(Num),write(' '),print_bot_lines(Num),write(' '),print_bot_lines(Num),write(' '),print_bot_lines(Num),nl,
	print_middle_faces(F2,F3,F4,F5,NewI, N, Max).