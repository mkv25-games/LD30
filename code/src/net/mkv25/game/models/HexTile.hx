package net.mkv25.game.models;

import flash.display.Bitmap;
import net.mkv25.game.event.EventBus;

class HexTile
{
	/* The ratio of width to height of a hex plotted in x, y coordinate space */
	public static var TQW:Float = 0.75; // three quarter width
	
	/* Half-height of a hexagon, based on a width of 1 */
	public static var HH:Float = Math.sqrt(3) / 4;
	
	/**
	 * Short hand lookup for neighbouring hexes, in axial space.
	 */
	public static var NEIGHBOURS = [
	   [ 1, 0], [ 1, -1], [0, -1],
	   [-1, 0], [-1,  1], [0,  1]
	];
	
	/* The hex coordinates in axial space.
	 * Read more at http://www.redblobgames.com/grids/hexagons/ */
	public var q:Int;
	public var r:Int;
	
	/* The map this hex belongs to */
	public var map:MapModel;
	
	/* The current known owner of this hex */
	public var territoryOwner:Null<PlayerModel>;
	
	/* Is ownership of this hex contested */
	public var contested:Bool;
	
	/* A* Pathfinding optimisation */
	public var searchId:Float;
	
	/* The display object associated with this hex tile */
	public var bitmap:Null<Bitmap>;
	
	/* The list of things at this location */
	private var contents:Array<IMapThing>;

	public function new() 
	{
		this.q = 0;
		this.r = 0;
	}
	
	public function x():Float {
		return q * HexTile.TQW;
	}
	
	public function y():Float {
		return (q + (2 * r)) * HexTile.HH;
	}
	
	public function key():String {
		var mapKey = (map == null) ? "" : map.key() + ",";
		return mapKey + q + "," + r;
	}
	
	public function neighbourKey(direction:Int):String {
		var d = HexTile.NEIGHBOURS[direction];
		return (q + d[0]) + "," + (r + d[1]);
	}
	
	public function add(thing:IMapThing):Void
	{
		checkContents();
		
		contents.push(thing);
		
		updateTerritory();
	}
	
	public function remove(thing:IMapThing):Void
	{
		checkContents();
		
		contents.remove(thing);
	}
	
	public function removeAll():Void
	{
		this.contents = new Array<IMapThing>();
	}
	
	public function listContents():Array<IMapThing>
	{
		checkContents();
		
		return contents;
	}
	
	public function listUnits():UnitList
	{
		var list:UnitList = new UnitList();
		var contents = listContents();
		
		for (thing in contents)
		{
			if (Std.is(thing, MapUnit))
			{
				var unit:MapUnit = cast thing;
				list.addUnit(unit);
			}
		}
		
		return list;
	}
	
	inline function checkContents()
	{
		if (contents == null)
		{
			this.contents = new Array<IMapThing>();
		}
	}
	
	public function updateTerritory():Void
	{
		if (contents == null)
		{
			return;
		}
		
		// check for base, set territory
		for (thing in contents)
		{
			if (Std.is(thing, MapUnit))
			{
				var unit:MapUnit = cast thing;
				if (unit.type.base) {
					this.claim(unit.owner);
					
					// on planets, set territory for neighbouring hexes
					if (this.map.isWorld())
					{
						var neighbours = getNeighbours();
						for (hex in neighbours)
						{
							hex.claim(unit.owner);
						}
					}
				}
			}
		}
	}
	
	public function containsBase(?player:PlayerModel):Bool
	{
		checkContents();
		
		for (thing in contents)
		{
			if (Std.is(thing, MapUnit))
			{
				var unit:MapUnit = cast thing;
				if (unit.type.base)
				{
					if (player == null)
					{
						// hex contains any base for any player
						return true;
					}
					
					// hex contains a base for a specific player
					return (unit.owner == player);
				}
			}
		}
		return false;
	}
	
	public function getBase():Null<MapUnit>
	{
		checkContents();
		
		for (thing in contents)
		{
			if (Std.is(thing, MapUnit))
			{
				var unit:MapUnit = cast thing;
				if (unit.type.base)
				{
					return unit;
				}
			}
		}
		return null;
	}
	
	public function containsUnit(?player:PlayerModel):Bool
	{
		checkContents();
		
		for (thing in contents)
		{
			if (Std.is(thing, MapUnit))
			{
				var unit:MapUnit = cast thing;
				if (player == null)
				{
					// hex contains any base for any player
					return true;
				}
				
				// hex contains a base for a specific player
				return (unit.owner == player);
			}
		}
		return false;
	}
	
	public function containsWorld():Bool
	{
		checkContents();
		
		for (thing in contents)
		{
			if (Std.is(thing, MapModel))
			{
				var map:MapModel = cast thing;
				if (map.isWorld())
				{
					return true;
				}
			}
		}
		return false;
	}
	
	public function claim(player:PlayerModel):Void
	{
		if (this.contested)
		{
			return;
		}
		if (this.territoryOwner == null)
		{
			this.territoryOwner = player;
		}
		else if(this.territoryOwner != player)
		{
			this.contested = true;
			this.territoryOwner = null;
		}
	}
	
	public function resetOwnership():Void
	{
		this.territoryOwner = null;
		this.contested = false;
	}
	
	public function getNeighbours():Array<HexTile>
	{
		var neighbours = new Array<HexTile>();
		
		if (map != null) {
			for (coord in HexTile.NEIGHBOURS)
			{
				var hex = map.getHexTile(q + coord[0], r + coord[1]);
				if (hex != null) {
					neighbours.push(hex);
				}
			}
		}
		
		addNeighboursConnectedByPortals(neighbours);
		
		return neighbours;
	}
	
	function addNeighboursConnectedByPortals(neighbours:Array<HexTile>):Void
	{
		var unit:Null<MapUnit> = getBase();
		if (unit != null && unit.hasConnections())
		{
			for (connection in unit.listConnections().list())
			{
				var neighbouringLocation = connection.lastKnownLocation;
				var hex = neighbouringLocation.map.getHexTile(neighbouringLocation.q, neighbouringLocation.r);
				if (hex != null)
				{
					neighbours.push(hex);
				}
			}
		}
	}
	
	/**
	 * Equal if location coordinates are equal, does not consider contents
	 * @param	hex
	 * @return  true if equal, false if not
	 */
	public function equals(hex:HexTile):Bool
	{
		return (
			this.q == hex.q &&
			this.r == hex.r &&
			this.map == hex.map
		);
	}
	
	/// Static helper methods ///
	
	public static function xy2qr(x:Float, y:Float):Array<Int>
	{
		var q = x / HexTile.TQW;
		var r = ((y / HexTile.HH) - q) / 2;
		
		return [Math.round(q), Math.round(r)];
	}
}