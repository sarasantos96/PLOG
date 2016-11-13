:- include('board.pl').
:- include('utilities.pl').

%% MAIN MENU FUNCTIONS %%
display_title:-	write('==================================================='), nl,
				write('= #### ####    #  ###    #### #####  #  #### #  # ='), nl, 
				write('= #    #  #   # # #  #   #      #   # # #    #  # ='), nl,
				write('= #    ####  #### ####   ####   #  #### #    ###  ='), nl,
				write('= #    #  #  #  # #  #      #   #  #  # #    #  # ='),nl,
				write('= #### #   # #  # ###    ####   #  #  # #### #  # ='),nl,
				write('=     SARA SANTOS NUNO CASTRO PLOG 2016/2017      ='),nl,
				write('===================================================').

display_options:- write('               1. Play Game                    '),nl,
				  write('               2. Intructions                  '),nl,
				  write('               3. Exit                         '),nl.


main_menu:- clear_screen,
			display_title,
			nl,
			nl,
			display_options,
			read_main_option.

play_menu:- clear_screen,
			display_title,nl,nl,
			write('               1. Player vs Player                    '),nl,
			write('               2. Player vs Computer                  '),nl,
			write('               3. Computer vs Computer                '),nl,
			read_play_option.


read_main_option:- read(Option), select_main_option(Option).
select_main_option(1):- play_menu.
select_main_option(2):- clear_screen, display_instructions.
select_main_option(3).

read_play_option:- read(PlayOption), select_play_option(PlayOption).
select_play_option(1):- clear_screen,initial_board(Board), play_game(Board).
select_play_option(2):- clear_screen,initial_board(Board), play_game_computer(Board).
select_play_option(3):- clear_screen, initial_board(Board), play_computer_computer(Board).

%% INSTRUCTIONS MENU FUNCTIONS %%
display_instructions:-
	write('===================='),nl,
	write('=   INSTRUCTIONS   ='),nl,
	write('===================='), nl,nl,
	write('The objective is for the winner to have their crabs on top of all the oponent ones, making impossible any move.'),nl,
	write(' Wich player has three crabs of each size: small can move up to three spaces, medium can move two spaces'), nl,
	write('and big can move one space. The crabs can only move to spaces with other crabs.'),nl,nl,
	write('1-Return to Main Menu'),nl,
	read(Op), select_inst_option(Op).
select_inst_option(1):-clear_screen, main_menu.

player1_won_menu:-
	clear_screen,
	write('       ====================='),nl,
	write('       =    PLAYER 1 WON   ='),nl,
	write('       ====================='),nl,nl,
	write(' 1- Return to main menu'),nl,
	read(OP), main_menu.

player2_won_menu:-
	clear_screen,
	write('       ====================='),nl,
	write('       =    PLAYER 2 WON   ='),nl,
	write('       ====================='),nl,nl,
	write(' 1- Return to main menu'),nl,
	read(OP), main_menu.


