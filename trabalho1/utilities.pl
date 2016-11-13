%% CLEAR SCREEN FUNCTIONS %%
clear_screen :- new_line(50), !.
new_line(Nlines) :-
	new_line(0, Nlines).
new_line(Line, MaxLines) :-
	Line < MaxLines,
	NextLine is Line + 1,
	nl,
	new_line(NextLine, MaxLines).
new_line(_,_).

%%DISPLAY PLAYERS TOKENS INFO%%
display_players_info:- 
		write('Player 1 Crabs: a A * (small, medium, big)'),nl,
		write('Player 2 Crabs: b B + (small, medium, big)').


print_separador:-
	write('***************************************************************************'),nl,nl.

list_empty([], true).
list_empty([_|_], false).