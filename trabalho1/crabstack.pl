empty_board([[x,x,r,x,r,x,r,x,x],
			 [x,r,x,r,x,r,x,r,x],
			 [r,x,r,x,x,x,r,x,r],
			 [x,r,x,r,x,r,x,r,x],
			 [x,x,r,x,r,x,r,x,x]]).
			 
initial_board([[x,x,cg2,x,cp1,x,cm1,x,x],
			   [x,cm2,x,cm2,x,cg2,x,cp2,x],
			   [cp1,x,cg2,x,x,x,cm1,x,cp2],
			   [x,cp1,x,cm2,x,cm2,x,cg1,x],
			   [x,x,cm1,x,cg2,x,cp2,x,x]]).
			   
middle_board([[x,x,r,x,cp1,x,cm1,x,x],
			  [x,r,x,cm2,x,r,x,cp2,x],
			  [cg1,x,cg2,x,x,x,r,x,cp2],
			  [x,cp1,x,cm1,x,cm1,x,cg2,x],
			  [x,x,r,x,r,x,cp2,x,x]]).
			   
final_board([[x,x,r,x,r,x,cm2,x,x],
			 [x,r,x,cm2,x,r,x,r,x],
			 [r,x,cg2,x,x,x,r,x,cp2],
			 [x,cp2,x,r,x,cm2,x,cg2,x],
			 [x,x,r,x,r,x,cp2,x,x]]).
			 
display_board([L1|Ls]):-
	display_line(L1),
	nl,
	display_board(Ls).
display_board([]):-
	nl.
display_line([E|Es]):-
	translate(E,V), 
	write(V), 
	display_line(Es).
display_line([]).

translate(x,' ').
translate(r,'O').
translate(cp1,'a').
translate(cm1,'A').
translate(cg1,'*').
translate(cp2,'b').
translate(cm2,'B').
translate(cg2,'+').
