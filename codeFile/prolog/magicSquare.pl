:- use_module(library(clpfd)).
:- use_module(hakank_utils).

:- dynamic buildOutput/2.
:- dynamic magicSquare/3.

:- dynamic checkSum/3.
:- dynamic checkSumList/3.


buildOutput(Size, MagicNumber) :- 
    tell('./prolog/output.txt'), 
    findnsols(100, Rows, (magicSquare(Rows, Size, MagicNumber), maplist(label, Rows), maplist(portray_clause, Rows)), Sol), 
    write(Sol), 
    told.


% predicate:      magicSquare
% arguments:
%     - Matrix -> 2D square list
%     - Size -> size of Matrix
%     - MagicNumber -> MagicNumber for the creation or validation of magic square


magicSquare(Matrix, Size, MagicNumber) :- 
    length(Matrix, Size),                           % check for number of column 
    maplist(same_length(Matrix), Matrix),           % check for number of rows & hence completion for square matrix check

    append(Matrix,Vs), Vs ins 0..MagicNumber,
    maplist(all_distinct, Matrix),

    
    transpose(Matrix, Tmatrix),               % calculating transpose of matrix
    maplist(all_distinct, Tmatrix),
    
    checkSum(Matrix, MagicNumber, Size),
    checkSum(Tmatrix, MagicNumber, Size),

    diagonal1_slice(Matrix, Dg1),
    checkSumList(Dg1, MagicNumber, Size),

    diagonal2_slice(Matrix, Dg2),
    checkSumList(Dg2, MagicNumber, Size).


% fact:           checkSum {if list empty end recursion}
% predicate:      checkSum
% arguments:
%     - Matrix -> Matrix for computation and verification of row-wise sum
%     - MagicNumber -> MagicNumber for the verfication of sum
%     - Size -> for length restriction for labeling of clpfd

checkSum([],_, _).
checkSum([X|Y], MagicNumber, Size) :-
    length(X, Size),
    X ins 0..MagicNumber,
    %all_distinct(X),
    sum(X, #=, MagicNumber),
    checkSum(Y, MagicNumber, Size).       % recursively propagate over to next row of matrix


% predicate:      checkSumList
% arguments:
%     - List -> Matrix for computation and verification of row-wise sum
%     - MagicNumber -> MagicNumber for the verfication of sum
%     - Size -> for length restriction for labeling of clpfd

checkSumList(List, MagicNumber, Size) :-
    length(List, Size),
    List ins 0..MagicNumber,
    sum(List, #=, MagicNumber).