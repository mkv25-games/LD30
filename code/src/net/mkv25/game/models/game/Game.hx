package net.mkv25.game.models.game;

import net.mkv25.base.core.CoreModel;
import net.mkv25.base.core.ISerializable;
import net.mkv25.base.core.Pointer;
import net.mkv25.game.models.TurnModel;

class Game extends CoreModel implements ISerializable
{
	public var units(default, null):Array<Unit>;
	public var map(default, null):GameMap;
	public var players(default, null):Array<Player>;
	public var cards(default, null):Array<Card>;
	
	public var turnModel(default, null):TurnModel<Pointer<Player>>;
	
	public function new() 
	{
		super();
		
		units = new Array<Unit>();
		map = new GameMap();
		players = new Array<Player>();
		cards = new Array<Card>();
		
		turnModel = new TurnModel<Pointer<Player>>();
	}
	
	public function readFrom(object:Dynamic):Void
	{
		units = readArray("units", object, Unit);
		map = readObject("map", object, GameMap);
		players = readArray("players", object, Player);
		cards = readArray("cards", object, Card);
		
		turnModel = new TurnModel<Pointer<Player>>();
		var activePlayers:Array<Pointer<Player>> = readPointerArray("activePlayers", object, Player);
		var activePlayer:Pointer<Player> = new Pointer<Player>(read("activePlayer", object), Player);
		turnModel.readFrom(activePlayers, activePlayer);
	}
	
	public function serialize():Dynamic
	{
		var result:Dynamic = { };
		
		writeArray("activePlayers", result, turnModel.toArray());
		writeObject("activePlayer", result, turnModel.activePlayer);
		
		writeArray("units", result, units);
		writeObject("map", result, map);
		writeArray("players", result, players);
		writeArray("cards", result, cards);
		
		return result;
	}
	
}