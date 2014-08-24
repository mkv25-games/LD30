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
		
		hexes = MapModel.createCircle(3);
	}
	
	public static function createCircle(radius:Int):StringMap<HexTile>
	{
		var hexes = new StringMap<HexTile>();
		
		var hex:HexTile;
		for (i in -radius...radius+1) {
			for (j in -radius...radius+1) {
				if(Math.abs(i + j) <= radius) {
					hex = new HexTile();
					hex.q = i;
					hex.r = j;
					hexes.set(hex.key(), hex);
				}
			}
		}
		
		return hexes;
	}
	
	
}