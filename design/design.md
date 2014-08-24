
Introduction
============

Connected Worlds
----------------
This is a game design document for my Ludum Dare 30 entry. Consider it like a rule book for a table top game!

*Connect the worlds, rule the universe*

Description
-----------
A deck building 4x space adventure game, (in space!)

### Explore:
+ Move units out into space
+ Space is not so big
+ Hex tiles for movement between worlds
	
### Expand:
+ Build bases to claim territory
+ Planets are like space but with borders
+ Deploy new units and bases from cards in your hand
+ Connect worlds using portals at bases
	
### Exploit:
+ Harvest resources from bases
+ Buy new cards using resources
+ Research new actions for your desk with Scientists
+ Build units into your deck using Engineers
	
### Exterminate:
+ Destroy those pesky xenos by amassing a force strong enough to beat them
+ Capture enemy bases

Gameplay
========
	
Winning the game
----------------
+ MASTER OF EXPANSION - (short) create a base on three different worlds AND have the most territory.
+ ALL YOUR BASE ARE BELONG TO US - (medium) capture all bases belonging to your enemies.
+ WAR, WAR NEVER CHANGES, WAR NEVER ENDS - (long) destroy all units and bases belonging to your enemies.
	
Order of the game
-----------------
1. Setup
2. Start a new round
2. Each player takes their turn
3. At the end of each round, check winning conditions
4. Start a new round (cont.)

Setup
-----
1. Add 1 planet board for each player in the game
2. For each world board, add a corresponding planet counter to the space map on one of the homeworld (H) hexes.
3. Each player gets 1 base on a world of their choosing (fight!)
4. Each player gets a starting deck of 10 cards - 3 Harvester, 1 Portal, 2 Scientst, 2 Engineers, 2 Assault Team
5. Each player shuffles their starting deck
6. Choose Player 1 - humans automatically go first. If there is more than one human, then the youngest human goes first.
7. Play goes clockwise from Player 1
	
Order of a round
----------------
1. Each player plays in turn, completing all their steps before moving on to the next player
2. At the end of each round, check the winning conditions, if two players are tied for victory, the game continues
	
Order of a turn
---------------
1. The active player draws up to 5 cards from their deck pile into their hand - if there are not enough cards to draw, shuffle the discard pile into a new deck
2. Play each card in the hand, cards do not have to be played
3. Move all cards from active player's hand, played and unplayed, into that player's discard pile
4. If the player's deck is empty, shuffle the discard pile to create a new deck
5. A player may draw 5 new cards immediately at the end of their turn to help them decide on their next turn
	
Rules
=====

Card Terminology
----------------
+ **Deck** - all of the cards that the player owns, that have not been played
+ **Discard pile** - cards that the player owns that have been played, they cannot be replayed until they have been shuffled back into the deck - each player has their own discard pile
+ **Hand** - the cards that the player currently has in play
	
Map Terminology
---------------
+ **Space** - the area of hexes that represents interplanetary space 
+ **Planet** - a planet is an area of hexes that represents the surface of a planet
+ **Hex / Hexes** - a tile representing a location in Space or on a Planet - these are used to activate movement and combat
+ **Base** - a base is an outpost (or city) in your civilisation - bases are used to control territory
+ **Unit** - units are either 
	
Cards and the Player's Deck
---------------------------
+ The player performs actions using cards in their hand.
+ Cards have various actions that can be performed to move units, to harvest resources, or to buy new cards.
+ Cards represent the collective knowledge, skills, and resources of your civilisation.
+ There are two types of cards, actions and units.

Action cards
------------
+ Action cards can be played in two ways; as movement, or as the special action at the bottom of the card.
+ Types of special actions include: Research, Gather Resources, Connect Bases, and Build Units.
+ Movement allows you to move a single unit or a base by the distance specified on the card. 
	
Unit cards
----------
+ Unit cards can only be deployed, this allows a unit or a base to be placed on to the interactive map within your territory.
+ Deploying a unit card removes this card from your deck.
	
Movement
--------
+ To move a unit, you must play an action card. This action card cannot be played for its special action on this turn.
+ Units can move up to the number of hexes or portal jumps on the card.
+ Moving between hexes, hexes must be adjacent.
+ Moving along portal jumps costs one movement, and allows units to jump between bases. A portal connection must already exist, created using the Connect Bases action.
+ If entering a hex with another player's unit or base, then movement ends, and combat begins. If the unit survives, it can no longer move this turn.
+ Bases can be moved like normal units. Units in the same tile as the base do not move with the base.
	
Movement restrictions
----------------------
+ Bases cannot exist in the same hex.
+ Ergo you cannot capture another base by moving a base into that hex.
+ You cannot move through enemy units, entering a hex with an enemy unit initiates combat.
+ A unit that engaged in combat this turn cannot be subsequently moved.
	
Moving bewteen Ground and Space
-------------------------------
+ A unit can be moved into space at a cost of 1, move the unit from the planet map into the corresponding hex in space. The unit must be in the 
+ A unit can be moved from space to a planet at a cost of 1, move that unit from the space hex to any territory you control on the planet
	
Combat rules
------------
+ Combat is calculated between only two units .
+ Multiple units attack in individual waves against a stacked defense.
+ Units can exist in the same tile, e.g. on top of bases.
+ Equal strength fights result in a loss of both units.
+ When there are multiple units in a tile, the lowest strength unit on each side fights first.
+ Unequal strength fights result in the loss of the lower strenth unit, no damage is incurred on the higher strength unit, and it will fight again in the next wave.
+ Ownership of a base will change if an enemy exists on the tile at the end of a turn's combat.
+ Units from opposing sides can not exist in the same tile an the end of a turn.
+ If a unit survives combat, it can no longer move this turn.
+ Bases can be destroyed if the attacking force has a stength equal to the base strength.

Special actions
---------------
+ *Gather resources* - play to gather resources, you get X resources for this action, where X is the value on the card. Standard harvesters gather 3 resources.
+ *Research* - research as an action allows the player to buy an action card to add to their deck. The player can choose any type of action card to buy provided they have enough resources.
+ *Build unit* - build unit as an action allows the player to buy a unit card to add to their deck. The player can choose any type of unit card to buy provided they have enough resources.
+ *Connect bases* - connect bases as an action allows a new portal to be formed between two bases. Any two bases that the player controls can be connected in this way.
+ *Deployment* - unit cards can be deployed to any valid territory hex within your empire. This action destroys the card, and spawns a unit of the same stength onto the map.
	
Resources and Buying Cards
--------------------------
+ The player has a total resource pool that persists between turns. There is no limit to the number of resources that a player can store.
+ Resources are used to buy cards, either through Research (e.g. using Scientists as an action), or Build Units (e.g. using Engineers as an action).
+ All cards have a resource cost. To buy a card, play the appropriate action, and simply deduct the resource cost of the card from your resource pool.
	
Territory
---------
+ Every base placed controls the territory for its hex, and the surrounding 6 hexes. (As such bases are worth 7 territory points.)
+ Adjacent bases from opposing empires can score from overlapping territory, this bonus does not apply to bases in the same empire.
+ When deploying a unit, that unit must be placed into a territory you own, i.e. on or adjacent to a base. 
+ Units in a hex do not count for territory, this is to prevent players spawning units at remote locations where there are no bases.
	
Action Card Types
=================
```javascript
{
	"Scientists": {
		cost: 5,
		movement: 1,
		action: "research",
		pictureTile: 0
	},
	"Engineers": {
		cost: 5,
		movement: 1,
		action: "build units",
		pictureTile: 1
	},
	"Portal": {
		cost: 8,
		movement: 2,
		action: "connect bases",
		pictureTile: 2
	},
	"Harvester": {
		cost: 3,
		movement: 3,
		action: "gather resources",
		resources: 3,
		pictureTile: 3
	},
	"Excavater": {
		cost: 6,
		movement: 2,
		action: "gather resources",
		resources: 4,
		pictureTile: 4
	},
	"Plasma Furnace": {
		cost: 9,
		movement: 1,
		action: "gather resources",
		resources: 5,
		pictureTile: 5
	}
};
```

Units and Unit Card Types
=========================
```javascript
{
	"Standard Base": {
		strength: 1,
		cost: 5,
		base: true,
		pictureTile: 6
	},
	"Advanced Base": {
		strength: 2,
		cost: 10,
		base: true,
		pictureTile: 7
	},
	"Outpost": {
		strength: 3,
		cost: 20,
		base: true,
		pictureTile: 8
	},
	"Metroplex": {
		strength: 4,
		cost: 40,
		base: true,
		pictureTile: 9
	},
	"Assault Team": {
		strength: 2,
		cost: 3,
		pictureTile: 12
	},
	"Armoured Core": {
		strength: 3,
		cost: 6,
		pictureTile: 13
	},
	"Titan Force": {
		strength: 4,
		cost: 12,
		pictureTile: 14
	},
	"Capital Army": {
		strength: 5,
		cost: 24,
		pictureTile: 15
	}
};
```

	
