package net.mkv25.game.controllers;

import motion.Actuate;
import net.mkv25.base.core.ScreenController;
import net.mkv25.game.event.EventBus;
import net.mkv25.game.models.ActiveGame;
import net.mkv25.game.models.PlayableCard;
import net.mkv25.game.models.PlayerModel;
import net.mkv25.game.ui.GameOverUI;
import net.mkv25.ld30.dbvos.WinningConditionsRow;
import net.mkv25.ld30.enums.WinningConditionsEnum;

class GameFlowController
{
	public static var WINNING_CONDITION_NUMBER_OF_WORLDS:Int = 3;
	
	public static var END_OF_TURN_DELAY:Float = 2.5;
	
	static inline var NL:String = "\n";

	var screenController:ScreenController;
	var gameOverMenu:GameOverUI;
	
	var winningCondition:WinningConditionsRow;
	var numberOfPlayers:Int;
	
	public function new() 
	{
		winningCondition = null;
	}
	
	public function setup(screenController:ScreenController)
	{
		this.screenController = screenController;
		
		createMenus();
		
		EventBus.winningConditionChanged.add(handle_winningConditionChanged);
		EventBus.playerCountChanged.add(handle_playerCountChanged);
		
		EventBus.startNewGame.add(handle_startNewGame);
		EventBus.restartGame.add(handle_restartGame);
		
		EventBus.activePlayerChanged.add(handle_startOfPlayersTurn);
		EventBus.playerHasRanOutCards.add(handle_endOfPlayersTurn);
	}
	
	function handle_winningConditionChanged(winningCondition:WinningConditionsRow):Void
	{
		this.winningCondition = winningCondition;
	}
	
	function handle_playerCountChanged(numberOfPlayers:Int):Void
	{
		this.numberOfPlayers = numberOfPlayers;
	}
	
	function handle_startNewGame(?model)
	{
		Index.activeGame = new ActiveGame(numberOfPlayers);
		
		Index.screenController.showScreen(Index.mainScreen);
		Index.activeGame.startNextPlayersTurn();
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
		if (activeGame.players.length == 0)
		{
			activeGame.activePlayer = null;
			endgame_conditionHeatDeathOfTheUniverse();
			return;
		}
		else if (activeGame.players.length < 2)
		{
			var winner:PlayerModel = activeGame.players[0];
			
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
		else if (activeGame.activePlayer == activeGame.lastPlayerInRound)
		{
			if (winningCondition.id == WinningConditionsEnum.SHORT_GAME)
			{
				var winner:PlayerModel = attemptToFindMasterOfExpansion(activeGame.players);
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
		var players = Index.activeGame.players;
		var playersToRemoveFromGame:Array<PlayerModel> = new Array<PlayerModel>();
		
		// find players which have failed basic game conditions
		for (player in players)
		{
			if (winningCondition.id == WinningConditionsEnum.MEDIUM_GAME && player.baseCount() == 0)
			{
				// ALL YOUR BASE ARE BELONG TO US - (medium) capture all bases belonging to your enemies.
				playersToRemoveFromGame.push(player);
			}
			else if (player.unitCount() == 0 && player.baseCount() == 0)
			{
				// WAR, WAR NEVER CHANGES, WAR NEVER ENDS - (long) destroy all units and bases belonging to your enemies.
				// It's impossible to influence other players without units in the game
				playersToRemoveFromGame.push(player);
			}
		}
		
		// remove those players
		for (player in playersToRemoveFromGame)
		{
			players.remove(player);
		}
		
		// redefine the last player
		Index.activeGame.defineLastPlayerInRound();
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