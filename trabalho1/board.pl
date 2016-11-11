:-include('utilities.pl').


empty_board(Board):-
	Board=	[[[.],[.],[.]],
			[[.],[.],[.],[.]],
			[[.],[.],[.],[.],[.]],
			[[.],[.],[.],[.]],
			[[.],[.],[.]]].

initial_board(Board):-
	Board = [[[cp1,cp2,.],[cg1,.],[cm1,.]],
			[[cp2,.],[cg1,.],[cg2,.],[cm2,.]],
			[[cg2,.],[cm1,.],[cp1,.],[.],[cp2,.]],
			[[cm2,.],[cg1,.],[cg2,.],[cm2,.]],
			[[cp1,.],[cp2,.],[cm1,.]]].

updateBoard(BoardO,BoardU,OldR,OldC,NewR, NewC,[OldP|OldPs]):-
	Row1 is OldR - 1,
	Col1 is OldC -1,
	append(OldPs,[],NEWPOS),
	replace(BoardO,Row1,Col1,NEWPOS,Temp1),
	nth1(NewR, Temp1, NewRowList ),
	nth1(NewC, NewRowList, NP),
	append([OldP],NP, NewPosition),
	Row2 is NewR - 1,
	Col2 is NewC - 1,
	replace(Temp1, Row2, Col2, NewPosition, BoardU).

replace( L , X , Y , Z, R) :-
  append(RowPfx,[Row|RowSfx],L),
  length(RowPfx,X) ,
  append(ColPfx,[_|ColSfx],Row) ,
  length(ColPfx,Y) ,
  append(ColPfx,[Z|ColSfx],RowNew) ,
  append(RowPfx,[RowNew|RowSfx],R).                                

print_gameboard(Board):- 
	write('  '),
	write_spaces(1),
	top_borders(1),nl,
	printBoard(Board,0,5).

printBoard(_,F,F).
printBoard([B|Bs],I,F):-
	I1 is I + 1,
	write(I1),
	write('|'),
	write_spaces(I1),
	display_line(B),
	write('|'),
	nl,
	write('  '),
	I2 is I1 + 1,
	write_spaces(I2),
	top_borders(I2),nl,
	printBoard(Bs,I1,F).


display_line([]).
display_line([L|Ls]):-
	display_position(L),
	display_line(Ls).

display_position([P|Ps]):-
	write('|'),
	translate(P,V), 
	write(V).

write_spaces(1):- write('      ').
write_spaces(2):- write('    ').
write_spaces(3):- write('  ').
write_spaces(4):- write('    ').
write_spaces(5):- write('      ').
write_spaces(6):- write('       ').

top_borders(0).
top_borders(1):- write(' _ _ _ _ _ _').
top_borders(2):- write(' _ _ _ _ _ _ _ _').
top_borders(3):- write(' _ _ _ _ _ _ _ _ _ _').
top_borders(4):- write(' _ _ _ _ _ _ _ _').
top_borders(5):- write(' _ _ _ _ _ _').
top_borders(6):- write('- - - - - -').

translate(r,' O ').
translate(cp1,' a ').
translate(cm1,' A ').
translate(cg1,' * ').
translate(cp2,' b ').
translate(cm2,' B ').
translate(cg2,' + ').
translate(., ' . ').