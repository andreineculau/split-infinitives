/*
* 
* Parsing sentence input as list.
*
* Case supported: Single adverb, e.g. "to boldly go".
* Case supported: Negation, e.g. "to not be".
* Case supported: Adverbial conjunction, e.g. "to loudly and clearly speak", "to forcefully or shrewdly convince".
* Case supported: Negation and adverb, e.g. "to not rashly act".
* Case supported: Adverb and negation, e.g. "to rashly not act".
* Case supported: Negation followed by adverbial conjunction, e.g. "to not rashly or stupidly act".
* Case supported: Adverbial conjunction with negation, e.g. "to rashly but not stupidly act".
* Case supported: Neither nor in adverbial conjunction, e.g. "to neither rashly nor stupidly act".
*
* Case not supported: When the adverb belongs before the infinitive marker, e.g. "stop to briefly pay respects".
* Case not supported: When the adverb belongs at the end of the phrase (phrasal verbs), e.g. "to quickly get rid of him".
* Case not supported: Subject and object pronoun, e.g. "to all hurt one another", "to him advise".
* Case not supported: All other exceptions, e.g. "to more than double".
*
*/

% 0 elements: To avoid 'no' when list has been processed with detected split infinitives.
is_split_infinitive([]).

% 1 element: When only one word is left to process, simply output it.
is_split_infinitive([X]) :-
	print(X).

% 2 elements: Deals with non-split infinitives - will actually be true when there is no split infinitive.
is_split_infinitive([X,Y]) :-
	infinitive_marker(X),
	
	(verb(Y);
	pronoun(Y)),
	
	print_list([X,Y]),
	print('\nDetected: correct use of infinitive/pronoun: '),
	print_list([X,Y]).

% 3 elements: detects split infinitive (negation and single adverb).
is_split_infinitive([X,Y,Z]) :-
	infinitive_marker(X),
	
	\+ verb(Y),
	\+ pronoun(Y),
	
	(negation(Y), verb(Z),
	print_negation_phrase([X,Y,Z]),
	print('\nDetected: split infinitive: '),
	print_list([X,Y,Z]),
	print(' - type: negation'));
	
	(adverb(Y), verb(Z),
	print_adverb_phrase([X,Y,Z]),
	print('\nDetected: split infinitive: '),
	print_list([X,Y,Z]),
	print(' - type: single ddverb')).

% 3 elements: Else case - if no split infinitive, output words.
is_split_infinitive([X,Y,Z]) :-
	infinitive_marker(X),
	
	(verb(Y);
	pronoun(Y)),
	
	print_list([X,Y,Z]),
	print('\nDetected: correct use of infinitive/pronoun: '),
	print_list([X,Y]).

% 4 elements: Detects split infinitive (above + combinations of negation and adverb).
is_split_infinitive([X,Y,Z,A]) :-
	infinitive_marker(X),
	
	\+ verb(Y),
	\+ pronoun(Y),
	
	(negation(Y), verb(Z),
	print_negation_phrase([X,Y,Z]),
	print(A),
	print('\nDetected: split infinitive: '),
	print_list([X,Y,Z]),
	print(' - type: negation'));
	
	(adverb(Y), verb(Z),
	print_adverb_phrase([X,Y,Z]),
	print(A),
	print('\nDetected: split infinitive: '),
	print_list([X,Y,Z]),
	print(' - type: single adverb'));
	
	(negation(Y), adverb(Z), verb(A),
	print_negation_adverb_phrase([X,Y,Z,A]),
	print('\nDetected: split infinitive: '),
	print_list([X,Y,Z,A]),
	print(' - type: negation and adverb'));
	
	(adverb(Y), negation(Z), verb(A),
	print_adverb_negation_phrase([X,Y,Z,A]),
	print('\nDetected: split infinitive: '),
	print_list([X,Y,Z,A]),
	print(' - type: adverb and negation')).

% 4 elements: Else case - if no split infinitive, output words.
is_split_infinitive([X,Y,Z,A]) :-
	infinitive_marker(X),
	
	(verb(Y);
	pronoun(Y)),
	
	print_list([X,Y,Z,A]),
	print('\nDetected: correct use of infinitive/pronoun: '),
	print_list([X,Y]).

% 5 elements: Detects split infinitive (above + adverbial conjunction).
is_split_infinitive([X,Y,Z,A,B]) :-
	infinitive_marker(X),
	
	\+ verb(Y),
	\+ pronoun(Y),
	
	% Outputs correction and keeps searching for more split infinitives.
	
	(negation(Y), verb(Z),
	print_negation_phrase([X,Y,Z]),
	is_split_infinitive([A,B]),
	print('\nDetected: split infinitive: '),
	print_list([X,Y,Z]),
	print(' - type: negation'));
	
	(adverb(Y), verb(Z),
	print_adverb_phrase([X,Y,Z]),
	is_split_infinitive([A,B]),
	print('\nDetected: split infinitive: '),
	print_list([X,Y,Z]),
	print(' - type: single adverb'));
	
	(negation(Y), adverb(Z), verb(A),
	print_negation_adverb_phrase([X,Y,Z,A]),
	print(B),
	print('\nDetected: split infinitive: '),
	print_list([X,Y,Z,A]),
	print(' - type: negation and adverb'));
	
	(adverb(Y), negation(Z), verb(A),
	print_adverb_negation_phrase([X,Y,Z,A]),
	print(B),
	print('\nDetected: split infinitive: '),
	print_list([X,Y,Z,A]),
	print(' - type: adverb and negation'));
	
	(adverb(Y), conjunction(Z), adverb(A), verb(B),
	print_conjunction_phrase([X,Y,Z,A,B]),
	print('\nDetected: split infinitive: '),
	print_list([X,Y,Z,A,B]),
	print(' - type: adverbial conjunction')).
	
% 5 elements: Else case - if no split infinitive, output infinitive and keep searching for split infinitives.
is_split_infinitive([X,Y,Z,A,B]) :-
	infinitive_marker(X),
	
	(verb(Y);
	pronoun(Y)),
	
	print_list([X,Y]),
	
	is_split_infinitive([Z,A,B]),
	
	print('\nDetected: correct use of infinitive/pronoun: '),
	print_list([X,Y]).

% 6+ elements: Detects split infinitives (above + negations in adverbial conjunction; 'neither nor').
is_split_infinitive([X,Y,Z,A,B,C|Cs]) :-
	infinitive_marker(X),
	
	\+ verb(Y),
	\+ pronoun(Y),
	
	% Outputs correction and keeps searching for more split infinitives.
	
	(negation(Y), verb(Z),
	print_negation_phrase([X,Y,Z]),
	is_split_infinitive([A,B,C|Cs]),
	print('\nDetected: split infinitive: '),
	print_list([X,Y,Z]),
	print(' - type: negation'));
	
	(adverb(Y), verb(Z),
	print_adverb_phrase([X,Y,Z]),
	is_split_infinitive([A,B,C|Cs]),
	print('\nDetected: split infinitive: '),
	print_list([X,Y,Z]),
	print(' - type: single adverb'));
	
	(negation(Y), adverb(Z), verb(A),
	print_negation_adverb_phrase([X,Y,Z,A]),
	is_split_infinitive([B,C|Cs]),
	print('\nDetected: split infinitive: '),
	print_list([X,Y,Z,A]),
	print(' - type: negation and adverb'));
	
	(adverb(Y), negation(Z), verb(A),
	print_adverb_negation_phrase([X,Y,Z,A]),
	is_split_infinitive([B,C|Cs]),
	print('\nDetected: split infinitive: '),
	print_list([X,Y,Z,A]),
	print(' - type: adverb and negation'));
	
	(adverb(Y), conjunction(Z), adverb(A), verb(B),
	print_conjunction_phrase([X,Y,Z,A,B]),
	is_split_infinitive([C|Cs]),
	print('\nDetected: split infinitive: '),
	print_list([X,Y,Z,A,B]),
	print(' - type: adverbial conjunction'));
	
	(negation(Y), adverb(Z), conjunction(A), adverb(B), verb(C),
	print_negation_conjunction_phrase([X,Y,Z,A,B,C]),
	is_split_infinitive(Cs),
	print('\nDetected: split infinitive: '),
	print_list([X,Y,Z,A,B,C]),
	print(' - type: negation and adverbial conjunction'));
	
	(adverb(Y), conjunction(Z), negation(A), adverb(B), verb(C),
	print_conjunction_negation_phrase([X,Y,Z,A,B,C]),
	is_split_infinitive(Cs),
	print('\nDetected: split infinitive: '),
	print_list([X,Y,Z,A,B,C]),
	print(' - type: adverbial and negation conjunction'));
	
	(neither(Y), adverb(Z), nor(A), adverb(B), verb(C),
	print_neither_nor_conjunction_phrase([X,Y,Z,A,B,C]),
	is_split_infinitive(Cs),
	print('\nDetected: split infinitive: '),
	print_list([X,Y,Z,A,B,C]),
	print(' - type: neither nor adverbial conjunction')).

% 6+ elements: Else case - if no split infinitive, output infinitive and keep searching for split infinitives.
is_split_infinitive([X,Y,Z,A,B,C|Cs]) :-
	infinitive_marker(X),

	(verb(Y);
	pronoun(Y)),

	print_list([X,Y]),

	is_split_infinitive([Z,A,B,C|Cs]),

	print('\nDetected: correct use of infinitive/pronoun: '),
	print_list([X,Y]).

% Recursive function: look for infinitive marker ('to'); output preceding words.
is_split_infinitive([X|Xs]) :-
	\+ infinitive_marker(X),

	print_whitespace(X),

	is_split_infinitive(Xs).

/*
*
* Output rules
*
*/

print_whitespace([]).

print_whitespace(C):-
	atom_chars(C, [W|Ws]),
	char_code(W, Code),
	punctuation_marker(Code),
	print(C).
	
print_whitespace(C):-
	atom_chars(C, [W|Ws]),
	char_code(W, Code),
	\+ punctuation_marker(Code),
	print(' '),
	print(C).

% When all elements have been output.
print_list([]).

% Output all elements in the list recursively.
print_list([X|Xs]) :-
	print_whitespace(X),
	print_list(Xs).

% Correction of negation, e.g. "to not be" becomes "not to be".
print_negation_phrase([X,Y,Z]) :-
	print_list([Y,X,Z]).

% Correction of adverbial conjunctions (and/or), e.g. "to loudly and clearly speak" becomes "to speak loudly and clearly".
print_conjunction_phrase([X,Y,Z,A,B]) :-
	print_list([X,B,Y,Z,A]).

% Correction of single adverb, e.g. "to boldly go" becomes "to go boldly".	
print_adverb_phrase([X,Y,Z]) :-
	print_list([X,Z,Y]).

% Correction of negation followed by single adverb, e.g. "to not rashly act".
print_negation_adverb_phrase([X,Y,Z,A]) :-
	print_list([Y,X,A,Z]).

% Correction of single adverb followed by negation, e.g. "to rashly not act".
print_adverb_negation_phrase([X,Y,Z,A]) :-
	print_list([Z,X,A,Y]).
	
% Correction of negation followed by adverbial conjunction, e.g. "to not rashly or stupidly act".
print_negation_conjunction_phrase([X,Y,Z,A,B,C]) :-
	print_list([Y,X,C,Z,A,B]).

% Correction of adverbial conjunction with a negation, e.g. "to rashly but not stupidly act".
print_conjunction_negation_phrase([X,Y,Z,A,B,C]) :-
	print_list([X,C,Y,Z,A,B]).

% Correction of neither nor in an adverbial conjunction, e.g. "to neither rashly nor stupidly act".
print_neither_nor_conjunction_phrase([X,Y,Z,A,B,C]) :-
	print_list([X,C,Y,Z,A,B]).