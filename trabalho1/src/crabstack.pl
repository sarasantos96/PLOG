:- include('menu.pl').
:- include('utilities.pl').
:- include('board.pl').
:- use_module(library(lists)).
:- use_module(library(random)).

crabstack:- main_menu.

% ***************************** %
%     PLAY GAME FUNCTIONS       %
%     For each game mode        %
% ***************************** %

play_game(B):-   %Player Vs Player 
    FirstTurn = 1,
    Computer = 0,
	clear_screen,
	playerTurn(B, FirstTurn,Computer).

play_game_computer(B):- %Player Vs Computer 
	FirstTurn = 1,
	Computer = 1,
	clear_screen,
	playerTurn(B,FirstTurn,Computer).

play_computer_computer(B):-  %Computer Vs Computer 
	FirstTurn = 1,
	Computer = 2,
	clear_screen,
	playerTurn(B,FirstTurn, Computer).



% ******************************** %
%  		GAME TURN FUNCTIONS        %
% ******************************** %

playerTurn(PlayerBoard,Turn, Mode):-  %Calls the right player to play a turn 
	print_separador,
	(Turn == 1 -> player1_turn(PlayerBoard,Mode);
	Turn == 2 -> player2_turn(PlayerBoard,Mode);
	write('Wrong player Turn')).

player1_turn(B1,PlayerMode1):-        %Player 1 Turn
	moves_available_player1(B1,B1,0) ->
		%If there is any moves available, player picks a crab to move
				(display_players_info,nl,nl,
				print_gameboard(B1),
				write('Player1 Turn. Choose the crab to move'),nl,
				(PlayerMode1 == 2 -> (random(1,5,RowR), random(1,5,ColR));
									 (write('Row: '), read(RowO), nl,write('Column: '),read(ColO),nl)),					 
				(PlayerMode1 == 2 -> (Row1 = RowR, Col1 = ColR ) ; (Row1 = RowO, Col1 = ColO )),
				(isInsideBoard(Row1,Col1)-> true  ; (write('coord inv'),nl,NewBoard1 = B1, player1_turn(NewBoard1,PlayerMode1))),
				nth1(Row1,B1,BoardRow1),
				nth1(Col1,BoardRow1,Pos1),
				(isplayer1Crab(Pos1) -> true; (false, write('Not your crab!'),nl, NewBoard1 = B1, player1_turn(NewBoard1,PlayerMode1))),
				write('Choose your move: '),nl,
				build_moves(B1,RL1,CL1,Row1,Col1,Pos1),
				list_empty(CL1,ColEmpty), list_empty(RL1, RowEmpty),
				( (ColEmpty;RowEmpty)  -> (write('No available moves'), nl , NewBoard = B1, player1_turn(NewBoard,PlayerMode1)); 
				  (PlayerMode1 == 2 -> (select_random_play(RL1,CL1,Row1,Col1,B1,Pos1,0,PlayerMode1));
				  					   (display_available_moves(RL1,CL1, 0), read(O1), length(RL1,L), ((O1 > L; O1<1) -> player1_turn(B1,PlayerMode1); true),select_mov(O1,RL1,CL1,Row1,Col1,B1,Pos1,1,PlayerMode1))))); 
	%Otherwise, player 2 is the winner
				player2_won_menu.

player2_turn(B2,PlayerMode2):-      %Player 2  Turn
	moves_available_player1(B2,B2,0) ->
		%If there is any moves available, player picks a crab to move
				(display_players_info,nl,nl,
				print_gameboard(B2),
				write('Player2 Turn. Choose the crab to move'),nl,
				(PlayerMode2 == 0 -> (write('Row: '), read(RowO), nl,write('Column: '),read(ColO),nl);
									 (random(1,5,RowR), random(1,5,ColR))),
				(PlayerMode2 == 0 -> (Row2 = RowO, Col2 = ColO );  (Row2 = RowR, Col2 = ColR )),
				write(Row2),nl,write(Col2),nl,	
				(isInsideBoard(Row2,Col2)-> true ; (false,write('coord inv'),nl,NewBoard = B2, player2_turn(NewBoard,PlayerMode2))),
				nth1(Row2,B2,BoardRow2),
				nth1(Col2,BoardRow2,Pos2),
				(isplayer2Crab(Pos2) -> true; (false,write('Not your crab!'),nl,NewBoard = B2, player2_turn(NewBoard,PlayerMode2))),
				write('Choose your move: '),nl,
				build_moves(B2,RL2,CL2,Row2,Col2,Pos2),
				list_empty(CL2,ColEmpty), list_empty(RL2,RowEmpty),
				( (ColEmpty;RowEmpty)  -> (write('No available moves'), nl , NewBoard = B2, player2_turn(NewBoard,PlayerMode2)); 
				  (PlayerMode2 == 0 -> (display_available_moves(RL2,CL2, 0), read(O2), length(RL2,L), ((O2 > L; O2<1) -> player2_turn(B2, PlayerMode2); true), select_mov(O2,RL2,CL2,Row2,Col2,B2,Pos2,2,PlayerMode2));
				  					   (select_random_play(RL2,CL2,Row2,Col2,B2,Pos2,0,PlayerMode2)))));
		%Otherwise, player 2 is the winner
				player1_won_menu.

%AUX FUNCTION - Selects a random crab move
select_random_play(RL,CL,Rw,Cl,Bd,Ps,Tn,PMd):-
	length(RL,Len),
	random(1, Len, Choice),
	write(Choice),
	select_mov(Choice,RL,CL,Rw,Cl,Bd,Ps,Tn,PMd).



% *********************************** %
%    FUNCTION TO VALIDATE MOVEMENT    %
% *********************************** %

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

isInsideBoard(Row,Col):-   % Checks if coordenates are inside the game board
	(Row > 5) -> false;
	(Col > 5) -> false;
	(Row < 1) -> false;
	(Col < 1) -> false;
	((Row == 1; Row == 5), Col > 3) ->  false;
	((Row == 2; Row == 4), Col > 4) -> false;
	((Row == 3), Col > 5) -> false; true.


isplayer1Crab([P1|P1s]):- % Checks if a crab belongs to player 1
	P1 == cp1 -> true;
	P1 == cm1 -> true;
	P1 == cg1 -> true; false.

isplayer2Crab([P2|P2s]):- % Checks if crab belongs to player 2
	P2 == cp2 -> true;
	P2 == cm2 -> true;
	P2 == cg2 -> true; false.



% ************************* %
%  BUILD AVAILABLE MOVES    %
%   Given a player crab     %
% ************************* %

build_moves(BoardGame,R,C,PRow, PCol,[Peca|PecaT]):-
	(Peca == cp1 ; Peca == cp2) ->(build_small_moves(BoardGame,R,C,PRow, PCol));
	(Peca == cm1 ; Peca == cm2) ->(build_medium_moves(BoardGame,R,C,PRow,PCol));
	(Peca == cg1 ; Peca == cg2) ->(build_big_moves(BoardGame,R,C,PRow,PCol)); 
	(append([],[],R), append([],[],C)).


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



% ************************************* %
%     SELECTS THE PLAYER MOVEMENT       %
% Updates the board and calls next turn %
% ************************************* %

select_mov(MovOption, MovRow, MovCol,OldRow,OldCol,GameB,OldPos, CurrentTurn, GameMode):-
	nth1(MovOption, MovRow, NewRow),
	nth1(MovOption, MovCol, NewCol),
	(CurrentTurn == 1 -> NextTurn = 2; NextTurn = 1),
	updateBoard(GameB, NewGameB, OldRow, OldCol, NewRow, NewCol, OldPos),
	playerTurn(NewGameB,NextTurn,GameMode).


% ****************************************** %
% 	  EVALUATES THE GAME STATE/BOARD         %
% Checks if a player has any available moves %
% ****************************************** %

moves_available_player1([],Board,RowI):- false.
moves_available_player1([B|Bs],Board,RowI):-
	 (moves_available_row_player1(B,Board,RowI,0) -> true; 
	 												(NewI is RowI +1, moves_available_player1(Bs,Board, NewI))).

moves_available_row_player1([],Board,IndexR,IndexC):- false.
moves_available_row_player1([R|Rs],Board,IndexR, IndexC):-
	(is_available_player1_crab(Board,IndexR, IndexC) -> true; 
														  (NewCI is IndexC +1, moves_available_row_player1(Rs,Board, IndexR, NewCI))).

is_available_player1_crab(Board, IR , IC):-
	nth1(IR,Board, TempRowList),
	nth1(IC,TempRowList, Crab),
	build_moves(Board,RLis,CLis,IR, IC,Crab),
	list_empty(RLis, T),
	( T -> !, false ;(isplayer1Crab(Crab) -> true; !,false)).

moves_available_player2([],Board,RowI):- false.
moves_available_player2([B|Bs],Board,RowI):-
	 (moves_available_row_player2(B,Board,RowI,0) -> true; 
	 												(NewI is RowI +1, moves_available_player2(Bs,Board, NewI))).

moves_available_row_player2([],Board,IndexR,IndexC):- false.
moves_available_row_player2([R|Rs],Board,IndexR, IndexC):-
	(is_available_player2_crab(Board,IndexR, IndexC) -> true; 
														  (NewCI is IndexC +1, moves_available_row_player2(Rs,Board, IndexR, NewCI))).

is_available_player2_crab(Board, IR , IC):-
	nth1(IR,Board, TempRowList),
	nth1(IC,TempRowList, Crab),
	build_moves(Board,RLis,CLis,IR, IC,Crab),
	list_empty(RLis, T),
	( T -> !, false ;(isplayer2Crab(Crab) -> true; !,false)).
