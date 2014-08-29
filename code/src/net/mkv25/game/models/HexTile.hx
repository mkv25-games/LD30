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
		
		updateTerritory(thing);
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
	
	function updateTerritory(thing:IMapThing):Void
	{
		// check for base, set territory
		if (Std.is(thing, MapUnit))
		{
			var unit:MapUnit = cast thing;
			if (unit.type.base) {
				this.territoryOwner = unit.owner;
				
				// set territory for neighbouring hexes
				var neighbours = getNeighbours();
				for (hex in neighbours)
				{
					hex.territoryOwner = unit.owner;
				}
			}
		}
		else
		{
			this.territoryOwner = null;
		}
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
	
	public static function xy2qr(x:Float, y:Float):Array<Int>
	{
		var q = x / HexTile.TQW;
		var r = ((y / HexTile.HH) - q) / 2;
		
		return [Math.round(q), Math.round(r)];
	}
}