package net.mkv25.game.models;

import net.mkv25.base.core.CoreModel;
import net.mkv25.game.enums.PlayableCardType;
import net.mkv25.game.event.EventBus;
import net.mkv25.game.provider.IconProvider;
import net.mkv25.game.provider.UnitProvider;
import net.mkv25.game.resources.UnitCards;
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
		
		IconProvider.setup();
		
		validateNumberOfPlayers(numberOfPlayers);
		createMaps(numberOfPlayers);
		createPlayers(numberOfPlayers);
		createStartingBases();
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
		space.hexes = MapModel.createCircle(5);
		space.background = Assets.getBitmapData("img/starfield-small.png");
		space.indexTiles();
		
		worlds = new Array<MapModel>();
		
		// player worlds, ideally variable based on number of players
		addWorld(-4,  4, 0, "img/planet01.png");
		addWorld( 4, -4, 1, "img/planet02.png");
		addWorld(-4,  0, 2, "img/planet03.png");
		addWorld( 4,  0, 3, "img/planet04.png");
		addWorld( 0, -4, 5, "img/planet06.png");
		addWorld( 0,  4, 6, "img/planet07.png");
		
		// central world, always present
		addWorld(0, 0, 4, "img/planet05.png");
	}
	
	function createStartingBases():Void
	{
		for (player in players)
		{
			var world = worlds[player.playerNumberZeroBased];
			var startingBase = UnitProvider.getUnit(player, PlayableCardType.STANDARD_BASE);
			
			world.getHexTile(0, 0).add(startingBase);
		}
	}
	
	function addWorld(q:Int, r:Int, id:Int, backgroundAsset:String):Void
	{
		var world:MapModel = new MapModel();
		world.setup(Assets.getBitmapData(backgroundAsset), IconProvider.WORLD_ICONS[id]);
		world.hexes = MapModel.createRectangle(13, 9);
		world.indexTiles();
		
		var hex:HexTile = space.getHexTile(q, r);
		hex.add(world);
		
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
	
	public function startNextPlayersTurn():PlayerModel
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
		
		// draw a new hand for the player
		activePlayer.playerHand.drawHand();
			
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