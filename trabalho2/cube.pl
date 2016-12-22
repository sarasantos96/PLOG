:- use_module(library(clpfd)).
:- include('test.pl').

cube(Cube, N):-
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
	test(F1,N),
	test(F2,N),
	test(F3,N),
	test(F4,N),
	test(F5,N),
	test(F6,N),
	labeling([maximize(SumF1)],F1),
	labeling([maximize(SumF2)],F2),
	labeling([maximize(SumF3)],F3),
	labeling([maximize(SumF4)],F4),
	labeling([maximize(SumF5)],F5),
	labeling([maximize(SumF6)],F6).