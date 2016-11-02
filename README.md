# tictactoe
Tic-Tac-Toe game for iOS (1-2 players)

# Overview

This is a basic Tic-Tac-Toe app for iOS 10 developed using Swift 3.0 and XCode. The game offers 1-player and 2-player options.

# AI

The AI was programmed to do the following instructions from highest to lowest priority:

1. Take the center space if available

2. If there is an open space that is adjacent to two other of the AI's spaces (horizontal, vertical, or diagonal), take the spot for a win.

3. If the opponent (human player) has an open space that is adjacent to two of their spaces (horizontal, vertical, or diagonal), take the
spot to prevent them from winning.

4. Randomly generate a number between 1-9 and take the space corresponding to said number if space is available.

# Possible improvements

One feature I was considering implementing was keeping track of the score between the player(s)/AI so that multiple games can be played with
a collective number of wins for each side.

Besides that, updating the graphics for the board/spaces to be more colorful is a simple solution by just replacing the images within the 
ViewController.
