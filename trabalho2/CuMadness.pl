:- use_module(library(clpfd)).
:- use_module(library(lists)).

%Every red peg must be next to exactly one yellow peg, no more no less
%Every yellow peg must be next to exactly one green, no more no less
%Every green peg must be next to exactly one blue, no more no less
%Every blue peg must be next to exactly one red, no more no less

%The colours of its other neighbours do not matter

cuMadness(Cube, Side):-
	Units is (Side * Side),
	length(Cube, Units),
	domain(Cube, 1, 4), Red = 1, Yellow = 2, Green = 3, Blue = 4,
	count(Red, Cube, #=, RedCount),
	labeling([maximize(RedCount)],Cube).
	
%declared in sictus manual
exactly(_, [], 0). 
exactly(Color, [L|Ls], N):-
	Color #= L #<=> A,
	N #= M+A,
	exactly(Color, Ls, M).