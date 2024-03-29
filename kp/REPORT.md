# Отчет по курсовому проекту
## по курсу "Логическое программирование"

### студент: Марков А.Н.

## Результат проверки

| Преподаватель     | Дата         |  Оценка       |
|-------------------|--------------|---------------|
| Сошников Д.В. |              |               |
| Левинская М.А.|              |               |

> *Комментарии проверяющих (обратите внимание, что более подробные комментарии возможны непосредственно в репозитории по тексту программы)*

## Введение

1. Узнал про стандартный формат для родословных деревьев GEDCOM.
2. Получил опыт создания парсера на C++ с GEDCOM в предикаты Пролога.
3. Попрактиковался в работе с регулярными выражениями в C++ при создании парсера.
3. Реализовал предикат проверки/поиска.
4. Реализовал программу на Прологе, которая позволяет определять степень родства, при помощи алгоритма поиска в ширину и стандартного перебора.

## Задание

 1. Создать родословное дерево своего рода на несколько поколений (3-4) назад в стандартном формате GEDCOM с использованием сервиса MyHeritage.com 
 2. Преобразовать файл в формате GEDCOM в набор утверждений на языке Prolog, используя следующее представление: ...
 3. Реализовать предикат проверки/поиска .... 
 4. Реализовать программу на языке Prolog, которая позволит определять степень родства двух произвольных индивидуумов в дереве
 5. [На оценки хорошо и отлично] Реализовать естественно-языковый интерфейс к системе, позволяющий задавать вопросы относительно степеней родства, и получать осмысленные ответы. 

## Получение родословного дерева

Я зарегистрировался на сайте myheritage.com, создал там родословное дерево из 32 индивидуумов и экспортировал его в формате GEDCOM.

## Конвертация родословного дерева

Для конвертации родословного дерева из формата GEDCOM в предикаты Пролога я решил использовать C++, т.к. на тот момент из языков, на которых я в теории мог выполнить задачу, были только Си и C++. Выбор из этих двух вариантов очевиден, поскольку C++ предоставляет лучшие условия для работы с текстовыми данными по сравнению с Си. 

Принцип работы программы заключается в следующем:
1. Открываю файл с данными в формате GEDCOM.
2. Создаю словарь для хранения данных о человеке, ключами которого являются идентификаторы людей, а значениями структура, состоящая из пола и имени человека (информация о поле была добавлена позднее для выполнения задания №3).
3. Циклом считываю построчно данные из входного файла и параллельно заполняю словарь данных о людях.
4. Как только встретилась подобная строчка `"0 @F[0-9]+@ FAM"` цикл завершается и запускается следующий цикл.
5. Новый цикл считывает идентификаторы членов данный семьи и затем формирует предикаты father/2, mother/2, которые записываются в выходной файл.
```C++
if (!father_id.empty()) {
				out << "father(\"" << peoples.find(father_id)->second.name << "\", \"" << peoples.find(child_id)->second.name << "\")." << std::endl;
			}
			if (!mother_id.empty()) {
				out << "mother(\"" << peoples.find(mother_id)->second.name << "\", \"" << peoples.find(child_id)->second.name << "\")." << std::endl;
			}
```
6. После записи всех предикатов father/2, mother/2, в выходной файл вносятся предикаты sex/2. Данный предикат будет необходим для задания №3.

## Предикат поиска родственника

Исходный код (я не включил сюда предикаты father/2, mother/2, sex/2 ради экономии места):
```Prolog
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
```

Мне необходимо было найти золовку для некоторого человека. Как это реализовано?
1. Золовка - это сестра мужа, поэтому человек, для которого мы ищем золовку, должен быть женского пола. А также сама золовка должна быть женского пола.
2. Находим для данного человека ребенка.
3. Находим отца этого ребенка (муж).
4. Находим родителя для отца-мужа.
5. Для найденного родителя находим дочерей. Они и будут являться золовками для данного человека.

При выполнении задания обнаружился недостаток представления данных в предикатах father/2 и mother/2. Невозможно будет найти золовку, если у жены с мужем не будет детей.

Протокол работы:
```Prolog
?- sisterInLaw("Nadezhda Grigorieva", Res).
Res = "Tatyana Markova" ;
Res = "Valentina Markova" ;
false.

```

## Определение степени родства

Приведите описание метода решения, важные фрагменты исходного кода, протокол работы.

Для выполнения данного задания я использовал поиск в ширину, поскольку необходимо найти кратчайший путь (кратчайшие отношения родства). Типичный для поиска в ширину предикат move/2 в данном случае определяет есть ли связь между двумя людьми. Данные связи основаны на предикатах link/3. Эти предикаты определяют отношения брат/сестра/отец/мать/сын/дочь/муж/жена:
```Prolog
link(Brother, Human, brother) :- 
	brother(Brother, Human).

link(Sister, Human, sister) :-
	sister(Sister, Human).

link(Father, Child, father) :-
	father(Father, Child).

link(Mother, Child, mother) :-
	mother(Mother, Child).

link(Son, Parent, son) :-
	son(Son, Parent).

link(Daughter, Parent, daughter) :-
	daughter(Daughter, Parent).

link(Husband, Wife, husband) :-
	husband(Husband, Wife).

link(Wife, Husband, wife) :-
	wife(Wife, Husband).
```

Цепочка родственников находится при помощи поиска в ширину:
```Prolog
move(X, Y) :-
	link(X, Y, _).

prolong([X | T], [Y, X | T]) :-
	move(X, Y),
	not(member(Y, [X | T])).

bdth([[X | T] | _], X, [X | T]).
bdth([P | Q1], X, R) :-
	findall(Z, prolong(P, Z), T),
	append(Q1, T, Q0),
	bdth(Q0, X, R), !.
bdth([_ | T], Y, L) :-
	bdth(T, Y, L).

search_bdth(X, Y, P) :-
	bdth([[X]], Y, L),
	reverse(L, P).
```

Полученная цепочка родственников преобразуется в список родственных отношений:
```Prolog
toDegreeKinship([_], []).
toDegreeKinship([First, Second | Tail], Res) :-
	link(First, Second, Kinship),
	toDegreeKinship([Second | Tail], Res1),
	Res = [Kinship | Res1].
```

Протокол работы:
```Prolog
?- kinship("Nikolay Markov", "Nadezhda Grigorieva", Res).
Res = [husband] ;
false.

?- kinship("Nikolay Markov", "Alexander Markov", Res).
Res = [brother] ;
Res = [father] ; 
false.

?- kinship("Nikolay Markov", "Valeriy Grigoriev", Res).
Res = [husband, daughter] ;
false.

```

Результат во втором вопросе оказался таковым, т.к. в родословном дереве есть два "Alexander Markov".

## Естественно-языковый интерфейс

## Выводы

В целом по поводу курсовой работы хочется сказать, что проект оказался довольно-таки разносторонним. В процессе написания реферата я смог разобраться в различиях декларативной и императивной парадигм программирования, узнал в каких задачах Пролог показывает свои сильные стороны, а в каких слабые, и почему же логических языки хороши в качестве первых языков программирования для изучения. При написании конвертера из GEDCOM в предикаты Пролога я смог опробовать регулярные выражения в C++. Для четвертого задания потребовалось использовать поиск в пространстве состояний. 

Я рад, что мне выпала возможность познакомиться парадигмой логического программирования и взглянуть на решения задач под другим углом.
