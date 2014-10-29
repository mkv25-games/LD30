package net.mkv25.game.models.game;

import net.mkv25.base.core.CoreModel;
import net.mkv25.base.core.ISerializable;
import net.mkv25.game.models.TurnModel;

class Game extends CoreModel implements ISerializable
{
	public var units(default, null):Array<Unit>;
	public var map(default, null):GameMap;
	public var players(default, null):Array<Player>;
	public var turnModel(default, null):TurnModel<Player>;
	public var cards(default, null):Array<Card>;
	
	public function new() 
	{
		super();
		
		units = new Array<Unit>();
		map = new GameMap();
		players = new Array<Player>();
		turnModel = new TurnModel<Player>();
		cards = new Array<Card>();
	}
	
	public function readFrom(object:Dynamic):Void
	{
		
	}
	
	public function serialize():Dynamic
	{
		var result:Dynamic = { };
		
		writeArray("cards", result, cards);
		writeArray("units", result, units);
		
		return result;
	}
	
}