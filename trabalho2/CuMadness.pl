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
	labeling([maximize(SumF6)],F6).
	
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