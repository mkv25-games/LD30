package net.mkv25.game.models.game;

import net.mkv25.base.core.CoreModel;
import net.mkv25.base.core.Pointer;

class Unit extends CoreModel
{
	public var type(default, null):Pointer<Card>;
	public var location(default, null):MapLocation;
	public var owner(default, null):Pointer<Player>;
	
	public function new() 
	{
		super();
	}
	
}