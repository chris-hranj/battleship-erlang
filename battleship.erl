%%% Christopher Hranj
%%% 10/03/15
%%% CSC435
%%% Project 3 - Erlang

-module(battleship).

-export([place_ships/2, attack/2, print_board/1, driver/2]).

% Place every ship onto the board using the Coordinates input to
% determine where each ship is placed.
place_ships(_ = [], Board) ->
  % Return the board with ships placed on it.
  Board;
place_ships([First|Rest] = _, Board) -> 
  % Use add_ship_to_board helper function to place each ship on the board.
  NewBoard = add_ship_to_board(First, Board),
  % Recurse over every ship being added to the board.
  place_ships(Rest, NewBoard).

% Seperate ship by name and coordinates so that the ships can be placed
% and the board can be updated with the ship's names.
add_ship_to_board({_, _= []}, Board) ->
  % Return the board after all ships have been placed.
  Board;
add_ship_to_board({Ship , [First|Rest] = _}, Board) -> 
  % Create a new tuple that replaces none with the ship's name.
  NewTuple = setelement(element(2, First), array:get(letter_to_number(element(1, First)), Board), Ship),
  % Create a new board with the updated tuple from above.
  NewBoard = array:set(letter_to_number(element(1, First)), NewTuple, Board),
  % Recurse over every coordinate for the ship.
  add_ship_to_board({Ship, Rest}, NewBoard).

% Attack each coordinate in the Targets list.
% If a ship is located at that coordinate, update the board to show a hit.
% Otherwise update the board to show a miss.
attack(_ = [], Board) -> 
  % Return the board after all attacks have been made.
  Board;
attack([First|Rest] = _, Board) ->
  % Get the content of a coordinate from the Targets list.
  Input = element(element(2, First),array:get(letter_to_number(element(1, First)), Board)),
  % Check if the coordinate contains 'none'.
  if Input =:= none ->
    % If 'none', replace coordinate with 'miss'.
      NewTuple = setelement(element(2,First), array:get(letter_to_number(element(1, First)), Board), 'miss');
    % Otherwise attack must have been a hit.
    true ->
      % Replace coordinate with 'hit'.
      NewTuple = setelement(element(2,First), array:get(letter_to_number(element(1, First)), Board), 'hit')       
  end,

  % Create a new board with the updated tuple from above.
  NewBoard = array:set(letter_to_number(element(1, First)), NewTuple, Board),
  % Recurse over every attack coordinate.
  attack(Rest, NewBoard).

% Display the current state of the Battleship board.
print_board(Board) -> 
  io:format("~s~n", ["Board ="]),
  io:format("~p~n", [array:to_list(Board)]).

% Call place_ships, attack, and print_board within this function.
driver(Coordinates, Targets) -> 
  % Create an array of 10 tuples, each containing 10 elements of "none".
  Board = array:new(10, {default,{none,none,none,none,none,none,none,none,none,none}}),

  battleship:print_board(Board),

  % Place ships onto board and print out result.
  io:format("~s~n", ["Placing ships..."]),
  BoardWithShips = battleship:place_ships(Coordinates, Board),
  battleship:print_board(BoardWithShips),

  % Attack the board that has ships on it and print out result.
  io:format("~s~n", ["Attacking..."]),
  AttackedBoard = battleship:attack(Targets, BoardWithShips),
  battleship:print_board(AttackedBoard).

% Helper function to convert letter coordinate to number so that 
% the array can be accessed by index.
letter_to_number(Letter) ->
  case Letter of
    Character when Character=:='a' -> 0;
    Character when Character=:='b' -> 1;
    Character when Character=:='c' -> 2;
    Character when Character=:='d' -> 3;
    Character when Character=:='e' -> 4;
    Character when Character=:='f' -> 5;
    Character when Character=:='g' -> 6;
    Character when Character=:='h' -> 7;
    Character when Character=:='i' -> 8;
    Character when Character=:='j' -> 9
  end.
