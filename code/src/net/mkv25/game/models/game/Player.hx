package net.mkv25.game.models.game;

import net.mkv25.base.core.CoreModel;

class Player extends CoreModel
{
	public var playerId(default, null):String;
	public var cards:PlayerHand;
	public var resources:Int;
	
	public function new() 
	{
		super();
	}
	
}