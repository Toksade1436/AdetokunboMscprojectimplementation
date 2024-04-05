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
