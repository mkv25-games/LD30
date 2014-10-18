package net.mkv25.game.controllers;

import motion.Actuate;
import net.mkv25.base.core.ScreenController;
import net.mkv25.game.event.EventBus;
import net.mkv25.game.models.ActiveGame;
import net.mkv25.game.models.PlayableCard;
import net.mkv25.game.models.PlayerModel;
import net.mkv25.game.ui.GameOverUI;
import net.mkv25.ld30.dbvos.GameVariantRow;
import net.mkv25.ld30.dbvos.WinningConditionsRow;
import net.mkv25.ld30.enums.WinningConditionsEnum;

class GameFlowController
{
	public static var WINNING_CONDITION_NUMBER_OF_WORLDS:Int = 3;
	
	public static var END_OF_TURN_DELAY:Float = 2.5;
	
	static inline var NL:String = "\n";

	var screenController:ScreenController;
	var gameOverMenu:GameOverUI;
	
	var numberOfPlayers:Int;
	var winningCondition:WinningConditionsRow;
	var gameVariant:GameVariantRow;
	
	public function new() 
	{
		numberOfPlayers = 0;
		winningCondition = null;
		gameVariant = null;
	}
	
	public function setup(screenController:ScreenController)
	{
		this.screenController = screenController;
		
		createMenus();
		
		EventBus.playerCountChanged.add(handle_playerCountChanged);
		EventBus.winningConditionChanged.add(handle_winningConditionChanged);
		EventBus.gameVariantChanged.add(handle_gameVariantChanged);
		
		EventBus.startNewGame.add(handle_startNewGame);
		EventBus.continueSavedGame.add(handle_continueSavedGame);
		EventBus.restartGame.add(handle_restartGame);
		
		EventBus.activePlayerChanged.add(handle_startOfPlayersTurn);
		EventBus.playerHasRanOutCards.add(handle_endOfPlayersTurn);
	}
	
	function handle_playerCountChanged(numberOfPlayers:Int):Void
	{
		this.numberOfPlayers = numberOfPlayers;
	}
	
	function handle_winningConditionChanged(winningCondition:WinningConditionsRow):Void
	{
		this.winningCondition = winningCondition;
	}
	
	function handle_gameVariantChanged(gameVariant:GameVariantRow):Void
	{
		this.gameVariant = gameVariant;
	}
	
	function handle_startNewGame(?model)
	{
		var game:ActiveGame = new ActiveGame(numberOfPlayers);
		game.startGameInMode(gameVariant);
		
		Index.activeGame = game;
		Index.screenController.showScreen(Index.mainScreen);
		Index.activeGame.startFirstPlayerTurn();
	}
	
	function handle_continueSavedGame(?model)
	{
		var game:ActiveGame = Index.lastSavedGameModel.savedGame;
	
		Index.activeGame = game;
		Index.screenController.showScreen(Index.mainScreen);
		Index.activeGame.resumePlayerTurn();
	}
	
	function handle_restartGame(?model)
	{
		Index.screenController.showScreen(Index.introScreen);
	}
	
	function handle_startOfPlayersTurn(?model)
	{
		EventBus.displayNewStatusMessage.dispatch("Choose a card to play");
	}
	
	function handle_endOfPlayersTurn(?model)
	{
		EventBus.displayNewStatusMessage.dispatch("End of player's turn");
		
		var activeGame:ActiveGame = Index.activeGame;
		
		// Canvas the entire map 
		activeGame.updateAllMapAndPlayerIndexes();
		
		// Using end game conditions
		removePlayersFromGame();
		
		// Check for endgame conditions
		var activePlayersCount = activeGame.activePlayerCount();
		if (activePlayersCount == 0)
		{
			endgame_conditionHeatDeathOfTheUniverse();
			return;
		}
		else if (activePlayersCount < 2)
		{
			var winner:PlayerModel = activeGame.activePlayer;
			
			// There can only be one
			if (winningCondition.id == WinningConditionsEnum.MEDIUM_GAME)
			{
				endGame_conditionAllYourBaseAreBelongToUs(winner);
				return;
			}
			else
			{
				endGame_conditionWarWarNeverChangesWarNeverEnds(winner);
				return;
			}
		}
		else if (activeGame.activePlayer == activeGame.finalPlayerInRound)
		{
			if (winningCondition.id == WinningConditionsEnum.SHORT_GAME)
			{
				var winner:PlayerModel = attemptToFindMasterOfExpansion(activeGame.playerIndex);
				if (winner != null)
				{
					endGame_conditionMasterOfExpansion(winner);
					return;
				}
			}
		}
		
		// TODO: Show end of turn message, and introduce next player
		delayedStart_nextPlayersTurn();
	}
	
	function attemptToFindMasterOfExpansion(players:Array<PlayerModel>):PlayerModel
	{
		var master:PlayerModel = null;
		var maxTerritory:Int = 0;
		
		for (player in players)
		{
			maxTerritory = cast Math.max(player.territory, maxTerritory);
		}
		
		var contender:Bool = false;
		for (player in players)
		{
			if (player.worlds.length() >= GameFlowController.WINNING_CONDITION_NUMBER_OF_WORLDS && player.territory == maxTerritory)
			{
				if (master == null)
				{
					// player qualifies as a master
					master = player;
				}
				else
				{
					// a contender exists
					return null;
				}
			}
		}
		
		return master;
	}
	
	function delayedStart_nextPlayersTurn():Void
	{
		Actuate.timer(GameFlowController.END_OF_TURN_DELAY).onComplete(function() {
			Index.activeGame.startNextPlayersTurn();
		});
	}
	
	function removePlayersFromGame():Void
	{
		var players = Index.activeGame.playerIndex;
		
		// find players which have failed basic game conditions
		for (player in players)
		{
			if (winningCondition.id == WinningConditionsEnum.MEDIUM_GAME && player.baseCount() == 0)
			{
				// ALL YOUR BASE ARE BELONG TO US - (medium) capture all bases belonging to your enemies.
				Index.activeGame.removePlayerFromGame(player);
			}
			else if (player.unitCount() == 0 && player.baseCount() == 0)
			{
				// WAR, WAR NEVER CHANGES, WAR NEVER ENDS - (long) destroy all units and bases belonging to your enemies.
				// It's impossible to influence other players without units in the game
				Index.activeGame.removePlayerFromGame(player);
			}
		}
	}
	
	function endgame_conditionHeatDeathOfTheUniverse()
	{
		showGameOverCondition();
	}
	
	function endGame_conditionMasterOfExpansion(player:PlayerModel) 
	{
		showWinningCondition(player, WinningConditionsEnum.SHORT_GAME);
	}
	
	function endGame_conditionAllYourBaseAreBelongToUs(player:PlayerModel) 
	{
		showWinningCondition(player, WinningConditionsEnum.MEDIUM_GAME);
	}
	
	function endGame_conditionWarWarNeverChangesWarNeverEnds(player:PlayerModel) 
	{
		showWinningCondition(player, WinningConditionsEnum.LONG_GAME);
	}
	
	function showWinningCondition(player:PlayerModel, winningConditionType:Int):Void
	{
		var condition = Index.dbvos.WINNING_CONDITIONS.getRowCast(winningConditionType);
		
		gameOverMenu.setup(
			"Victory for " + player.name(),
			condition.title + NL
			+ condition.shortDescription,
			Index.activeGame);
			
		gameOverMenu.show();
	}
	
	function showGameOverCondition():Void
	{
		gameOverMenu.setup(
			"All players destroyed",
			"No survivors. The universe" + NL
			+ "is infinite, quiet, and cold.",
			Index.activeGame);
			
		gameOverMenu.show();
	}
	
	function createMenus()
	{
		gameOverMenu = new GameOverUI();
		gameOverMenu.hide();
		screenController.addLayer(gameOverMenu.artwork);
	}
	
	
}