
# Database

## GrabIt's database serves multiple purposes:
  * Serve as a Login database for users with Email && Password or solely on Google sign in 
  * Serve as multyplayer info listener between different devices
  * Serve as a database for avatar for logged in user
  * Serve as in-game manager during play

## GrabIt's database main elements:
> Firebase authentication table- to utilize Firebase's various authentication functions
* [ ] Email- unique identifier for the other collections.
* [ ] In addition to the standard email and password sign in, sign in by Google is possible
> Avatar info- Individual user's avatar. Identified by the user's email
> A user can join or host a game with friends using unique string 
> A user can change his nickname for games
> When Firebase detects user logged out of the game, it closes the relevant doc and return a quit message for players

## Localization:
> A previously signed user can enter the game and be signed in 
> When a firebase signed in user decides to sign up with google, transfer his info
> A previously signed user will recieve his chosen avatar for the game 

## Firebase Flow

![FirebaseFlow](https://user-images.githubusercontent.com/57787325/176020260-decead1a-ad64-46a8-b3a2-59442e6f5ac5.jpeg)
