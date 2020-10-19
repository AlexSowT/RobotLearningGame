# Robot learning game
## Premise

This is a simulation made using Processing. It features two teams of robots fighting to control all points on the map.
To do this, the robots must collect food and use it. There are two uses for food:
- Depost food into a node of the same colour and build a new robot
- Depost food into a node not controlled by the team to take it over.

For either option, a total of 10 deposist will complete it. IE 10 deposits will build a new robot. 

The robots teams when created at the begining of the game are assigned a random chance to do one action more than the other. This is called their Gene. 

When one team wins, the losing team generates a new gene, and the winning team retains there gene.

In this way, the two teams move towards the optimum balance of growth vs control.

![Screenshot of game](/robot1.png)
Format: ![Alt Text](url)
