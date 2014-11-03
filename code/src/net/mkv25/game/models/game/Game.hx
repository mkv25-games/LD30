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
		
		readTurnModelFrom(object);
	}
	
	function readTurnModelFrom(object:Dynamic):Void
	{
		turnModel = new TurnModel<Pointer<Player>>();
		
		// create pointer array from active players list
		var activePlayers:Array<Pointer<Player>> = readPointerArray("activePlayers", object, Player);
		
		// search pointer array for matching player reference
		var activePlayer:Pointer<Player> = null;
		var activePlayerId:String = read("activePlayer", object);
		for (player in activePlayers)
		{
			if (player.serialize() == activePlayerId)
			{
				activePlayer = player;
			}
		}
		
		// pass the normalised data to the turn model
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