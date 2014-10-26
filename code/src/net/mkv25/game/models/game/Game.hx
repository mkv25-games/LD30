package net.mkv25.game.models.game;

import net.mkv25.base.core.CoreModel;

class Game extends CoreModel
{
	public var units(default, null):Array<Unit>;
	public var map(default, null):GameMap;
	public var players(default, null):Array<Player>;
	public var turnModel(default, null):TurnModel<Player>;
	public var cards(default, null):Array<Card>;
	
	public function new() 
	{
		super();
	}
	
}