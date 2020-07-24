# ����� �� ������������ ������ �1
## ������ �� �������� � ����������� �������������� ������
## �� ����� "���������� ����������������"

### �������: ������ �.�.

## ��������� ��������

| �������������     | ����         |  ������       |
|-------------------|--------------|---------------|
| �������� �.�. |              |               |
| ��������� �.�.|              |               |

> *����������� ����������� (�������� ��������, ��� ����� ��������� ����������� �������� ��������������� � ����������� �� ������ ���������)*


## ��������

������ - ��� ������������������, ������������ �� ������������� ����� ���������. ������ ��� � ��� ����������� ������� � ������� ����� ������������ ��� �������� ������, �������� �������� ����� �������� ������ ��� ������ ������. ����� ������� ������ ����� ���� ������ � �� ������. � ������ ������ ������ ������������ ��� ���� `[]`. �� ������ ������ ������ ������� ������������� ��� ��������� ��������� �� ������(������� �������� ������) � ������(��������� ����� ������).

� ������� �� ������� � ������������ ������, � ������� ������ ����� ��������� �������� ������ ������ ����, ������ � ������� ����� �������� ����� ��������.
� ������������ ������ ����� ������������ �������� ������ � ������� ����������, � ������� �� ����� ������������ ������ ��������, �������� ������ �� ������ � �����. 

� ����� ������� ������ � ������� ������ �� �������� ������� � ����������� ������, �.�. � ��, � �� ������� ���������� ������������ ��������. � ������ ������ �������� �������� ������ � ������� � ���������, �.�. ��� ���� ������ ����� ������������ � ����������.

## ������� 1.1: �������� ��������� ������

`std_count_entry(X, List, N)` - ������������ ������� ����� ��������� N ��������� �������� X � ������ List c ������� ����������� ����������.
`count_entry(X, List, N)` - ������������ ������� ����� ��������� N ��������� �������� X � ������ List ��� ������������� ����������� ����������.

������� �������������:
```prolog
?- count_entry(a, [p, q, a, a, a, b, a], N).
N = 4.

?- count_entry(0, [0, 0, 1, 2, 0], N).
N = 3.

?- count_entry(0, [1, 2, 3], N).
N = 0 ;
false.

?- std_count_entry(a, [p, q, a, a, a, b, a], N).
N = 4.

?- std_count_entry(0, [0, 0, 1, 2, 0], N).
N = 3.

?- std_count_entry(0, [1, 2, 3], N).
N = 0 .
```

����������:
```prolog
count_entry(_,[],0).
count_entry(X,[X | Tail], N) :-
	count_entry(X, Tail , N1),
	N is N1 + 1, !.
count_entry(X, [_ | Tail], N) :-
	count_entry(X, Tail, N).
```

������� ��������:
1) ��� ����� ��������, ���� ������ �����, �� ����� ��������� ����� 0.
2) ���� ������� ��������� � ������� ������, �� ��������� ���������� count_entry ������ ��� � ������� ������, ���������� ��������� �������� ����� ����������� � N1, � ����������� ����� ��������� ����� ���������� ��� ����� N1 + 1, �.�. ������ ������ ��� ������� � ���������.
3) ����� ���� ������� �� ������ � ������� ������, �� ��������� �������� � ������� ������, �� ���������� ����� ���������.

����������:
```prolog
std_count_entry(_, [], 0).
std_count_entry(X, List, N) :-
	my_remove(A, List, NEW),
	A = X,
	std_count_entry(X, NEW, N1),
	N is N1 + 1, !.
std_count_entry(X, List, N) :-
	my_remove(A, List, NEW),
	A \= X,
	std_count_entry(X, NEW, N).
```
� ������� ������������ ������ �������� � �������� �������� �� ������ �� ������������� ������ ������� � ��������� �� ���������� � ������ ���������, ���� �������, �� ��������� �������� � ����������� ���������� �� 1, ����� ������ ��������� ��������.

## ������� 1.2: �������� ��������� ��������� ������

`max(X, List)` - ������������ ���������� ������������� �������� ��� ������������� ����������� ����������.
`std_max(X, List)` - ������������ ���������� ������������� �������� � ������� ����������� ����������.

������� �������������:
```prolog
?- max(X, [-90, 0, 1, 9, 10]).
X = 10.

?- max(X, [-3, -2, -1]).
X = -1.

?- std_max(X, [0, 0, 0]).
X = 0.

?- std_max(X, [100, 1, 4, 55, 101]).
X = 101 .
```

����������:
```prolog
/*��������������� �������� 
��� ����������� ������������� ��������.*/
maxhelp(X,[H | Tail]) :-
	X >= H,
	maxhelp(X, Tail).
maxhelp(_, []).

max(X,[X | Tail]) :-
	maxhelp(X, Tail), !.
max(MAX, [_ | Tail]) :-
	max(MAX, Tail). 
```

���������� ���������� ������������� ������������ ������� � ������� ������. ���� ������ ������� �� �������, �� ��������� �������� ��� ���������� ��������.

����������:
```prolog
/*��������������� �������� 
��� ����������� ������������� ��������.*/
maxhelp(X,[H | Tail]) :-
	X >= H,
	maxhelp(X, Tail).
maxhelp(_, []).

std_max(X, [X | Tail]) :- 
	maxhelp(X, Tail), !.
std_max(MAX, [X | Tail]) :-
	my_remove(X, [X | Tail], List),
	std_max(MAX, List).
```

������� ����� ��, ��� � � ���������� ���������� ������������� �������� ��� ������������� ����������� ����������, ������ �������, ������� �� �������, ��������� � ������� `remove`.

## ������� 2: ����������� ������������� ������

����������� ������ - ������������ ������, ��������� �� ������ ��������� ������. ����������� ������������� ���������� ��������� ����� ���������. ��������� ������� � ����� ������ - ��� ��������� �������, ��������������� ���������� ��������� ���������. ��� ������ �������� � ���������� ����� ���������, ������� ��������� ������ �������. ������������� ����� ������� ������������ ������� ����������. ��������� ����� ������� �� ��������� ������������, � �������� ����� ������ ������ ��������. � ���� ���������� ����������� ������������� ����������� ������� ����� ������ ����������� � ������� ����������� ��������� findall.

������ two.pl:
```prolog
grade(102,'������','���������� ����������������',4).
grade(102,'������','�������������� ������',2).
grade(102,'������','�������������� ����������������',3).
grade(102,'������','�����������',5).
grade(102,'������','���������� ����',5).
grade(102,'������','����������',4).
```

������� �2.

������� 1. ���������� ������� ���� ��� ������� ��������.

`average_mark(Subj, X)` - �������� ������� ���� X ��� ��������� �������� Subj.

������� �������������:
```prolog
?- average_mark('���������� ����������������', X).
X = 3.9642857142857144.

?- average_mark('�������������� ������', X).
X = 3.892857142857143.

?- average_mark('�������������� ����������������', X).
X = 3.9642857142857144.

?- average_mark('�����������', X).
X = 3.9285714285714284.

?- average_mark('���������� ����', X).
X = 3.75.

?- average_mark('����������', X).
X = 3.9285714285714284.
```

����������:
```prolog
/*����� N ������ �� ������� ��������.
(������ ������, ����� ������)*/
sum_grades([], 0).
sum_grades([H | T], N) :-
	sum_grades(T, M),
	N is H + M.

/*������� ���� ��� ��������
(�������� ��������, ������� ������)*/
average_mark(Subj, X) :-
	findall(Grades, grade(_, _, Subj, Grades), ListGrades),
	sum_grades(ListGrades, AllGrades),
	length(ListGrades, People),
	X is AllGrades / People.
```

������� �������� ������ ���� ������ �� ������� ��������, ����� � ������� ��������� `sum_grades` ������������ ����� ���� ������. ��������� ����� ������ (���������� ������). ����� ������� ������� ���� (����� ����� �� ����� ������).

������� 2. ��� ������ ������, ����� ���������� �� ������� ���������.

`failed_exam_group(Gr, Count)` - �������� ���������� Count �� ������� ��������� � ������ Gr.

������� �������������:
```prolog
?- failed_exam_group(101, X).
X = 2.

?- failed_exam_group(102, X).
X = 5.

?- failed_exam_group(103, X).
X = 3.

?- failed_exam_group(104, X).
X = 2.
```

����������:
```prolog
/*�������� ������������� ��������� � ������
(����������� ������, �������� ������)*/
remove_duplicates([], []) :- !.
remove_duplicates([X|Xs], Ys) :-
    member(X, Xs),
    !, remove_duplicates(Xs, Ys).
remove_duplicates([X|Xs], [X|Ys]) :-
    !, remove_duplicates(Xs, Ys).

/*���������� ��������� ��������� � ������
(����� ������, ����� ���������)*/
failed_exam_group(Gr, Count) :-
	findall(Fail, grade(Gr, Fail, _, 2), FailList),
	remove_duplicates(FailList, ClearFailList),
	length(ClearFailList, Count).
```

�������� ������ ���� ��������� ������ ������ ���������� 2. ������� ������������� ������, ����� ���� ���� � ��� �� ������� �� ���� ������ 1 ��������, �� ������� ��� ������. ��������� ����� ����������� ������. ��� ����� ����� ����� �� ������� ��������� � ������ ������.

������� 3. ����� ���������� �� ������� ��������� ��� ������� �� ���������.

`failed_exam_subject(Subj, Count)` - �������� ���������� Count �� ������� ��������� ������� Subj.

������� �������������:
```prolog
?- failed_exam_subject('���������� ����������������', X).
X = 2.

?- failed_exam_subject('�������������� ������', X).
X = 3.

?- failed_exam_subject('�������������� ����������������', X).
X = 1.

?- failed_exam_subject('�����������', X).
X = 2.

?- failed_exam_subject('���������� ����', X).
X = 4.

?- failed_exam_subject('����������', X).
X = 1.
```

����������:
```prolog
/*���������� ��������� ��������� �� ��������
(�������, ����� ���������)*/
failed_exam_subject(Subj, Count) :-
	findall(Fail, grade(_, Fail, Subj, 2), FailList),
	length(FailList, Count).
```

�������� ������ ���� ��������� ���������� 2 �� ��������� ��������. ��������� ����� ������� ������. ��� ����� ����� ���������� ��������� ��������� �� ������� ��������.

## ������

� ������������ ������ ���������������� �� ������ ���������� ��� ���������� ���������, � � ������� �� - ��� ���������� �������. �� �������� ������-������� ����� � ������ �� �������. ������� ��������, ��� � ������� ����������� ��������� ������������ � ���������, � ����� ��� �������� ���������� ������������ ��������, ������� ���� ������ ����� ��������� ��� ��������������� ������, �.�. ������ ������� ����� ����� ��������, ������ �� ����������� ������������� ����������������. ������, ��� � ���� ������ ���� ����������� ������ � ���������� ���������������� �� ������� �������, �.�. ��� ���� ���� ������ ������������� ������� ��������� �����.