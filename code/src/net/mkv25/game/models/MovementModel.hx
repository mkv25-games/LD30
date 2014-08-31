package net.mkv25.game.models;

import haxe.ds.StringMap;

class MovementModel
{
	public static function getValidMovementDestinationsFor(location:HexTile, unit:MapUnit, distance:Int):Array<HexTile>
	{
		// check for the real location
		location = location.map.getHexTile(location.q, location.r);
		
		var validHexes:Array<HexTile> = new Array<HexTile>();
		
		var neighbouringHexes:StringMap<HexTile> = new StringMap<HexTile>();
		neighbouringHexes.set(location.key(), location);
		
		// iterate over neighbours, adding more neighbours
		for (i in 0...distance)
		{
			for (hex in neighbouringHexes)
			{
				addValidNeighboursFor(hex, unit, neighbouringHexes);
			}
		}
		
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
	
	public static function addValidNeighboursFor(location:HexTile, unit:MapUnit, map:StringMap<HexTile>):Void
	{
		// Rule: players can move units to adjacent tiles on the same map
		var neighbouringHexes:Array<HexTile> = location.getNeighbours();
		
		// populate map with neighbouring hexes, avoiding to add duplicates
		for (hex in neighbouringHexes)
		{
			if (!map.exists(hex.key()))
			{
				map.set(hex.key(), hex);
			}
		}
		
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
						if (!map.exists(hex.key()))
						{
							map.set(hex.key(), hex);
						}
					}
				}
			}
		}
		else
		{
			// Rule: players can move from any tile on a planet into space above the planet
			var hex = location.map.getSpaceHex();
			if (!map.exists(hex.key()))
			{
				map.set(hex.key(), hex);
			}
		}
		
		// TODO: Rule: players can move units between bases connected by portals
	}
	
	public static function getWorldFrom(location:HexTile):MapModel
	{
		var contents = location.listContents();
		for (thing in contents)
		{
			if (Std.is(thing, MapModel))
			{
				var map:MapModel = cast thing;
				if (map.isWorld())
				{
					return map;
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