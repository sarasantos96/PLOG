
print_face([],N).
print_face([Face|Fs],N):-
	print_limit(N),
	%print_line(Face),nl,
	print_limit(N).
	
print_line([]).
print_line([L|Ls]):-
	write(' | '),
	write(L),
	print_line(Ls).
	
print_limit(0).	
print_limit(N):-
	write(' - '),
	N1 is N - 1,
	print_limit(N1).
	