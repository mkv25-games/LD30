package net.mkv25.game.models;
import flash.display.Bitmap;
import net.mkv25.game.event.EventBus;

class HexTile
{
	public static var TQW:Float = 0.75; // three quarter width
	public static var HH:Float = Math.sqrt(3) / 4; // half height, based on a width of 1
	
	public static var NEIGHBOURS = [
	   [ 1, 0], [ 1, -1], [0, -1],
	   [-1, 0], [-1,  1], [0,  1]
	];
	
	public var q:Int;
	public var r:Int;
	
	public var map:MapModel;
	public var territoryOwner:PlayerModel;
	public var contested:Bool;
	
	public var bitmap:Bitmap;
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
		return q + "," + r;
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
	
	inline function checkContents() {
		if (contents == null) {
			this.contents = new Array<IMapThing>();
		}
	}
	
	public function updateTerritory():Void
	{
		// check for base, set territory
		for (thing in contents)
		{
			if (Std.is(thing, MapUnit))
			{
				var unit:MapUnit = cast thing;
				if (unit.type.base) {
					this.claim(unit.owner);
					
					// set territory for neighbouring hexes
					var neighbours = getNeighbours();
					for (hex in neighbours)
					{
						hex.claim(unit.owner);
					}
				}
			}
		}
	}
	
	public function containsBase(?player:PlayerModel):Bool
	{
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
	
	public function containsUnit(?player:PlayerModel):Bool
	{
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
		for (thing in contents)
		{
			if (Std.is(thing, MapModel))
			{
				var world:MapModel = cast thing;
				if (world.spaceHex != null)
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
		
		return neighbours;
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