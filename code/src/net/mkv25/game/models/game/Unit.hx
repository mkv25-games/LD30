package net.mkv25.game.models.game;

import net.mkv25.base.core.CoreModel;
import net.mkv25.base.core.ISerializable;
import net.mkv25.base.core.Pointer;

class Unit extends CoreModel implements ISerializable
{
	public var type(default, null):Pointer<Card>;
	public var location(default, null):MapLocation;
	public var owner(default, null):Pointer<Player>;
	
	public function new() 
	{
		super();
	}
	
	public function readFrom(object:Dynamic):Void
	{
		type = new Pointer<Card>(read("type", object), Card);
		location = readObject("location", object, MapLocation);
		owner = new Pointer<Player>(read("owner", object), Player);
	}
	
	public function serialize():Dynamic
	{
		var result:Dynamic = { };
		
		writeObject("type", result, type);
		writeObject("location", result, location);
		writeObject("owner", result, owner);
		
		return result;
	}
	
}