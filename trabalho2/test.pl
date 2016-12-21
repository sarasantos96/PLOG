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
	element(PositionRed,L,1),
	element(PositionYellow,L,2),
	element(PositionGreen,L,3),
	element(PositionBlue,L,4),
	validate_Pos(PositionRed,PositionYellow,PositionGreen,PositionBlue),
	count(1,L,#=,SumRed),
	labeling([maximize(SumRed)],L).

validate_Pos(PosRed,PosYellow,PosGreen,PosBlue):-
	(PosRed + 1 #= PosYellow #\/ PosRed-1 #= PosYellow) #/\
	(PosYellow +1 #= PosGreen #\/ PosYellow -1 #= PosGreen) #/\
	(PosGreen +1 #= PosBlue #\/ PosGreen -1 #= PosBlue) #/\
	(PosBlue +1 #= PosRed #\/ PosBlue -1 #= PosRed).
