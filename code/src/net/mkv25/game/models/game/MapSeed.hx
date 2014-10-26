package net.mkv25.game.models.game;

import net.mkv25.base.core.CoreModel;

class MapSeed extends CoreModel
{
	public var type(default, null):MapType;

	public function new() 
	{
		super();
	}
	
}