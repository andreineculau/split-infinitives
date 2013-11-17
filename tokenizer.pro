tokenize([], Out) :-
	Out = [].
tokenize([X|Xs], Out) :-
	tokenize([X|Xs], [], [], Out1),
	Out = Out1.

% if we ended up with a letter
tokenize([X|Xs], W, S, Out) :-
	letter(X), 
	append(W, [X], W1), 
	tokenize(Xs, W1, S, Out1),
	Out = Out1.

% if we ended up with a blank
tokenize([X|Xs], W, S, Out) :-
	blank(X), 
	append_word(W, S, S1), 
	tokenize(Xs, [], S1, Out1),
	Out = Out1.

% if we ended up with a punctuation marker
tokenize([X|Xs], W, S, Out) :-
	punctuation_marker(X), 
	append_word(W, S, S1), 
	append_word([X], S1, S2), 
	tokenize(Xs, [], S2, Out1),
	Out = Out1.

% no character to process; whater word we have, store it, end
tokenize([], W, S, Out) :-
	append_word(W, S, S1),
	Out = S1.


%%%%%%%%%%
% util

% whitespace
blank(C) :-
	C = 32.

% comma, period, exclamation mark, question mark, colon, semicolon
punctuation_marker(C) :-
	C = 44;
	C = 46;
	C = 33;
	C = 63;
	C = 58;
	C = 59.

% letter = non-whitespace non-punctuation character
letter(C) :-
	\+ blank(C), 
	\+ punctuation_marker(C).


% append non empty word (transforms from list of char codes to atom)	
append_word([], S, S1) :-
	append([], S, S1).
append_word(W, S, S1) :-
	\+ W = [], 
	atom_codes(G, W), 
	append(S, [G], S1).