package net.mkv25.game.models.game;

import net.mkv25.base.core.CoreModel;

class GameMap extends CoreModel
{
	public var seed(default, null):MapSeed;
	public var space(default, null):SpaceMap;
	public var worlds(default, null):Array<WorldMap>;
	
	public function new()
	{
		super();
	}
}