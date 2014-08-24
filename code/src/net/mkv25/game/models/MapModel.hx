package net.mkv25.game.models;

import flash.display.BitmapData;
import haxe.ds.HashMap;
import haxe.ds.StringMap;
import net.mkv25.base.core.CoreModel;

class MapModel extends CoreModel implements IMapThing
{
	public var hexes:StringMap<HexTile>;
	
	public var background:BitmapData;
	public var mapIcon:BitmapData;
	public var mapDepth:Int;
	
	public function new() 
	{
		super();
		
		hexes = MapModel.createCircle(5);
		
		background = null;
		mapIcon = null;
		mapDepth = 0;
	}
	
	public function setup(background:BitmapData, mapIcon:BitmapData):Void
	{
		this.background = background;
		this.mapIcon = mapIcon;
	}

	public function getIcon():BitmapData 
	{
		return this.mapIcon;
	}
	
	public function getDepth():Int 
	{
		return this.mapDepth;
	}
	
	public function getHexTile(q:Int, r:Int):Null<HexTile>
	{
		var key:String = q + "," + r;
		
		return hexes.get(key);
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