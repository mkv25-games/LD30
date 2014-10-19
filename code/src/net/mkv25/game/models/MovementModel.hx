package net.mkv25.game.models;

import haxe.ds.StringMap;
import net.mkv25.base.core.TimeProfile;

class MovementModel
{
	private static var searchCount:Float = 0;
	
	public static function getValidMovementDestinationsFor(location:HexTile, unit:MapUnit, distance:Int):StringMap<HexTile>
	{
		TimeProfile.logEvent("MovementModel:getValidMovement*");
		
		MovementModel.searchCount++;
		
		// check for the real location
		location = location.map.getHexTile(location.q, location.r);
		
		var movementMap:StringMap<HexTile> = new StringMap<HexTile>();
		movementMap.set(location.key(), location);
		
		// iterate over neighbours, adding more neighbours
		for (i in 0...distance)
		{
			for (hex in movementMap)
			{
				if (hex != null)
				{
					addValidNeighboursFor(hex, unit, movementMap);
				}
			}
		}
		
		// Remove the original tile if it has been added back
		if (movementMap.exists(location.key()))
		{
			movementMap.remove(location.key());
		}
		
		return movementMap;
	}
	
	public static function addValidNeighboursFor(location:HexTile, unit:MapUnit, hexes:StringMap<HexTile>):Void
	{
		TimeProfile.logEvent("MovementModel:addValidNeighboursFor");
		
		var searchId = searchCount;
		
		// Rule: units cannot move through contested hexes
		if (CombatModel.containsEnemyCombatants(unit.owner, location))
		{
			return;
		}
		
		// Rule: players can move units to adjacent tiles on the same map
		var neighbouringHexes:Array<HexTile> = location.getNeighbours();
		
		// populate map with neighbouring hexes, avoiding to add duplicates
		for (hex in neighbouringHexes)
		{
			if (hex.searchId == searchId)
			{
				continue;
			}
			
			if (!hexes.exists(hex.key()))
			{
				hexes.set(hex.key(), hex);
				hex.searchId = searchId;
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
					for (hex in world.hexes.list)
					{
						if (hex.searchId == searchId)
						{
							continue;
						}
						
						if (!hexes.exists(hex.key()))
						{
							hexes.set(hex.key(), hex);
							hex.searchId = searchId;
						}
					}
				}
			}
		}
		else
		{
			// Rule: players can move from any tile on a planet into space above the planet
			var hex = location.map.getSpaceHex();
			if (hex.searchId != searchId && !hexes.exists(hex.key()))
			{
				hexes.set(hex.key(), hex);
				hex.searchId = searchId;
			}
		}
		
		// TODO: Rule: players can move units between bases connected by portals
		
		// Validate each neighbour
		for (hex in neighbouringHexes)
		{
			if (unit.type.base && hex.containsBase())
			{
				// Rule: players cannot move a base unit into a tile with another base unit
				hexes.remove(hex.key());
			}
		}
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
	
	public static function mapContainsLocation(hexes:StringMap<HexTile>, location:HexTile):Bool
	{
		return hexes.exists(location.key());
	}
}