#№ Отчет по лабораторной работе №3
## по курсу "Логическое программирование"

## Решение задач методом поиска в пространстве состояний

### студент: Марков А. Н.

## Результат проверки

| Преподаватель     | Дата         |  Оценка       |
|-------------------|--------------|---------------|
| Сошников Д.В. |              |               |
| Левинская М.А.|              |               |

> *Комментарии проверяющих (обратите внимание, что более подробные комментарии возможны непосредственно в репозитории по тексту программы)*


## Введение

Какие задачи удобным образом решаются методом поиска в пространстве состояний? 
Почему Prolog оказывается удобным языком для решения таких задач?

Такими методами достаточно удобно решать задачи, в которых имеется набор ситуаций, и из некоторой ситуации можно перейти в другую ситуацию. В таких задачах выделяется начальное состояние, а также конечное состояние, которое необходимо достичь из начального. Следовательно описать условия таких задач можно с помощью графа. Но поиск пути имеет экспоненциальное время, поэтому методом поиска в пространстве состояний можно решать только не слишком сложные задачи.

Для представления графов в программировании обычно используют матрицы смежности. В Prolog же граф описывается путем прямого перечисления всех дуг в виде пар вершин. Задание графа при помощи дуг является более гибким, чем матрицы смежности, поскольку дуги могут задаваться не только явным перечислением, но и при помощи правил, что позволяет описывать таким образом сложные и большие графы, для которых матричное представление нерационально и вообще не всегда возможно.

## Задание

2. Три миссионера и три каннибала хотят переправиться с левого берега реки на правый. Как это сделать за минимальное число шагов, если в их распоряжении, если в их распоряжении имеется трехместная лодка и ни при каких обстоятельствах (в лодке или на берегу) миссионеры не должны оставаться в меньшинстве.

## Принцип решения

Опишите своими словами принцип решения задачи, приведите важные фрагменты кода. Какие алгоритмы поиска вы использовали?

Имеются начальное и конечное состояния системы, описанные структурой `s(ML, KL, boat, MR, KR)`, в которой ML - количество миссионеров на левом берегу, KL - количество каннибалов на левом берегу, boat - положение лодки (левый берег или правый берег), MR - количество миссионеров на правом берегу, KR - количество каннибалов на правом берегу. Мы идем по списку, по возможности продлевая его с помощью предиката `prolong`, также этот предикат предотвращает зацикливания:
```prolog
prolong([X | T], [Y, X | T]) :-
	move(X, Y),
	not(member(Y, [X | T])).
```
Сам переход между состояниями отражает предикат `move`. При передвижении лодки с левого берега на правый необходимо, чтобы выполнялись следующие условия:
1. Изначально слева должны находиться миссионеры, количество которых не меньше, чем в лодке (аналогично с каннибалами).
2. После переплытия лодки с левого берега на правый слева должно остаться столько миссионеров, сколько не уплыло на лодке (аналогично с каннибалами).
3. На левом берегу после отплытия лодки миссионеры должны быть в безопасности. Данное условие проверяется с помощью предиката `safely`:
```prolog
safely(M, K) :-
	M >= K; M =:= 0. 
```
4. После прибытия лодки на правый берег на нем должно быть такое количество миссонеров, что оно равно количеству миссионеров на правом берегу до прибытия лодки плюс количество миссионеров, прибывших на лодке (аналогично с каннибалами).
5. На правом берегу после прибытия лодки миссонеры должны быть в безопасности. Данное условие проверяется с помощью предиката `safely`.
```prolog
move(s(ML1, KL1, left, MR1, KR1), s(ML2, KL2, right, MR2, KR2)) :-
	boat(M, K), ML1 >= M, KL1 >= K,
	ML2 is ML1 - M, KL2 is KL1 - K,
	safely(ML2, KL2),
	MR2 is MR1 + M, KR2 is KR1 + K,
	safely(MR2, KR2).
```
Передвижение лодки с правого берега на левый является зеркальным отражением передвижения с левого на правый:
```prolog
move(s(ML1, KL1, right, MR1, KR1), s(ML2, KL2, left, MR2, KR2)) :-
	move(s(MR1, KR1, left, ML1, KL1), s(MR2, KR2, right, ML2, KL2)).
```

Я использовал 3 алгоритма поска в графах: поиск в глубину, поиск в ширину, поиск с итеративным заглублением, которые реализованы в предикатах `search_dpth`, `search_bdth`, `search_id`.

Реализация поиска в глубину:
```prolog
search_dpth :-
	write('DEPTH START'), nl,
	get_time(DEPTH),
	start(S),
	dpth([S], L),
	reverse(L, P),
	write(P), nl,
	get_time(DEPTH1),
	write('DEPTH END'), nl,
	T is DEPTH1 - DEPTH,
	write('TIME IS '), write(T), nl, 
	length(P, Length), 
	write('Length of path is '), write(Length), nl, nl.

dpth([X | T], [X | T]) :-
	goal(X).
dpth(P, L) :-
	prolong(P, P1),
	dpth(P1, L).
```

Реализация поиска в ширину:
```prolog
bdth([[X | T] | _], [X | T]) :-
	goal(X).

bdth([P | Q1], R) :-
	findall(Z, prolong(P, Z), T),
	append(Q1, T, Q0), !,
	bdth(Q0, R).

search_bdth :-
	write('BREADTH START'), nl,
	get_time(BREADTH),
	start(S),
	bdth([[S]], L),
	reverse(L, P),
	write(P), nl,
	get_time(BREADTH1),
	write('BREADTH END'), nl,
	T is BREADTH1 - BREADTH,
	write('TIME IS '), write(T), nl, 
	length(P, Length), 
	write('Length of path is '), write(Length), nl, nl.
```

Реализация поиска с итеративным заглублением:
```prolog
search_id :-
	write('ITER START'), nl,
	get_time(ITER),
	start(S),
	int(Level),
	dpth_id([S], L, Level),
	reverse(L, P),
	write(P), nl,
	get_time(ITER1),
	write('ITER END'), nl,
	T is ITER1 - ITER,
	write('TIME IS '), write(T), nl, 
	length(P, Length), 
	write('Length of path is '), write(Length), nl, nl.

dpth_id([X | T], [X | T], 0) :-
	goal(X).
dpth_id(P, L, N) :- N > 0,
	prolong(P, P1), N1 is N - 1,
	dpth_id(P1, L, N1).
```

## Результаты

Приведите результаты работы программы: найденные пути, время, затраченное на поиск тем или иным алгоритмом, длину найденного первым пути. Используйте таблицы,
если необходимо.

```prolog
?- search_dpth.
DEPTH START
[s(3,3,left,0,0),s(3,1,right,0,2),s(3,2,left,0,1),s(0,2,right,3,1),s(2,2,left,1,1),s(1,1,right,2,2),s(3,1,left,0,2),s(0,1,right,3,2),s(1,1,left,2,2),s(0,0,right,3,3)]
DEPTH END
TIME IS 0.00017690658569335938
Length of path is 10

true .

?- search_bdth.
BREADTH START
[s(3,3,left,0,0),s(3,1,right,0,2),s(3,2,left,0,1),s(0,2,right,3,1),s(0,3,left,3,0),s(0,0,right,3,3)]
BREADTH END
TIME IS 0.0014269351959228516
Length of path is 6

true .

?- search_id.
ITER START
[s(3,3,left,0,0),s(3,1,right,0,2),s(3,2,left,0,1),s(0,2,right,3,1),s(0,3,left,3,0),s(0,0,right,3,3)]
ITER END
TIME IS 0.0008304119110107422
Length of path is 6

true .

```

| Алгоритм поиска | Длина найденного первым пути | Время работы           |
|-----------------|------------------------------|------------------------|
| В глубину       |     10                       | 0.00017690658569335938 |
| В ширину        |     6                        | 0.0014269351959228516  |
| ID              |     6                        | 0.0008304119110107422  |

## Выводы

Сформулируйте *содержательные* выводы по лабораторной работе. 
Чему она вас научила? Над чем заставила задуматься? 

Какие алгоритмы поиска в каких случаях удобно использовать? Какие оказались оптимальными в вашем конкретном случае?

Помните, что несодержательные выводы -
самая частая причина снижения оценки за лабораторную.

Данная лабораторная работа заставила меня задуматься над тем, что с помощью Prolog можно моделировать различные системы из нашего мира с помощью представления их в виде графов, вершины которого являются состояниями этой системы, также определяя некоторые закономерности и конечное состояние системы, мы можем благодаря Prolog узнать целое множество путей к этому конечному состоянию. 

Благодаря этой работе я научился реализовывать три алгоритма поиска в графе и применять их для поиска в пространстве состояний.

Для различных задач, целей, условий подходят различные типы поиска в графе. В условиях ограничения по памяти и неважности нахождения кратчайшего пути следует использовать поиск в глубину, т.к. он имеет линейную сложность по памяти и эта сложность зависит от самого длинного пути. Поиск в ширину следует использовать в случае важности нахождения кратчайшего пути и большом количестве памяти, потому что данный поиск имеет экспоненциальную сложность как по времени, так и по памяти. Поиск с итеративным заглублением следует использовать, если необходимо найти кратчайший путь и есть ограничения по памяти, т.к. он избегает экспоненциальной сложности по памяти. Но всё же эти алгоритмы лучше использовать только для простых задач. В моём случае, как видно из результатов времени работы алгоритмов, наиболее эффективно сработал поиск в глубину. 
