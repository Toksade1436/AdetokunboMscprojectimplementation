
team(1..6).
building(1..3).
day(1..28).
shift(1..2).
physician(1..27).
weekday(1..7).	
day_shift(K) :- shift(K), K =1.
night_shift(S):-  shift(S), S =2.

 teamcount(1, 4).
 teamcount(2, 3).
 teamcount(3, 5).
 teamcount(4, 4).
 teamcount(5, 6).
 teamcount(6, 3).

day_of_week(1, 1).
day_of_week(K, N) :- day(K), weekday(N), K >1, K1 = K-1, day_of_week(K1, N1), N1 >=1, N1<= 6, N==N1 +1.
day_of_week(K, N) :- day(K), weekday(N),  K1 = K-1, day_of_week(K1, 7), N ==1.

shift_attr(D, B, S) :- day(D),  building(B), shift(S).
day_of_week(K, N) :- day(K), weekday(N),  K1 = K-1, day_of_week(K1, 7), N ==1.

shift_attr(D, B, S) :- day(D),  building(B), shift(S).
% no_physician_required(D, B, S, N).


{shift_attr_assign(D, B, S, T): team(T)}=1 :- shift_attr(D, B, S).


%2 No physician can be in two teams.
:-  team_assign(T, P), team_assign(T1, P), T != T1.

%4 No team can work for more than one shift per day in buildings 2 or 3
:-  shift_attr_assign(D, 2, 1, T), shift_attr_assign(D, 2, 2, T).%:-  shift_attr_assign(D, 3, 1, T), shift_attr_assign(D, 3,  2, T).


%5 One shift per day for those working in Building 1 during week days (Monday – Friday).
:- shift_attr_assign(D, 1, 1, T), day_of_week(D, N), N >= 1, N <= 5, 
shift_attr_assign(D, 1, 2, T). 


%6 same team covers night shift for buildings 1- 3, for Monday to Friday.
:- shift_attr_assign(D, 1, 2, T), shift_attr_assign(D, 2, 2, T1), day_of_week(D, D1), D1 >= 1, D1 <= 5 , T!= T1.

:- shift_attr_assign(D, 2, 2, T1), day_of_week(D, D1), D1 >= 1, D1 <= 5,  shift_attr_assign(D, 3, 2, T2), T1!= T2.

:- shift_attr_assign(D, 1, 2, T) , day_of_week(D, D1), D1 >= 1, D1 <= 5,  shift_attr_assign(D, 3, 2, T2), T != T2.


%7 The team assigned to B1 at the beginning of the week has to stay there all week days: Mon – Fri.
:- shift_attr_assign(D, 1, 1, T),  day_of_week(D, K), K >= 1, K <= 4, D1 = D + 1, shift_attr_assign(D1, 1, 1, T1), T != T1. 

%8 No team should be assigned to B1 for two consecutive weeks.
:- shift_attr_assign(D, 1, 1, T), D7 = D + 7, shift_attr_assign(D7, 1, 1, T).

% marking the beginnings of weeks.
weekbegin(D) :- day(D), day_of_week(D, 1).


% off duty days of teams defined in two rules.
onduty(T, D) :-  shift_attr_assign (D, B, S, T), building(B), shift(S).
offduty(T, D) :- day(D), team(T), not onduty(T, D).

% any team that works on a Saturday at Building 2 or 3 must also work in Building 2 or 3 on Sunday. 
:- shift_attr_assign(D, 2, S, T),  day_of_week(D, 6), D1 = D + 1, shift_attr_assign(D1, 1, S, T).
:- shift_attr_assign(D, 2, S, T),  day_of_week(D, 6), D1 = D + 1, offduty(T, D).

% No team can be assigned to more than one building during any day shift.

 :-shift_attr_assign(D, B, 1, T), shift_attr_assign(D, B1, 1, T),  B != B1.
 

% if an off duty day for a team falls between week day 2 and 6, then team cannot be assigned on both the days before and after the said day. 
:- offduty(T, D), day_of_week(D, N), N >= 2, N <= 6, D1 = D +1, shift_attr_assign(D1, _, _, T),
D2 = D - 1, shift_attr_assign(D2, _, _, T).

% if an off duty day for a team falls on week day 1. Then they cannot be assigned to duty on the next day. 
:- offduty(T, D), day_of_week(D, 1), D1 = D +1, shift_attr_assign(D1, _, _, T).

% if an off duty day for a team falls on week day 1. Then they cannot be assigned to duty on the day before. 
:-  offduty(T, D), day_of_week(D, 7), D1 = D -1, shift_attr_assign(D1, _, _, T).

% No team must work for more than 208 hours.
:- team(T),  C=  #count{ S : shift_attr_assign(D, B, S, T) }, C *12 >208.
