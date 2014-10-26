package net.mkv25.game.models.game;

class WorldMap extends Map
{
	public var spaceLocation:MapLocation;
	
	public function new() 
	{
		super();
		
		spaceLocation = new MapLocation();
	}
	
	override function readFrom(object:Dynamic):Void
	{
		super.readFrom(object);
		
		spaceLocation = readObject("spaceLocation", object, MapLocation);
	}
	
	public static function makeFrom(object:Dynamic):WorldMap
	{
		var map = new WorldMap();
		
		map.readFrom(object);
		
		return map;
	}
	
}