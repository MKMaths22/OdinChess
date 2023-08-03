# OdinChess
Follows the Odin Chess Assignment

This project uses the MIT License.

Credit to a user called u/tsojtsojtsoj on Reddit for their post which I saw at https://www.reddit.com/r/AnarchyChess/comments/cmbv5e/for_those_who_want_to_play_chess_in_a_terminal/ . I looked at their design of chess pieces and coded it myself I did not copy any code of theirs, but this saved some time working out where forward slashes, back slashes etc. should go.

Colorize license.
---------------------------------

license
Copyright (C) 2007-2016 Michał Kalbarczyk

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License along
with this program; if not, write to the Free Software Foundation, Inc.,
51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

-------------------------------

Author notes by Peter Hawes:

I feel quite content with most of the code, although some methods still have more arguments being fed into them than I would like ideally. YAML works beautifully for the saving of games, however it forgets that the hash @previous_positions in Result class has a default value of 0. This caused a quite puzzling bug until I realised what was happening and used .to_i in the Result class's #add_position method, converting an erroneous nil value to zero as needed.
A feature I am particularly pleased with is that the board displays as it would when playing at a real-life chessboard, so it turns 180 degrees when a move is made, ensuring that the player to move sees their pawns going up the board and their opponent's pawns coming down towards them. This is also how we usually see the board when playing online.
It is a lot of fun to generate two computer players and watch them play nonsense against each other --- usually they play out a draw by insufficient material. 
