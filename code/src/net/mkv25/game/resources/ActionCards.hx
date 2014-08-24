package net.mkv25.game.resources;

class ActionCards
{
	public static var DATA:Dynamic = {
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
}