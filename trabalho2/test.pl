:- use_module(library(clpfd)).
:- use_module(library(lists)).

%Every red peg must be next to exactly one yellow peg, no more no less
%Every yellow peg must be next to exactly one green, no more no less
%Every green peg must be next to exactly one blue, no more no less
%Every blue peg must be next to exactly one red, no more no less

%Red = 1, Yellow = 2, Green = 3, Blue = 4,
	
test(L,N):-
	Len is N * N,
	length(L,Len),
	domain(L,1,4),
	Limit is Len +1,
	validate_face(L,1,Len,N),
	count(1,L,#=,SumRed),
	labeling([maximize(SumRed)],L).
	
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



	