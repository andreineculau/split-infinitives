/* Load external databases */
:- [db_verbs].
:- [db_adverbs].
:- [db_pronouns].
:- [db_others].

/* Load external definitions */
:- [tokenizer].
:- [split_inf_checker].

check(Sentence) :-
	tokenize(Sentence, List),
	is_split_infinitive(List).