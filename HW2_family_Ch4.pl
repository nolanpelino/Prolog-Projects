% Facts for the family relations exercise at the end of Ch.4 [L].
child(alberto,guido). child(alberto,antonietta).
child(giulia,enrico). child(giulia,annamaria).
child(dante,marco).   child(clara,marco).
child(dante,laura).   child(clara,laura).
child(marco,alberto).   child(marco,giulia).
child(laura,lawrence).  child(laura,julie).
child(emily,lawrence).  child(emily, julie).
child(claire,lawrence). child(claire, julie).
child(sam,emily). child(ben,emily).
child(sam,dave). child(ben,dave).
child(eve,claire). child(annabelle,claire).
child(eve,ed). child(annabelle,ed).
child(giulio,guido). child(donata,giulio).
child(sara,donata). child(marco2,donata).
child(giulio,antonietta).

male(guido). male(enrico).
male(marco). male(dante). male(alberto). male(lawrence).
male(sam). male(ben). male(dave). male(ed).
male(giulio). male(marco2).
female(antonietta). female(annamaria).
female(clara).  female(laura).  female(giulia). female(julie).
female(emily). female(claire). female(eve). female(annabelle).
female(donata). female(sara).

%Clauses from Figure 3.1, as required by Ch.4[L] exercise
parent(Y,X) :- child(X,Y).
father(Y,X) :- child(X,Y), male(Y).
opp_sex(X,Y) :- male(X), female(Y).
opp_sex(Y,X) :- male(X), female(Y).
grand_father(X,Z) :- father(X,Y), parent(Y,Z).

/*
1. mother, grand_parent, and great_grand_mother.
*/ 
mother(Y,X) :- child(X,Y), female(Y).
grand_parent(Y,X) :- parent(Y,Z), child(X,Z).
great_grand_mother(Y,X) :- grand_parent(Y,Z), parent(Z,X), female(Y).

/*
?- mother(laura,dante).
true.
?- grand_parent(guido,donata).
true.
?- great_grand_mother(emily,claire).
false.


2. sibling, brother, and sister.
x is a sibling of y if x and y are two different people who share a parent in
common. A brother is a sibling who is male; a sister is a sibling who is female.
*/
brother(X,Y) :- male(X), father(Z,X), father(Z,Y), X \= Y, mother(M,X), mother(M,Y).
sister(X,Y) :- female(X), father(Z,X), father(Z,Y), X \= Y, mother(M,X), mother(M,Y).
sibling(X,Y) :- father(Z,X), father(Z,Y), X \= Y, mother(M,X), mother(M,Y).

/*
?- brother(lawrence,marco).
false.
?- sister(emily,claire).
true
?- sibling(sam,ben).
true


3. half_sibling and full_sibling.
Half siblings are siblings who have exactly one parent in common. Full siblings
are siblings who have two parents in common.
*/
half_sibling(X,Y) :- father(Z,X), father(Z,Y), X \= Y, \+ mother(M,X), \+ mother(M,Y).
half_sibling(X,Y) :- \+ father(Z,X), \+ father(Z,Y), X \= Y, mother(M,X), mother(M,Y).
full_sibling(X,Y) :- father(Z,X), father(Z,Y), X \= Y, mother(M,X), mother(M,Y).

/*
?- half_sibling(guilia,guilio).
false.
?- sibling(sam,ben).
true


4. first_cousin and second_cousin.
x is a first cousin of y if some parent of x and some parent of y are siblings. (Note
that first cousins will have a grandparent in common.) x and y are second cousins
if some parent of x and some parent of y are first cousins. (Second cousins will
share a great-grandparent.)
*/
first_cousin(X,Y) :- grand_parent(Z,X), grand_parent(Z,Y), \+ sibling(X,Y).
great_grand_parent(X,Y) :- grand_parent(Z,Y), parent(X,Z).
second_cousin(X,Y) :- great_grand_parent(X,Z), great_grand_parent(Y,Z), \+ first_cousin(X,Y).
/*
?- first_cousin(marco,donata).
true 
?- great_grand_parent(guido,clara).
true 
?- second_cousin(giulio, claire).
false.


5. half_first_cousin and double_first_cousin.
x is a half first cousin of y if some parent of x is a half sibling of a parent of y. x
is a double first cousin of y if each parent of x is a sibling of a parent of y. (Note
that a first cousin is not the same thing as a double half first cousin. The double
and half do not cancel out.)
*/
half_first_cousin(X,Y) :- parent(O,X), parent(T,Y), half_sibling(O,T), \+ sibling(X,Y).
double_first_cousin(X,Y) :- parent(A,X), parent(B,X), parent(C,Y), parent(D,Y), sibling(A,C), sibling(A,D), sibling(B,C), sibling(B,D), \+ sibling(X,Y).
/*
?- half_first_cousin(sam,eve).
false.
?- double_first_cousin(sam,eve).
true 


6. first_cousin_twice_removed.
Look on the Internet or elsewhere for the definition of a third cousin once
removed or a second cousin twice removed and so on, and fill in the details
here.
*/
first_cousin_once_removed(X,Y) :- parent(X,Z), first_cousin_once_removed(Z,Y).
first_cousin_twice_removed(X,Y) :- grand_parent(X,Z), first_cousin_twice_removed(Z,Y).

/*
?- first_cousin_once_removed(marco,giulio).
false.
?- first_cousin_twice_removed(marco,giulio).
false.




7. descendant, ancestor.
x is a descendant of y if x is either a child of y or (recursively) of someone who
is a descendant of y. x is an ancestor of y if y is a descendant of x.
*/
descendant(X,Y) :- parent(Y,X).
descendant(X,Y) :- child(X,Z), descendant(Z,Y).
ancestor(X,Y) :- parent(X,Y).
ancestor(X,Y) :- parent(X,Z), ancestor(Z,Y).
/*

?- descendant(sam,lawrence).
true 
?- ancestor(alberto,clara).
true 

8. cousin.
x is a cousin of y if some parent of x and some parent of y are either siblings
or (recursively) cousins. (The x and y will always end up being nth cousins for
some n. For example, fourth cousins will have parents who are third cousins.)
*/
cousin(X,Y) :- first_cousin(X,Y).
cousin(X,Y) :- first_cousin(X,Y), parent(A,X), parent(B,Y), cousins(A,B).
/*

?- cousin(sam,eve).
true



9. closest_common_ancestor.
x is a closest common ancestor of two people y and z if x is an ancestor of both
y and z and no child of x is an ancestor of y and z. (A closest common ancestor
of two first cousins will be someone who is a grandparent of both.)
*/
closest_common_ancestor(X,Y,Z) :- \+ Y=Z, ancestor(X,Y), ancestor(X,Z), descendant(D,X), \+ ancestor(D,Y), \+ ancestor(D,Z).

/*
?- closest_common_ancestor(alberto,marco,clara).
true



10. write_descendant_chain.
Later chapters examine the special predicates write and nl, which can be used
to produce output other than just the values of variables. For example, if there is
a clause
write_child(X,Y) :-
write(X), write(’ is a child of ’), write(Y), nl.
then the query write_child(john_smith,sue_jones) will always succeed and
will also print
john_smith is a child of sue_jones
on one line. Include this predicate in your program, and write the clauses
for a predicate write_descendant_chain(x, y) that prints a chain from x to
y when x is a descendant of y but prints nothing when x is not a descendant of y. For example, if John Smith is a descendant of William Brown,
then write_descendant_chain(john_smith,william_brown) should print a
sequence of lines something like this:
john_smith is a child of sue_jones
sue_jones is a child of harvey_jones
harvey_jones is a child of davy_jones
davy_jones is a child of anna_brown
anna_brown is a child of william_brown
Hint: You will not be able to use the descendant predicate you defined for this.
Use the child predicate together with write_child. Also, work down from y
rather than up from x.
*/

write_child(X,Y) :- write(X), write(' is a child of '), write(Y), nl.
write_descendant_chain(X,Y) :- parent(Y,X), write_child(X,Y).
write_descendant_chain(X,Y) :- \+ parent(Y,X), parent(Y,A), write_child(A,Y), write_descendant_chain(X,A).


/* 
?- write_descendant_chain(dante,antonietta).
alberto is a child of antonietta
marco is a child of alberto
dante is a child of marco
true 
*/