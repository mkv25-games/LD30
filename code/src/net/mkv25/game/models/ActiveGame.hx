package net.mkv25.game.models;

import net.mkv25.base.core.CoreModel;
import net.mkv25.game.event.EventBus;
import openfl.Assets;

class ActiveGame extends CoreModel
{
	public var players:Array<PlayerModel>;
	public var activePlayer:PlayerModel;
	
	public var space:MapModel;
	public var worlds:Array<MapModel>;
	
	public function new(numberOfPlayers:Int) 
	{
		super();
		
		validateNumberOfPlayers(numberOfPlayers);
		createMaps(numberOfPlayers);
		createPlayers(numberOfPlayers);
	}
	
	function validateNumberOfPlayers(numberOfPlayers:Int):Void
	{
		if (numberOfPlayers < 1) {
			throw "Cannot play the game with less then one player.";
		}
		
		if (numberOfPlayers > 6)
		{
			throw "Cannot play the game with more then 6 players";
		}
	}
	
	function createMaps(numberOfPlayers:Int):Void
	{
		space = new MapModel();
		space.background = Assets.getBitmapData("img/starfield-small.png");
		
		worlds = new Array<MapModel>();
		// central world, always present
		addWorld(0, 0, 14, "img/planet05.png");
		
		// player worlds, ideally variable based on number of players
		addWorld(0, 0, 10, "img/planet01.png");
		addWorld(0, 0, 11, "img/planet02.png");
		addWorld(0, 0, 12, "img/planet03.png");
		addWorld(0, 0, 13, "img/planet04.png");
		addWorld(0, 0, 15, "img/planet06.png");
		addWorld(0, 0, 16, "img/planet07.png");
	}
	
	function addWorld(r:Int, q:Int, id:Int, backgroundAsset:String):Void
	{
		var world:MapModel = new MapModel();
		world.background = Assets.getBitmapData(backgroundAsset);
		
		worlds.push(world);
	}
	
	function createPlayers(numberOfPlayers:Int):Void
	{
		players = new Array<PlayerModel>();
		for (i in 0...numberOfPlayers)
		{
			createNewPlayer(i);
		}
	}
	
	public function selectNextPlayer():PlayerModel
	{
		if (players.length == 0) {
			throw "No players to select from.";
		}
		
		if (activePlayer == null)
		{
			activePlayer = players[0];
		}
		else
		{
			var index = (activePlayer.playerNumberZeroBased + 1) % players.length;
			activePlayer = players[index];
		}
			
		EventBus.activePlayerChanged.dispatch(activePlayer);
			
		return activePlayer;
	}
	
	function createNewPlayer(number:Int):PlayerModel
	{
		var player = new PlayerModel(number);
		
		players.push(player);
		
		return player;
	}
	
}