:- discontiguous(father/2).
:- discontiguous(mother/2).

father("Nikolay Markov", "Alexander Markov").
mother("Nadezhda Grigorieva", "Alexander Markov").
father("Valeriy Grigoriev", "Nadezhda Grigorieva").
mother("Nina Mikhailova", "Nadezhda Grigorieva").
father("Valeriy Grigoriev", "Leonid Grigoriev").
mother("Nina Mikhailova", "Leonid Grigoriev").
father("Valeriy Grigoriev", "Svetlana Grigorieva").
mother("Nina Mikhailova", "Svetlana Grigorieva").
father("Valeriy Grigoriev", "Aleksey Grigoriev").
mother("Nina Mikhailova", "Aleksey Grigoriev").
father("Valeriy Grigoriev", "Nikolay Grigoriev").
mother("Nina Mikhailova", "Nikolay Grigoriev").
father("Oleg Chikmyakov", "Evgeniy Chikmyakov").
mother("Svetlana Grigorieva", "Evgeniy Chikmyakov").
father("Oleg Chikmyakov", "Alexander Chikmyakov").
mother("Svetlana Grigorieva", "Alexander Chikmyakov").
father("Aleksey Grigoriev", "Anna Grigorieva").
mother("Olimpiada Volkova", "Anna Grigorieva").
father("Aleksey Grigoriev", "Viktoria Grigorieva").
mother("Olimpiada Volkova", "Viktoria Grigorieva").
father("Aleksey Grigoriev", "Sofia Grigorieva").
mother("Olimpiada Volkova", "Sofia Grigorieva").
mother("Maria Grigorieva", "Valeriy Grigoriev").
father("Grigoriy Markov", "Nikolay Markov").
mother("Nadezhda Zharakovskaya", "Nikolay Markov").
father("Grigoriy Markov", "Tatyana Markova").
mother("Nadezhda Zharakovskaya", "Tatyana Markova").
father("Grigoriy Markov", "Valentina Markova").
mother("Nadezhda Zharakovskaya", "Valentina Markova").
father("Grigoriy Markov", "Alexander Markov").
mother("Nadezhda Zharakovskaya", "Alexander Markov").
father("Leonid Grigoriev", "Valeria Vasilieva").
mother("Alyona Vasilieva", "Valeria Vasilieva").
father("Leonid Grigoriev", "Kristina Vasilieva").
mother("Alyona Vasilieva", "Kristina Vasilieva").
father("Leonid Grigoriev", "Irina Vasilieva").
mother("Alyona Vasilieva", "Irina Vasilieva").
father("Pyotr Mikhailov", "Nina Mikhailova").
mother("Anna Mikhailova", "Nina Mikhailova").
father("Innokenty Markov", "Grigoriy Markov").
mother("Akulina Markova", "Grigoriy Markov").
father("Ivan Zharakovsky", "Nadezhda Zharakovskaya").
mother("Agafya Shestakova", "Nadezhda Zharakovskaya").
sex("Nikolay Markov", "M").
sex("Nadezhda Grigorieva", "F").
sex("Alexander Markov", "M").
sex("Valeriy Grigoriev", "M").
sex("Nina Mikhailova", "F").
sex("Leonid Grigoriev", "M").
sex("Svetlana Grigorieva", "F").
sex("Aleksey Grigoriev", "M").
sex("Nikolay Grigoriev", "M").
sex("Oleg Chikmyakov", "M").
sex("Evgeniy Chikmyakov", "M").
sex("Alexander Chikmyakov", "M").
sex("Olimpiada Volkova", "F").
sex("Viktoria Grigorieva", "F").
sex("Sofia Grigorieva", "F").
sex("Anna Grigorieva", "F").
sex("Maria Grigorieva", "F").
sex("Grigoriy Markov", "M").
sex("Alyona Vasilieva", "F").
sex("Valeria Vasilieva", "F").
sex("Kristina Vasilieva", "F").
sex("Irina Vasilieva", "F").
sex("Pyotr Mikhailov", "M").
sex("Anna Mikhailova", "F").
sex("Tatyana Markova", "F").
sex("Valentina Markova", "F").
sex("Alexander Markov", "M").
sex("Nadezhda Zharakovskaya", "F").
sex("Innokenty Markov", "M").
sex("Akulina Markova", "F").
sex("Ivan Zharakovsky", "M").
sex("Agafya Shestakova", "F").

parent(Parent, Child) :-
	mother(Parent, Child), !; father(Parent, Child), !.

child(Child, Parent) :-
	mother(Parent, Child); father(Parent, Child).

daughter(Daughter, Parent) :-
	child(Daughter, Parent), sex(Daughter, "F").

sisterInLaw(Human, Res) :-
	child(Child, Human), !,
	sex(Human, "F"),
	sex(Res, "F"), 
	father(Father, Child),
	parent(ParentOfFather, Father),
	daughter(Res, ParentOfFather).