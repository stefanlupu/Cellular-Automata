# Langton's Ant

My implementation of Langton's Ant written in Lua using the Love2D framework. For more information please visit
[Langton's Ant Wiki page](https://en.wikipedia.org/wiki/Langton%27s_ant).

### DISCLAIMER: 
- you must have both Lua and Love2D installed on your system for this program to work
- Windows and Mac OS have not been tested on but should in theory work

### CONTROLS:
- `space` pause/unpause the game
- `r` populate the screen with a randomised set of ants 
- `esc` quit the application

### PLEASE NOTE:
My current implementation stops any ant from moving outise the screen. That is why some will seem 'dead' if they either spawn
right on the edge or once in the 'highway' stage they reach the edge of the screen.

### TO RUN:
1. change into the directory that contains the folder: Ant
2. run `love Ant` into your terminal
