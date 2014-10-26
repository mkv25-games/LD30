package net.mkv25.game.models.game;

import haxe.ds.StringMap;
import net.mkv25.base.core.CoreModel;
import net.mkv25.base.core.ISerializable;

class Map extends CoreModel implements ISerializable
{
	public var mapId(default, null):String;
	public var hexes(default, null):StringMap<MapLocation>;
	
	public function new() 
	{
		super();
		
		mapId = null;
		hexes = new StringMap<MapLocation>();
	}
	
	public function serialize():Dynamic
	{
		var result:Dynamic = { };
		
		write("mapId", result, mapId);
		writeArray("hexes", result, Lambda.array(hexes));
		
		return result;
	}
	
	public function readFrom(object:Dynamic):Void
	{
		mapId = read("mapId", object, null);
		
		var hexArray = readArray("hexes", object, MapLocation);
		for (hex in hexArray)
		{
			hexes.set(hex.key, hex);
		}
	}
	
	public static function makeFrom(object:Dynamic):Map
	{
		var map = new Map();
		
		map.readFrom(object);
		
		return map;
	}
}