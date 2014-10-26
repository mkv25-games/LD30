package net.mkv25.game.models.game;

import net.mkv25.base.core.CoreModel;
import net.mkv25.base.core.ISerializable;
import net.mkv25.base.core.Pointer;

class MapLocation extends CoreModel implements ISerializable
{
	private var mapPointer:Pointer<Map>;
	
	public var map(get, set):Null<Map>;
	public var q:Int;
	public var r:Int;
	public var key(get, null):String;

	public function new() 
	{
		super();
		
		mapPointer = new Pointer<Map>(null);
		q = 0;
		r = 0;
	}
	
	function get_map():Null<Map>
	{
		return mapPointer.value;
	}
	
	function set_map(value:Map):Null<Map>
	{
		mapPointer = new Pointer<Map>(value.mapId);
		
		return value;
	}
	
	function get_key():String
	{
		var key:String = "";
		
		if (map != null)
		{
			key += map.mapId + "_";
		}
		
		key += q + "_" + r;
		
		return key;
	}
	
	public function serialize():Dynamic
	{
		var result:Dynamic = { };
		
		write("map", result, mapPointer.serialize());
		write("q", result, q);
		write("r", result, r);
		
		return result;
	}
	
	public function readFrom(object:Dynamic):Void
	{	
		var mapId:String = read("map", object, null);
		this.mapPointer = new Pointer<Map>(mapId);
		
		this.q = readInt("q", object, 0);
		this.r = readInt("r", object, 0);
	}	
	
	public static function makeFrom(object:Dynamic):MapLocation
	{
		var location = new MapLocation();
		
		location.readFrom(object);
		
		return location;
	}
	
}