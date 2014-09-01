package net.mkv25.game.models;
import haxe.ds.StringMap;

class WorldList
{
	private var worlds:StringMap<MapModel>;

	public function new() 
	{
		this.worlds = new StringMap<MapModel>();
	}
	
	public function length():Int
	{
		var count:Int = 0;
		for (world in worlds)
		{
			if (world != null)
			{
				count++;
			}
		}
		
		return count;
	}
	
	public function list():Array<MapModel>
	{
		var list = new Array<MapModel>();
		for (world in worlds)
		{
			list.push(world);
		}
		return list;
	}
	
	public function contains(map:MapModel):Bool
	{
		if (map == null)
		{
			return false;
		}
		
		return worlds.exists(map.key());
	}
	
	public function addWorld(map:MapModel):Void
	{
		if (!map.isWorld())
		{
			throw "Specified map is not designated as a world.";
		}
		
		worlds.set(map.key(), map);
	}
	
	public function removeWorld(world:MapModel):Bool
	{
		if (world == null)
		{
			return false;
		}
		
		return this.worlds.remove(world.key());
	}
	
	public function removeAll():Void
	{
		var keys = new Array<String>();
		for (key in worlds.keys())
		{
			keys.push(key);
		}
		
		for (key in keys)
		{
			worlds.remove(key);
		}
	}	
}