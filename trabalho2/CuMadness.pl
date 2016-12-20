:- use_module(library(clpfd)).
:- use_module(library(lists)).

%Every red peg must be next to exactly one yellow peg, no more no less
%Every yellow peg must be next to exactly one green, no more no less
%Every green peg must be next to exactly one blue, no more no less
%Every blue peg must be next to exactly one red, no more no less

%The colours of its other neighbours do not matter

%Red = 1, Yellow = 2, Green = 3, Blue = 4,
cuMadness(Cube, Side):-
	Units is (Side * Side),
	length(Cube, Units),
	domain(Cube, 1, 4),
	fillFace(Cube,1,9,Side),
	count(1, Cube, #=, RedCount),
	labeling([maximize(RedCount)],Cube).
	
%declared in sictus manual
exactly(_, [], 0). 
exactly(Color, [L|Ls], N):-
	Color #= L #<=> A,
	N #= M+A,
	exactly(Color, Ls, M).
	
fillFace(Cube, From, To, Side):-
	placePeg(Cube, From, To, Side).

placePeg(_,Limit,_,_).

%canto superior esquerdo	
placePeg(Cube, Index, Limit, Side):-
	element(Index, Cube, Fe),
	Bot is Index + Side,
	Right is Index + 1,
	BotRight is Index + Side + 1,
	element(Bot, Cube, Fb),
	element(Right, Cube, Fr),
	element(BotRight, Cube, Fbr),
	(Fb #= 1 #\/ Fb #= 2 #\/ Fb #= 3 #\/ Fb #= 4),
	(Fr #= 1 #\/ Fr #= 2 #\/ Fr #= 3 #\/ Fr #= 4),
	(Fbr #= 1 #\/ Fbr #= 2 #\/ Fbr #= 3 #\/ Fbr #= 4),
	(Fe #= 1 #/\ exactly(2,[Fb,Fbr,Fr],1)) #\/
	(Fe #= 2 #/\ exactly(3,[Fb,Fbr,Fr],1)) #\/
	(Fe #= 3 #/\ exactly(4,[Fb,Fbr,Fr],1)) #\/
	(Fe #= 4 #/\ exactly(1,[Fb,Fbr,Fr],1)),
	NewIndex is Index + 1,
	placePeg(Cube, NewIndex, Limit, Side).
	
%linha superior
placePeg(Cube, Index, Limit, Side):-
	element(Index, Cube, Fe),
	Left is Index - 1,
	Right is Index + 1,
	Bot is Index + Side,
	BotRight is Index + Side + 1,
	BotLeft is Index + Side - 1,
	element(Left, Cube, Fl),
	element(Right, Cube, Fr),
	element(Bot, Cube, Fb),
	element(BotRight, Cube, Fbr),
	element(BotLeft, Cube, Fbl),
	(Fb #= 1 #\/ Fb #= 2 #\/ Fb #= 3 #\/ Fb #= 4),
	(Fl #= 1 #\/ Fl #= 2 #\/ Fl #= 3 #\/ Fl #= 4),
	(Fr #= 1 #\/ Fr #= 2 #\/ Fr #= 3 #\/ Fr #= 4),
	(Fbr #= 1 #\/ Fbr #= 2 #\/ Fbr #= 3 #\/ Fbr #= 4),
	(Fbl #= 1 #\/ Fbl #= 2 #\/ Fbl #= 3 #\/ Fbl #= 4),
	(Fe #= 1 #/\ exactly(2,[Fl,Fr,Fb,Fbr,Fbl],1)) #\/
	(Fe #= 2 #/\ exactly(2,[Fl,Fr,Fb,Fbr,Fbl],1)) #\/
	(Fe #= 3 #/\ exactly(2,[Fl,Fr,Fb,Fbr,Fbl],1)) #\/
	(Fe #= 4 #/\ exactly(2,[Fl,Fr,Fb,Fbr,Fbl],1)),
	NewIndex is Index + 1,
	placePeg(Cube, NewIndex, Limit, Side).

%canto superior direito
placePeg(Cube, Index, Limit, Side):-
	element(Index,Cube,Fe),
	Bot is Index + Side,
	Left is Index - 1,
	BotLeft is Index + Side - 1,
	element(Bot,Cube,Fb),
	element(Left,Cube,Fl),
	element(BotLeft,Cube,Fbl),
	(Fb #= 1 #\/ Fb #= 2 #\/ Fb #= 3 #\/ Fb #= 4),
	(Fl #= 1 #\/ Fl #= 2 #\/ Fl #= 3 #\/ Fl #= 4),
	(Fbl #= 1 #\/ Fbl #= 2 #\/ Fbl #= 3 #\/ Fbl #= 4),
	(Fe #= 1 #/\ exactly(2,[Fb,Fl,Fbl], 1)) #\/
	(Fe #= 2 #/\ exactly(3,[Fb,Fl,Fbl], 1)) #\/
	(Fe #= 3 #/\ exactly(4,[Fb,Fl,Fbl], 1)) #\/
	(Fe #= 4 #/\ exactly(1,[Fb,Fl,Fbl], 1)),
	NewIndex is Index + 1,
	placePeg(Cube, NewIndex, Limit, Side).
	
%coluna mais à esquerda
placePeg(Cube, Index, Limit, Side):-
	element(Index, Cube, Fe),
	Right is Index + 1,
	Top is Index - Side,
	TopRight is Index - Side + 1,
	Bot is Index + Side,
	BotRight is Index + Side + 1,
	element(Right, Cube, Fr),
	element(Bot, Cube, Fb),
	element(BotRight, Cube, Fbr),
	element(Top, Cube, Ft),
	element(TopRight, Cube, Ftr),
	(Ft #= 1 #\/ Ft #= 2 #\/ Ft #= 3 #\/ Ft #= 4),
	(Fb #= 1 #\/ Fb #= 2 #\/ Fb #= 3 #\/ Fb #= 4),
	(Fr #= 1 #\/ Fr #= 2 #\/ Fr #= 3 #\/ Fr #= 4),
	(Ftr #= 1 #\/ Ftr #= 2 #\/ Ftr #= 3 #\/ Ftr #= 4),
	(Fbr #= 1 #\/ Fbr #= 2 #\/ Fbr #= 3 #\/ Fbr #= 4),
	(Fe #= 1 #/\ exactly(2,[Fr,Fb,Fbr,Ft,Ftr],1)) #\/
	(Fe #= 2 #/\ exactly(3,[Fr,Fb,Fbr,Ft,Ftr],1)) #\/
	(Fe #= 3 #/\ exactly(4,[Fr,Fb,Fbr,Ft,Ftr],1)) #\/
	(Fe #= 4 #/\ exactly(1,[Fr,Fb,Fbr,Ft,Ftr],1)),
	NewIndex is Index + 1,
	placePeg(Cube, NewIndex, Limit, Side).
	
%centro
placePeg(Cube, Index, Limit, Side):-
	element(Index, Cube, Fe),
	Top is Index - Side,
	Bot is Index + Side,
	Left is Index - 1,
	Right is Index + 1,
	TopRight is Index - Side + 1,
	TopLeft is Index - Side - 1,
	BotRight is Index + Side + 1,
	BotLeft is Index + Side - 1,
	element(Top, Cube, Ft),
	element(Bot, Cube, Fb),
	element(Left, Cube, Fl),
	element(Right, Cube, Fr),
	element(TopRight, Cube, Ftr),
	element(TopLeft, Cube, Ftl),
	element(BotRight, Cube, Fbr),
	element(BotLeft, Cube, Fbl),
	(Ft #= 1 #\/ Ft #= 2 #\/ Ft #= 3 #\/ Ft #= 4),
	(Fb #= 1 #\/ Fb #= 2 #\/ Fb #= 3 #\/ Fb #= 4),
	(Fl #= 1 #\/ Fl #= 2 #\/ Fl #= 3 #\/ Fl #= 4),
	(Fr #= 1 #\/ Fr #= 2 #\/ Fr #= 3 #\/ Fr #= 4),
	(Ftr #= 1 #\/ Ftr #= 2 #\/ Ftr #= 3 #\/ Ftr #= 4),
	(Ftl #= 1 #\/ Ftl #= 2 #\/ Ftl #= 3 #\/ Ftl #= 4),
	(Fbr #= 1 #\/ Fbr #= 2 #\/ Fbr #= 3 #\/ Fbr #= 4),
	(Fbl #= 1 #\/ Fbl #= 2 #\/ Fbl #= 3 #\/ Fbl #= 4),
	(Fe #= 1 #/\ exactly(2,[Ft,Ftr,Ftl,Fb,Fbr,Fbl,Fl,Fr],1)) #\/
	(Fe #= 2 #/\ exactly(3,[Ft,Ftr,Ftl,Fb,Fbr,Fbl,Fl,Fr],1)) #\/
	(Fe #= 3 #/\ exactly(4,[Ft,Ftr,Ftl,Fb,Fbr,Fbl,Fl,Fr],1)) #\/
	(Fe #= 4 #/\ exactly(1,[Ft,Ftr,Ftl,Fb,Fbr,Fbl,Fl,Fr],1)),
	NewIndex is Index + 1,
	placePeg(Cube, NewIndex, Limit, Side).

%coluna mais à direita
placePeg(Cube, Index, Limit, Side):-
	element(Index, Cube, Fe),
	Left is Index - 1,
	Top is Index - Side,
	TopLeft is Index - Side - 1,
	Bot is Index + Side,
	BotLeft is Index + Side - 1,
	element(Left, Cube, Fl),
	element(Bot, Cube, Fb),
	element(BotLeft, Cube, Fbl),
	element(Top, Cube, Ft),
	element(TopLeft, Cube, Ftl),
	(Ft #= 1 #\/ Ft #= 2 #\/ Ft #= 3 #\/ Ft #= 4),
	(Fb #= 1 #\/ Fb #= 2 #\/ Fb #= 3 #\/ Fb #= 4),
	(Fl #= 1 #\/ Fl #= 2 #\/ Fl #= 3 #\/ Fl #= 4),
	(Ftl #= 1 #\/ Ftl #= 2 #\/ Ftl #= 3 #\/ Ftl #= 4),
	(Fbl #= 1 #\/ Fbl #= 2 #\/ Fbl #= 3 #\/ Fbl #= 4),
	(Fe #= 1 #/\ exactly(2,[Fl,Fb,Fbl,Ft,Ftl],1)) #\/
	(Fe #= 2 #/\ exactly(3,[Fl,Fb,Fbl,Ft,Ftl],1)) #\/
	(Fe #= 3 #/\ exactly(4,[Fl,Fb,Fbl,Ft,Ftl],1)) #\/
	(Fe #= 4 #/\ exactly(1,[Fl,Fb,Fbl,Ft,Ftl],1)),
	NewIndex is Index + 1,
	placePeg(Cube, NewIndex, Limit, Side).

%canto inferior esquerdo
placePeg(Cube, Index, Limit, Side):-
	element(Index, Cube, Fe),
	Top is Index - Side,
	TopRight is Index - Side + 1,
	Right is Index + 1,
	element(Top, Cube, Ft),
	element(TopRight, Cube, Ftr),
	element(Right, Cube, Fr),
	(Ft #= 1 #\/ Ft #= 2 #\/ Ft #= 3 #\/ Ft #= 4),
	(Fr #= 1 #\/ Fr #= 2 #\/ Fr #= 3 #\/ Fr #= 4),
	(Ftr #= 1 #\/ Ftr #= 2 #\/ Ftr #= 3 #\/ Ftr #= 4),
	(Fe #= 1 #/\ exactly(2,[Ft, Ftr, Fr], 1)) #\/
	(Fe #= 2 #/\ exactly(3,[Ft, Ftr, Fr], 1)) #\/
	(Fe #= 3 #/\ exactly(4,[Ft, Ftr, Fr], 1)) #\/
	(Fe #= 4 #/\ exactly(1,[Ft, Ftr, Fr], 1)),
	NewIndex is Index + 1,
	placePeg(Cube, NewIndex, Limit, Side).

%linha inferior
placePeg(Cube, Index, Limit, Side):-
	element(Index, Cube, Fe),
	Left is Index - 1,
	Right is Index + 1,
	Top is Index - Side,
	TopRight is Index - Side + 1,
	TopLeft is Index - Side - 1,
	element(Left, Cube, Fl),
	element(Right, Cube, Fr),
	element(Top, Cube, Ft),
	element(TopRight, Cube, Ftr),
	element(TopLeft, Cube, Ftl),
	(Fl #= 1 #\/ Fl #= 2 #\/ Fl #= 3 #\/ Fl #= 4),
	(Ft #= 1 #\/ Ft #= 2 #\/ Ft #= 3 #\/ Ft #= 4),
	(Fr #= 1 #\/ Fr #= 2 #\/ Fr #= 3 #\/ Fr #= 4),
	(Ftr #= 1 #\/ Ftr #= 2 #\/ Ftr #= 3 #\/ Ftr #= 4),
	(Ftl #= 1 #\/ Ftl #= 2 #\/ Ftl #= 3 #\/ Ftl #= 4),
	(Fe #= 1 #/\ exactly(2,[Fl,Fr,Ft,Ftr,Ftl],1)) #\/
	(Fe #= 2 #/\ exactly(3,[Fl,Fr,Ft,Ftr,Ftl],1)) #\/
	(Fe #= 3 #/\ exactly(4,[Fl,Fr,Ft,Ftr,Ftl],1)) #\/
	(Fe #= 4 #/\ exactly(1,[Fl,Fr,Ft,Ftr,Ftl],1)),
	NewIndex is Index + 1,
	placePeg(Cube, NewIndex, Limit, Side).	
	
%canto inferior direito
placePeg(Cube, Index, Limit, Side):-
	element(Index, Cube, Fe),
	Top is Index - Side,
	TopLeft is Index + Side - 1,
	Left is Index - 1,
	element(Top, Cube, Ft),
	element(TopLeft, Cube, Ftl),
	element(Left, Cube, Fl),
	(Ft #= 1 #\/ Ft #= 2 #\/ Ft #= 3 #\/ Ft #= 4),
	(Fl #= 1 #\/ Fl #= 2 #\/ Fl #= 3 #\/ Fl #= 4),
	(Ftl #= 1 #\/ Ftl #= 2 #\/ Ftl #= 3 #\/ Ftl #= 4),
	(Fe #= 1 #/\ exactly(2,[Ft, Ftl, Fl], 1)) #\/
	(Fe #= 2 #/\ exactly(3,[Ft, Ftl, Fl], 1)) #\/
	(Fe #= 3 #/\ exactly(4,[Ft, Ftl, Fl], 1)) #\/
	(Fe #= 4 #/\ exactly(1,[Ft, Ftl, Fl], 1)),
	NewIndex is Index + 1,
	placePeg(Cube, NewIndex, Limit, Side).