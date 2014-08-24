package net.mkv25.game.models;

import haxe.ds.HashMap;
import haxe.ds.StringMap;
import net.mkv25.base.core.CoreModel;

class MapModel extends CoreModel
{
	public var hexes:StringMap<HexTile>;
	
	public function new() 
	{
		super();
		
		hexes = MapModel.createCircle(5);
	}
	
	public static function createCircle(radius:Int):StringMap<HexTile>
	{
		var hexes = new StringMap<HexTile>();
		
		var hex:HexTile;
		for (i in -radius...radius+1) {
			for (j in -radius...radius+1) {
				if(validCircleCoordinate(i, j, radius)) {
					hex = new HexTile();
					hex.q = i;
					hex.r = j;
					hexes.set(hex.key(), hex);
				}
			}
		}
		
		return hexes;
	}
	
	private static inline function validCircleCoordinate(q:Int, r:Int, radius:Int):Bool {
		return insideRadius(q, r, radius) && !isCorner(q, r, radius);
	}
	
	private static inline function insideRadius(q:Int, r:Int, radius:Int):Bool {
		return (Math.abs(q + r) <= radius);
	}
	
	private static inline function isCorner(q:Int, r:Int, radius:Int):Bool {
		return (Math.abs(q) == radius && r == 0) || (Math.abs(r) == radius && q == 0) || (Math.abs(q) == radius && Math.abs(r) == radius);
	}
	
	
}