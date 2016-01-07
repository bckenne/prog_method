/* Clemson University
   CPSC 3520
   Schalkoff
   Spring 2015
   
   This program implements image motion tracking.
   Copyright (C) 2015 Bradley Curtis Kennedy.

   This program is free software; you can redistribute it and/or
   modify it under the terms of the GNU General Public License
   as published by the Free Software Foundation; either version 2
   of the License, or (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA. */




printImRow([]).
printImRow([Hd|Tl]) :- write(Hd), write(' '), printImRow(Tl).

diffImRow([],[],[]).
diffImRow([Hd1|Tl1], [Hd2|Tl2], [Hdd|Tld]) :- Hdd is Hd2-Hd1, diffImRow(Tl1, Tl2, Tld).

isDiffRow([]).
isDiffRow([Hd|Tl]) :- Hd=0,isDiffRow(Tl).

isDifferent([]).
isDifferent([Hd|Tl]) :- isDiffRow(Hd),isDifferent(Tl).

sumImRow([], _, Sum) :- Sum is 0.
sumImRow([Hd|Tl], J, Sum) :- sumImRow(Tl, J + 1, X), Sum is X+Hd*J.

sumImCol([], _, Sum) :- Sum is 0.
sumImCol([Hd|Tl], I, Sum) :- sumImCol(Tl, I, X), Sum is X+Hd*I.

sumIm([], Sum) :- Sum is 0.
sumIm([[]|RTl], Sum) :- sumIm(RTl, X),!, Sum is X.
sumIm([[Hd|Tl]|RTl], Sum) :- sumIm([Tl|RTl], X), Sum is Hd + X.

icent(M, C) :- centImCol(M, 1, X), sumIm(M, Sum), C is float(X) / float(Sum).

jcent(M, C) :- centImRow(M, 1, X), sumIm(M, Sum), C is float(X) / float(Sum).

printImage([]).
printImage([Hd|Tl]) :- printImRow(Hd), nl, printImage(Tl).

diffIm([],[],[]).
diffIm([Hd1|Tl1], [Hd2|Tl2], [Hdd|Tld]) :- diffImRow(Hd1,Hd2,Hdd), diffIm(Tl1, Tl2, Tld).

isDiff(I1,I2) :- diffIm(I1, I2, D), not(isDifferent(D)).

rowmask([],[],[],[],[]).
rowmask([Hd1|Tl1],[Hd2|Tl2],[Hdd|Tld],[Hdm1|Tlm1],[Hdm2|Tlm2]) :-
  ((Hdd=0, Hdm1 is 0, Hdm2 is 0);
  (Hdd<0, Hdm1 is Hd1, Hdm2 is 0);
  (Hdd>0, Hdm1 is 0, Hdm2 is Hd2)), !, rowmask(Tl1,Tl2,Tld,Tlm1,Tlm2).

mask([],[],[],[],[]).
mask([Hd1|Tl1],[Hd2|Tl2],[Hdd|Tld],[Hdm1|Tlm1],[Hdm2|Tlm2]) :-
  rowmask(Hd1,Hd2,Hdd,Hdm1,Hdm2),!,
  mask(Tl1,Tl2,Tld,Tlm1,Tlm2).

centImRow([], _, Sum) :- Sum is 0.
centImRow([Hd|Tl], J, Sum) :- sumImRow(Hd, J, X), centImRow(Tl, J, Y), Sum is X + Y.

centImCol([], _, Sum) :- Sum is 0.
centImCol([Hd|Tl], I, Sum) :- sumImCol(Hd, I, X), centImCol(Tl, I + 1, Y),!, Sum is X + Y.

motion(I1,I2,Mi,Mj) :-
  (not(isDiff(I1,I2)),write('***** No Motion in This Case *****'),nl,!);
  diffIm(I1, I2, D),
  mask(I1, I2, D, I1m, I2m),
  icent(I2m, I2i),
  icent(I1m, I1i),
  jcent(I2m, I2j),
  jcent(I1m, I1j),
  Mi is I2i - I1i,
  Mj is I2j - I1j.