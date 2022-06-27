
# Models

In order to simplify the code and the user experience,
GrabIt contains several models. 
 In this document, we will describe each model's purpose
and its attributes


## Card model

> The card model is a model that used to manage any in-game card

* [ ] cardImage - an svg/png that is reserved locally and initialized when entering the game
* [ ] cardColor - each regular card has 4 colors {BLUE,GREEN,RED,YELLOW}
* [ ] cardUnique - There are 3 unique cards: Inside arrows, Outside arrows, Colored arrows
* [ ] all cards are being saved and presented in a deck

## playerDeck model

> The playerDeck contains the player cards, it holds different types, colors and uniques

* [ ] cardsHandler - contains the entire logics that manages and control the cards in deck
* [ ] index - contains the player index in the multiplayer game
* [ ] all decks are reserved in an array and are assigned to players

## playerManager model
> The playerManager model is used to represent a player in the table, it also connects the local data to firebase database

* [ ] playerNickname - contains the player nickname from the entry screen and uploads to firebase
* [ ] connectedNumber - contains the player index and in-game number for game management
* [ ] deckHandler - contains the deck logic and firebase uploads


## gameTable model
> The gameTable model is used to create a game, initilize all database data and images,
> set all the players location, give indexes and manage and game while uploading to firebase database

* [ ] avatars - contains the players avatars
* [ ] nicknames - contains the player nicknames
* [ ] gameNum - contains the firestore current game number
* [ ] playerIndex - contains a nullable array consisting of atlease 3 players

## waitingRoom model
> The waitingRoom model is used to determine how to initialize the game, by the changing number of players
> also to upload and initialize the database gameNumber and arrays for in-game 

* [ ] _connectedNum - contains a nullable array consisting of atlease 3 players
* [ ] _waitTime - wait time for players to join
* [ ] cardsArr = contains a nullable array consisting of in-game cards management between players
* [ ] _avatars = retrieves the player avatar from firebase and initialize it in the game

## totem Workspace model
> The totem model is the heart of the game, most of the game logics go through here
> when the totem is pressed, it determines which deviced has pressed it and acts accordingl
> and updates the database

* [ ] gameNum - contains the firestore current game number
* [ ] playersNumber - contains the playerNumbers array
* [ ] matchingColorCards - contains a nullable array with the size of the number of players, and can determine if there are 2 	cards (or more) with the same color in O(1)
* [ ] matchingRegularCards - contains a nullable array consisting of number of different cards ~/ 4 (4 colors) and can determine if there are 2 cards (or more) with the same shape in O(1)
* [ ] cardsGroupArray - contains a nullable array consisting of the entire game table, and being uploaded to the database to communicate between different devices (O(1) before and adter uploading)
* [ ] uniqueArray - contains a nullable array consisting of the number of unique cards currently displayed in the game and there activation
* [ ] currentTurn - determines who the next player turn is


