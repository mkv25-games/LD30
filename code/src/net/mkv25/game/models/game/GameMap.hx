package net.mkv25.game.models.game;

import net.mkv25.base.core.CoreModel;
import net.mkv25.base.core.ISerializable;

class GameMap extends CoreModel implements ISerializable
{
	public var archetype(default, null):MapArchetype;
	public var space(default, null):SpaceMap;
	public var worlds(default, null):Array<WorldMap>;
	
	public function new()
	{
		super();
		
		archetype = new MapArchetype();
		space = new SpaceMap();
		worlds = new Array<WorldMap>();
	}
	
	public function readFrom(object:Dynamic):Void
	{
		archetype = readObject("archetype", object, MapArchetype);
		space = readObject("space", object, SpaceMap);
		worlds = readArray("worlds", object, WorldMap);
	}
	
	public function serialize():Dynamic
	{
		var result:Dynamic = { };
		
		writeObject("archetype", result, archetype);
		writeObject("space", result, space);
		writeArray("worlds", result, worlds);
		
		return result;
	}
}