% Clears the screen
clear_screen :- new_line(50), !.    
new_line(Nlines) :-
	new_line(0, Nlines).
new_line(Line, MaxLines) :-
	Line < MaxLines,
	NextLine is Line + 1,
	nl,
	new_line(NextLine, MaxLines).
new_line(_,_).

% Displays Player Crabs
display_players_info:- 
		write('Player 1 Crabs: a A * (small, medium, big)'),nl,
		write('Player 2 Crabs: b B + (small, medium, big)').

% Prints the separation between turns
print_separador:-
	write('***************************************************************************'),nl,nl.

% Checks if a given list is empty
list_empty([], true).
list_empty([_|_], false).

% Displays the the available moves lists
display_available_moves([],[],N).
display_available_moves([AR|ARs],[AC|ACs],N):-
	N1 is N + 1,
	write(N1),
	write('-  Row: '), write(AR),
	write('  Column: '), write(AC),nl,
	display_available_moves(ARs,ACs,N1).