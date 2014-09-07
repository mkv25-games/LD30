package net.mkv25.game.resources;

class ActionCards
{
	public static var DATA:Dynamic = {
		"Scientists": {
			cost: 5,
			movement: 2,
			action: "research",
			pictureTile: 0
		},
		"Engineers": {
			cost: 5,
			movement: 2,
			action: "build units",
			pictureTile: 1
		},
		"Portal": {
			cost: 10,
			movement: 3,
			action: "connect bases",
			pictureTile: 2
		},
		"Harvester": {
			cost: 4,
			movement: 1,
			action: "gather resources",
			resources: 2,
			pictureTile: 3
		},
		"Excavater": {
			cost: 7,
			movement: 1,
			action: "gather resources",
			resources: 3,
			pictureTile: 4
		},
		"Plasma Furnace": {
			cost: 10,
			movement: 0,
			action: "gather resources",
			resources: 5,
			pictureTile: 5
		}
	};
}