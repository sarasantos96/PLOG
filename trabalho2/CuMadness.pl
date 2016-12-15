:- use_module(library(clpfd)).

cuMadness(L,N):-
	Units is (N * N * 6),
	length(L, Units),
	domain(L,1,4), Red = 1, Yellow = 2, Green = 3, Blue = 4,
	count(Red, L, #=, RedCount),
	labeling([maximize(RedCount)],L),
	write(RedCount).