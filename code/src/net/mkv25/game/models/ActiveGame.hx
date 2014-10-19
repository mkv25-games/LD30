package net.mkv25.game.models;

import net.mkv25.base.core.CoreModel;
import net.mkv25.game.enums.PlayableCardType;
import net.mkv25.game.event.EventBus;
import net.mkv25.game.models.startVariants.ClassicStartVariant;
import net.mkv25.game.models.startVariants.IStartVariant;
import net.mkv25.game.models.startVariants.SmallHandStartVariant;
import net.mkv25.game.models.startVariants.SmallHandStartVariant;
import net.mkv25.game.provider.HexProvider;
import net.mkv25.game.provider.IconProvider;
import net.mkv25.game.provider.MapLayoutProvider;
import net.mkv25.game.provider.UnitProvider;
import net.mkv25.game.resources.UnitCards;
import net.mkv25.ld30.dbvos.GameVariantRow;
import net.mkv25.ld30.enums.GameVariantEnum;
import openfl.Assets;

class ActiveGame extends CoreModel
{
	// properties
	public var activePlayer(get, null):PlayerModel;
	public var finalPlayerInRound(get, null):PlayerModel;
	
	// serializable properties
	public var playerIndex(default, null):Array<PlayerModel>;
	
	public var space:MapModel;
	public var worlds:Array<MapModel>;
	
	private var activePlayers(default, null):TurnModel<PlayerModel>;
	
	public function new(numberOfPlayers:Int=0) 
	{
		super();
		
		if (numberOfPlayers > 0)
		{
			IconProvider.setup();
			
			validateNumberOfPlayers(numberOfPlayers);
			MapLayoutProvider.createWorldsFor(numberOfPlayers, this);
			createPlayers(numberOfPlayers);
		}
	}
	
	function validateNumberOfPlayers(numberOfPlayers:Int):Void
	{
		if (numberOfPlayers < 1)
		{
			throw "Cannot play the game with less then one player.";
		}
		
		if (numberOfPlayers > 6)
		{
			throw "Cannot play the game with more then 6 players";
		}
	}
	
	function setupPlayerStartingConditions(startVariant:IStartVariant):Void
	{
		for (player in playerIndex)
		{
			var world = worlds[player.playerNumberZeroBased];
			if (world == null)
			{
				throw "No world available for player " + (player.playerNumberZeroBased + 1) + " at world index " + player.playerNumberZeroBased + ".";
			}
		
			player.playerHand.populateStartingDeck(startVariant.startingCards());
			startVariant.startingUnitPlacement(player, world);
			player.resources = startVariant.startingResources();
		}
	}
	
	public function startGameInMode(mode:GameVariantRow):Void
	{
		if (mode == null)
		{
			throw "Cannot initialise game start with a null mode.";
		}
		
		var startVariant:IStartVariant;
		if (mode.id == GameVariantEnum.CLASSIC)
		{
			startVariant = new ClassicStartVariant();
		}
		else if (mode.id == GameVariantEnum.SMALL_HAND)
		{
			startVariant = new SmallHandStartVariant();
		}
		else
		{
			throw "Unrecognised game start mode, name: " + mode.name + ", id: " + mode.id + ".";
		}
		
		setupPlayerStartingConditions(startVariant);
	}
	
	function createPlayers(numberOfPlayers:Int):Void
	{
		if (numberOfPlayers < 2)
		{
			throw "Cannot create game with less than two players";
		}
		
		playerIndex = new Array<PlayerModel>();
		activePlayers = new TurnModel<PlayerModel>();
		
		for (i in 0...numberOfPlayers)
		{
			createNewPlayer(i);
		}
	}
	
	public function startFirstPlayerTurn():Void
	{
		checkForValidPlayers();
		
		updateGameForActivePlayer();
	}
	
	public function resumePlayerTurn():Void
	{
		checkForValidPlayers();
		
		updateGameForActivePlayer();
	}
	
	public function startNextPlayersTurn():Void
	{
		checkForValidPlayers();
		
		activePlayers.chooseNextPlayer();
		
		updateGameForActivePlayer();
	}
	
	function checkForValidPlayers():Void
	{
		if (playerIndex.length == 0)
		{
			throw "No players to select from.";
		}
		
		if (activePlayers.size() == 0 || activePlayers.activePlayer == null)
		{
			throw "No active players remaining in game";
		}
	}
	
	function updateGameForActivePlayer():Void
	{
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
		for (player in playerIndex)
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
		
		for (hex in map.hexes.list)
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
		
		for (hex in map.hexes.list)
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
	
	function createNewPlayer(number:Int):Void
	{
		var player = new PlayerModel(number);
		
		playerIndex.push(player);
		activePlayers.add(player);
	}
	
	function get_activePlayer():Null<PlayerModel>
	{
		return activePlayers.activePlayer;
	}
	
	function get_finalPlayerInRound():Null<PlayerModel>
	{
		return activePlayers.finalPlayer;
	}
	
	public function removePlayerFromGame(player:PlayerModel):Void
	{
		activePlayers.remove(player);
	}
	
	public function activePlayerCount():Int
	{
		return activePlayers.size();
	}
	
	public function readFrom(object:Dynamic):Void
	{
		playerIndex = readArray("playerIndex", object, PlayerModel);
		// space = readObject("space", object, MapModel);
		// worlds = readArray("worlds", object, MapModel);
		activePlayers = new TurnModel<PlayerModel>();
		activePlayers.readFrom(read("activePlayers", object, {}), playerIndex);
	}
	
	public function serialize():Dynamic
	{
		var result:Dynamic = { };
		
		writeArray("playerIndex", result, playerIndex);
		// writeObject("space", result, space);
		// writeArray("worlds", result, worlds);
		writeObject("activePlayers", result, activePlayers.serialize()); 
		
		return result;
	}
	
	public static function makeFrom(object:Dynamic):ActiveGame
	{
		var game:ActiveGame = new ActiveGame(0);
		
		game.readFrom(object);
		
		return game;
	}
	
}