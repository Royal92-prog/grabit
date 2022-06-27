# Algorithms

* GrabIt, as a realtime multiplayer game, can be difficult to execute.
*  The purpose of this section is to explain the algorithms and implementations that GrabIt uses in its files.
  
*  It is no secret that a realtime multiplayer requires high level sync between different devices, be it 3,4 or 5 players.

## Basic information:

* Sync between 3/4/5 players
* Contains 72 Regular cards and 6 unique cards (3 sets of 2)
* Change in-game rules by different scenarios
* Operate as fast as possible

## Localization

* As many local data as possible - all card images are stored locally, so it won't use api request to retrieve photo
* In-game buttons - buttons such as: "Play","Play with friends", "Totem" are stored locally

## Lazy Evaluation

* Use database api call only if and when nessesary using shared array
* Compare cards logic is based on hash table by the derivative of 4
* On every player's turn a counter of array in index ~/4 is increased and decreased accordingly
* Use totem synconization by locking it as soon as a player has clicked it
* Uploading avatars doesn't lock the game and continue in the background
