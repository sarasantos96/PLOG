:-include('menu.pl').
:- use_module(library(lists)).
:- use_module(library(random)).

crabstack:- main_menu.

play_game(B):-
    FirstTurn = 1,
    Computer = 0,
	clear_screen,
	playerTurn(B, FirstTurn,Computer).

play_game_computer(B):-
	FirstTurn = 1,
	Computer = 1,
	clear_screen,
	playerTurn(B,FirstTurn,Computer).

playerTurn(PlayerBoard,Turn, Mode):-
	Turn == 1 -> player1_turn(PlayerBoard,Mode);
	Turn == 2 -> player2_turn(PlayerBoard,Mode);
	write('Wrong player Turn').

player1_turn(B1,PlayerMode1,PlayerMode):-
	display_players_info,nl,nl,
	print_gameboard(B1),
	write('Player1 Turn. Choose the crab to move'),nl,
	write('Row: '), read(Row1), nl,
	write('Column: '),read(Col1),nl,
	(isInsideBoard(Row1,Col1)-> true  ; (write('coord inv'),nl,player1_turn(B1))),
	nth1(Row1,B1,BoardRow1),
	nth1(Col1,BoardRow1,Pos1),
	(isplayer1Crab(Pos1) -> true; (false, write('Not your crab!'),nl, NewBoard1 = B1, player1_turn(NewBoard1))),
	write('Choose your move: '),nl,
	build_moves(B1,RL1,CL1,Row1,Col1,Pos1),
	list_empty(CL1,ColEmpty), list_empty(RL1, RowEmpty),
	( (ColEmpty;RowEmpty)  -> (write('No available moves'), nl , NewBoard1 = B1,player1_turn(NewBoard1)); (display_available_moves(RL1,CL1, 0),read(O1), select_mov(O1,RL1,CL1,Row1,Col1,B1,Pos1,1,PlayerMode1))).

player2_turn(B2,PlayerMode2):-
	display_players_info,nl,nl,
	print_gameboard(B2),
	write('Player2 Turn. Choose the crab to move'),nl,
	write('Row: '), read(Row2), nl,
	write('Column: '),read(Col2),nl,
	(isInsideBoard(Row2,Col2)-> true ; (write('coord inv'),nl,NewBoard = B2, player2_turn(NewBoard))),
	nth1(Row2,B2,BoardRow2),
	nth1(Col2,BoardRow2,Pos2),
	(isplayer2Crab(Pos2) -> true; (false,write('Not your crab!'),nl,NewBoard = B2, player2_turn(NewBoard))),
	write('Choose your move: '),nl,
	build_moves(B2,RL2,CL2,Row2,Col2,Pos2),
	list_empty(CL2,ColEmpty), list_empty(RL2,RowEmpty),
	( (ColEmpty;RowEmpty)  -> (write('No available moves'), nl , NewBoard = B2, player2_turn(NewBoard)); 
	  (PlayerMode2 == 0 -> (display_available_moves(RL2,CL2, 0), read(O2), select_mov(O2,RL2,CL2,Row2,Col2,B2,Pos2,0,PlayerMode2));
	  					   (select_random_play(RL2,CL2,Row2,Col2,B2,Pos2,0,PlayerMode2)))).

select_random_play(RL,CL,Rw,Cl,Bd,Ps,Tn,PMd):-
	length(RL,Len),
	random(1, Len, Choice),
	write(Choice),
	select_mov(Choice,RL,CL,Rw,Cl,Bd,Ps,Tn,PMd).

validSmallMove(BoardSmall, RowCoordSmall, ColCoordSmall):-
	nth1(RowCoordSmall, BoardSmall, NewRowB),
	nth1(ColCoordSmall, NewRowB, NewPos),
	(newPosSmall(NewPos) -> true; false).
newPosSmall([NS|NSs]):-
	(NS == .) -> false;
	(NS == cp1) -> true;
	(NS == cp2) -> true; false.

validMediumMove(BoardMedium, RowCoordMedium, ColCoordMedium):-
	nth1(RowCoordMedium, BoardMedium, NewRowB),
	nth1(ColCoordMedium, NewRowB, NewPos),
	(newPosMedium(NewPos) -> true; false).
newPosMedium([NS|NSs]):-
	(NS == .) -> false;
	(NS == cp1 ; NS == cp2) -> true;
	(NS == cm1 ; NS == cm2) -> true; false.

validBigMove(BoardBig, RowCoordBig, ColCoordBig):-
	nth1(RowCoordBig, BoardBig, NewRowB),
	nth1(ColCoordBig, NewRowB, NewPos),
	(newPosBig(NewPos) -> true; false).
newPosBig([NS|NSs]):-
	(NS == .) -> false;
	true.

isInsideBoard(Row,Col):-
	(Row > 5) -> false;
	(Col > 5) -> false;
	(Row < 1) -> false;
	(Col < 1) -> false;
	((Row == 1; Row == 5), Col > 3) ->  false;
	((Row == 2; Row == 4), Col > 4) -> false;
	((Row == 3), Col > 5) -> false; true.


isplayer1Crab([P1|P1s]):-
	P1 == cp1 -> true;
	P1 == cm1 -> true;
	P1 == cg1 -> true; false.

isplayer2Crab([P2|P2s]):-
	P2 == cp2 -> true;
	P2 == cm2 -> true;
	P2 == cg2 -> true; false.

build_moves(BoardGame,R,C,PRow, PCol,[Peca|PecaT]):-
	(Peca == cp1 ; Peca == cp2) ->(build_small_moves(BoardGame,R,C,PRow, PCol));
	(Peca == cm1 ; Peca == cm2) ->(build_medium_moves(BoardGame,R,C,PRow,PCol));
	(Peca == cg1 ; Peca == cg2) ->(build_big_moves(BoardGame,R,C,PRow,PCol)); 
	(write('Erro Peça nao existe'),nl).


build_small_moves(BS,SmallRowList,SmallColList,RowS, ColS):-
	X1 is ColS - 3,
	X2 is ColS + 3,
	Y1 is RowS +3,
	X3 is (ColS - (Y1 - 3)),
	X4 is (ColS + (3 - RowS)),
	Y2 is RowS - 3,
	X5 is (ColS - (3 - Y2)),
	X6 is (ColS + (RowS - 3)),
	((isInsideBoard(RowS,X1), validSmallMove(BS, RowS, X1) )-> (append(EmptyList1,[X1],Temp1), append(EmptyList2,[RowS],Temp2)) ; (append(EmptyList1,[],Temp1), append(EmptyList2,[],Temp2))),
	((isInsideBoard(RowS,X2), validSmallMove(BS, RowS, X2) )-> (append(Temp1,[X2],Temp3), append(Temp2,[RowS],Temp4)) ; (append(Temp1,[],Temp3), append(Temp2,[],Temp4))),
	((isInsideBoard(Y1,X3), validSmallMove(BS, Y1, X3) )-> (append(Temp3,[X3],Temp5), append(Temp4,[Y1],Temp6)); (append(Temp3,[],Temp5), append(Temp4,[],Temp6))),
	((isInsideBoard(Y1,X4), validSmallMove(BS, Y1, X4) )-> (append(Temp5,[X4],Temp7), append(Temp6,[Y1],Temp8)) ; (append(Temp5,[],Temp7), append(Temp6,[],Temp8))),
	((isInsideBoard(Y2,X5), validSmallMove(BS, Y2, X5) )-> (append(Temp7,[X5],Temp9), append(Temp8,[Y2],Temp10)); (append(Temp7,[],Temp9), append(Temp8,[],Temp10))),
	((isInsideBoard(Y2,X6), validSmallMove(BS, Y2, X6) )-> (append(Temp9,[X6],Temp11), append(Temp10,[Y2],Temp12)) ; (append(Temp9,[],Temp11), append(Temp10,[],Temp12))),
	SmallColList = Temp11, SmallRowList = Temp12.

build_medium_moves(BM,MediumRowList, MediumColList, RowM, ColM):-
	X1 is ColM - 2,
	X2 is ColM + 2,
	Y1 is RowM + 2,
	X3 is (ColM - (Y1 - 3)),
	X4 is (ColM + (3 - RowM)),
	Y2 is RowM - 2,
	X5 is (ColM - (3 - Y2)),
	X6 is (ColM + (RowM - 3)),
	((isInsideBoard(RowM,X1), validMediumMove(BM, RowM, X1) )-> (append(EmptyList1,[X1],Temp1), append(EmptyList2,[RowM],Temp2)) ; (append(EmptyList1,[],Temp1), append(EmptyList2,[],Temp2))),
	((isInsideBoard(RowM,X2),validMediumMove(BM, RowM, X2)) -> (append(Temp1,[X2],Temp3), append(Temp2,[RowM],Temp4)) ; (append(Temp1,[],Temp3), append(Temp2,[],Temp4))),
	((isInsideBoard(Y1,X3), validMediumMove(BM, Y1, X3) )-> (append(Temp3,[X3],Temp5), append(Temp4,[Y1],Temp6)); (append(Temp3,[],Temp5), append(Temp4,[],Temp6))),
	((isInsideBoard(Y1,X4), validMediumMove(BM, Y1, X4) )-> (append(Temp5,[X4],Temp7), append(Temp6,[Y1],Temp8)) ; (append(Temp5,[],Temp7), append(Temp6,[],Temp8))),
	((isInsideBoard(Y2,X5), validMediumMove(BM, Y2, X5) )-> (append(Temp7,[X5],Temp9), append(Temp8,[Y2],Temp10)); (append(Temp7,[],Temp9), append(Temp8,[],Temp10))),
	((isInsideBoard(Y2,X6), validMediumMove(BM, Y2, X6) )-> (append(Temp9,[X6],Temp11), append(Temp10,[Y2],Temp12)) ; (append(Temp9,[],Temp11), append(Temp10,[],Temp12))),
	MediumColList = Temp11, MediumRowList = Temp12.

build_big_moves(BB,BigRowList, BigColList, RowB, ColB):-
	X1 is ColB - 1,
	X2 is ColB + 1,
	Y1 is RowB + 1,
	X3 is (ColB - (Y1 - 3)),
	X4 is (ColB + (3 - RowB)),
	Y2 is RowB - 1,
	X5 is (ColB - (3 - Y2)),
	X6 is (ColB + (RowB - 3)),
	((isInsideBoard(RowB,X1), validBigMove(BB, RowB, X1) )-> (append(EmptyList1,[X1],Temp1), append(EmptyList2,[RowB],Temp2)) ; (append(EmptyList1,[],Temp1), append(EmptyList2,[],Temp2))),
	((isInsideBoard(RowB,X2), validBigMove(BB, RowB, X2) )-> (append(Temp1,[X2],Temp3), append(Temp2,[RowB],Temp4)) ; (append(Temp1,[],Temp3), append(Temp2,[],Temp4))),
	((isInsideBoard(Y1,X3), validBigMove(BB, Y1, X3) )-> (append(Temp3,[X3],Temp5), append(Temp4,[Y1],Temp6)); (append(Temp3,[],Temp5), append(Temp4,[],Temp6))),
	((isInsideBoard(Y1,X4), validBigMove(BB, Y1, X4) )-> (append(Temp5,[X4],Temp7), append(Temp6,[Y1],Temp8)) ; (append(Temp5,[],Temp7), append(Temp6,[],Temp8))),
	((isInsideBoard(Y2,X5), validBigMove(BB, Y2, X5) )-> (append(Temp7,[X5],Temp9), append(Temp8,[Y2],Temp10)); (append(Temp7,[],Temp9), append(Temp8,[],Temp10))),
	((isInsideBoard(Y2,X6), validBigMove(BB, Y2, X6) )-> (append(Temp9,[X6],Temp11), append(Temp10,[Y2],Temp12)) ; (append(Temp9,[],Temp11), append(Temp10,[],Temp12))),
	BigColList = Temp11, BigRowList = Temp12.

list_empty([], true).
list_empty([_|_], false).	

display_available_moves([],[],N).
display_available_moves([AR|ARs],[AC|ACs],N):-
	N1 is N + 1,
	write(N1),
	write('-  Row: '), write(AR),
	write('  Column: '), write(AC),nl,
	display_available_moves(ARs,ACs,N1).

select_mov(MovOption, MovRow, MovCol,OldRow,OldCol,GameB,OldPos, CurrentTurn, GameMode):-
	nth1(MovOption, MovRow, NewRow),
	nth1(MovOption, MovCol, NewCol),
	(CurrentTurn == 1 -> NextTurn = 2; NextTurn = 1),
	updateBoard(GameB, NewGameB, OldRow, OldCol, NewRow, NewCol, OldPos),
	playerTurn(NewGameB,NextTurn,GameMode).
