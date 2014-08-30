package net.mkv25.game.models;

class MovementModel
{
	public static function getValidMovementDestinationsFor(location:HexTile, unit:MapUnit):Array<HexTile>
	{
		var validHexes:Array<HexTile> = new Array<HexTile>();
		
		// Rule: players can move units to adjacent tiles on the same map
		var neighbouringHexes:Array<HexTile> = location.getNeighbours();
		
		// add space-world and world-space boundary hexes
		if (location.map == Index.activeGame.space)
		{
			if (location.containsWorld())
			{
				// Rule: players can move from a space tile to any location on a world in that space tile
				var world:MapModel = MovementModel.getWorldFrom(location);
				if (world != null)
				{
					for (hex in world.hexes)
					{
						neighbouringHexes.push(hex);
					}
				}
			}
		}
		else
		{
			// Rule: players can move from any tile on a planet into space above the planet
			neighbouringHexes.push(location.map.spaceHex);
		}
		
		// TODO: Rule: players can move units between bases connected by portals
		
		// validate each neighbour
		for (hex in neighbouringHexes)
		{
			if (unit.type.base && hex.containsBase())
			{
				// Rule: players cannot move a base unit into a tile with another base unit
			}
			else
			{
				validHexes.push(hex);
			}
		}
		
		return validHexes;
	}
	
	public static function getWorldFrom(location:HexTile):MapModel
	{
		var contents = location.listContents();
		for (thing in contents)
		{
			if (Std.is(thing, MapModel))
			{
				var world:MapModel = cast thing;
				if (world.spaceHex != null)
				{
					return world;
				}
			}
		}
		return null;
	}
	
	public static function listContainsLocation(hexes:Array<HexTile>, location:HexTile):Bool
	{
		for (hex in hexes)
		{
			// validate that marked location is in the list of valid destination
			if (hex.equals(location))
			{
				return true;
			}
		}
		
		return false;
	}
}