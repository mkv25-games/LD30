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
	public var spaceHex:HexTile;
	
	public function new() 
	{
		super();
		
		hexes = new StringMap<HexTile>();
		
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
	
	public function indexTiles():Void
	{
		for (hex in hexes)
		{
			hex.map = this;
		}
	}
	
	public function recalculateTerritory():Void
	{
		// reset all tiles
		for (hex in hexes)
		{
			hex.resetOwnership();
		}
		
		// recalcuate all tiles
		for (hex in hexes)
		{
			hex.updateTerritory();
		}
	}
	
	public function isWorld():Bool
	{
		return (this.spaceHex != null);
	}
	
	public static function createCircle(radius:Int):StringMap<HexTile>
	{
		var hexes = new StringMap<HexTile>();
		
		for (i in -radius...radius+1) {
			for (j in -radius...radius+1) {
				if(validCircleCoordinate(i, j, radius)) {
					safeAdd(hexes, i, j);
				}
			}
		}
		
		return hexes;
	}
	
	public static function createRectangle(width:Int, height:Int):StringMap<HexTile>
	{
		var hexes = new StringMap<HexTile>();
		var offset_x = -Math.floor(width / 2);
		var offset_y = -Math.floor(height / 2);
		
		for (j in 0...width) {
			for (i in 0...height) {
				var q = j + offset_x;
				var r = i + offset_y;
				safeAdd(hexes, q,  r - Math.floor(q / 2));
			}
		}
		
		return hexes;
	}
	
	public static function safeAdd(hexes:StringMap<HexTile>, q:Int, r:Int):Void
	{
		if(!hexes.exists(q + "," + r)) {
			var hex = new HexTile();
			hex.q = q;
			hex.r = r;
			hexes.set(hex.key(), hex);
		}
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