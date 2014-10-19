package net.mkv25.game.models;

import haxe.ds.StringMap.StringMap;
import net.mkv25.base.core.CoreModel;
import net.mkv25.base.core.ISerializable;

class HexMap
{
	public var list(get, null):StringMap<HexTile>;
	
	var map:StringMap<HexTile>;

	public function new() 
	{
		map = new StringMap<HexTile>();
	}
	
	public function get(q:Int, r:Int):HexTile
	{
		var key:String = q + "," + r;
		
		return map.get(key);
	}
	
	public function add(hex:HexTile):Void
	{
		var key:String = hex.q + "," + hex.r;
		
		map.set(key, hex);
	}
	
	function get_list():StringMap<HexTile>
	{
		return map;
	}
}