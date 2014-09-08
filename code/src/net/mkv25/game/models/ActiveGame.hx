package net.mkv25.game.models;

import net.mkv25.base.core.CoreModel;
import net.mkv25.game.enums.PlayableCardType;
import net.mkv25.game.event.EventBus;
import net.mkv25.game.provider.HexProvider;
import net.mkv25.game.provider.IconProvider;
import net.mkv25.game.provider.UnitProvider;
import net.mkv25.game.resources.UnitCards;
import openfl.Assets;

class ActiveGame extends CoreModel
{
	public var players:Array<PlayerModel>;
	public var activePlayer:PlayerModel;
	public var lastPlayerInRound:PlayerModel;
	
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
		space.setup("s0", Assets.getBitmapData("img/starfield-small.png"), null);
		space.hexes = MapModel.createCircle(5);
		space.indexHexes();
		
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
		world.setup("w" + id, Assets.getBitmapData(backgroundAsset), IconProvider.WORLD_ICONS[id]);
		world.hexes = MapModel.createRectangle(13, 9);
		world.indexHexes();
		
		var hex:HexTile = space.getHexTile(q, r);
		hex.add(world);
		world.setSpaceHex(hex);
		
		worlds.push(world);
	}
	
	function createPlayers(numberOfPlayers:Int):Void
	{
		if (numberOfPlayers < 2)
		{
			throw "Cannot create game with less than two players";
		}
		
		players = new Array<PlayerModel>();
		for (i in 0...numberOfPlayers)
		{
			createNewPlayer(i);
		}
		
		defineLastPlayerInRound();
	}
	
	public function defineLastPlayerInRound():Void
	{
		lastPlayerInRound = (players.length > 0) ? players[players.length - 1] : null;
	}
	
	public function startNextPlayersTurn():Void
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
			var index = Lambda.indexOf(players, activePlayer) + 1;
			activePlayer = players[index % players.length];
		}
		
		updateAllMapAndPlayerIndexes();
		
		resetAllUnitFlags();
		
		// draw a new hand for the player
		activePlayer.playerHand.drawHand();
		
		EventBus.activePlayerChanged.dispatch(activePlayer);
	}
	
	// this needs to happen after each combat, and at the end of a players turn
	public function updateAllMapAndPlayerIndexes():Void
	{
		// reset player values
		for (player in players)
		{
			player.territory = 0;
			player.units.removeAll();
			player.bases.removeAll();
			player.worlds.removeAll();
		}
		
		// begin the count
		updateIndexesForMap(space);
		for (world in worlds)
		{
			updateIndexesForMap(world);
		}
		
		// dispatch update
		EventBus.activePlayerUpdated.dispatch(activePlayer);
	}
	
	// scan the entire map and create additional indexes and counters based on contents
	function updateIndexesForMap(map:MapModel):Void
	{
		map.recalculateTerritory();
		
		for (hex in map.hexes)
		{
			var things = hex.listContents();
			for (thing in things)
			{
				// find all units and bases
				if (Std.is(thing, MapUnit))
				{
					var unit:MapUnit = cast thing;
					
					// update location
					unit.lastKnownLocation = hex;
					
					// count all units and bases
					if (unit.type.base)
					{
						// count bases separately
						unit.owner.bases.addUnit(unit);
					}
					else
					{
						// units, not including bases
						unit.owner.units.addUnit(unit);
					}
				}
			}
			
			// count uncontested territory
			if (hex.territoryOwner != null && !hex.contested && hex.map.isWorld())
			{
				var owner:PlayerModel = hex.territoryOwner;
				
				// count as colonised world
				if (!owner.worlds.contains(hex.map))
				{
					owner.worlds.addWorld(hex.map);
				}
				owner.territory++;
			}
		}
	}
	
	// this needs to happen at the start of a player's turn to allow them to move units
	public function resetAllUnitFlags():Void
	{
		// reset the flags
		resetUnitFlagFor(space);
		for (world in worlds)
		{
			resetUnitFlagFor(world);
		}
	}
	
	// scan the entire map for units and reset their movement and combat flags
	public function resetUnitFlagFor(map:MapModel):Void
	{
		map.recalculateTerritory();
		
		for (hex in map.hexes)
		{
			var things = hex.listContents();
			for (thing in things)
			{
				// find all units and bases
				if (Std.is(thing, MapUnit))
				{
					var unit:MapUnit = cast thing;
					
					unit.resetFlags();
				}
			}
		}
	}
	
	function createNewPlayer(number:Int):PlayerModel
	{
		var player = new PlayerModel(number);
		
		players.push(player);
		
		return player;
	}
	
}