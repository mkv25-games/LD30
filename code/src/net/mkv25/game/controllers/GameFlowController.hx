package net.mkv25.game.controllers;

import motion.Actuate;
import net.mkv25.base.core.ScreenController;
import net.mkv25.game.event.EventBus;
import net.mkv25.game.models.ActiveGame;
import net.mkv25.game.models.PlayableCard;
import net.mkv25.game.models.PlayerModel;
import net.mkv25.game.ui.GameOverUI;

class GameFlowController
{
	public static inline var END_OF_TURN_DELAY:Float = 2.5;

	var screenController:ScreenController;
	var gameOverMenu:GameOverUI;
	
	var flagAllYourBaseAreBelongToUsEnabled:Bool;
	var flagMasterOfExpansionEnabled:Bool;
	var flagWarWarNeverChangesWarNeverEnds:Bool;
	
	public function new() 
	{
		flagAllYourBaseAreBelongToUsEnabled = true;
		flagMasterOfExpansionEnabled = true;
		flagWarWarNeverChangesWarNeverEnds = false;
	}
	
	public function setup(screenController:ScreenController)
	{
		this.screenController = screenController;
		
		createMenus();
		
		EventBus.startNewGame.add(handle_startNewGame);
		EventBus.restartGame.add(handle_restartGame);
		
		EventBus.activePlayerChanged.add(handle_activePlayerChanged);
		EventBus.playerHasRanOutCards.add(handle_endOfPlayersTurn);
	}
	
	function handle_startNewGame(?model)
	{
		var number_of_players = 2;
		
		Index.activeGame = new ActiveGame(number_of_players);
		
		Index.screenController.showScreen(Index.mainScreen);
		Index.activeGame.startNextPlayersTurn();
		
		Index.mapHud.setupMap(Index.activeGame.space);
	}
	
	function handle_restartGame(?model)
	{
		Index.screenController.showScreen(Index.introScreen);
	}
	
	function handle_activePlayerChanged(?model)
	{
		EventBus.displayNewStatusMessage.dispatch("Choose a card to play");
	}
	
	function handle_endOfPlayersTurn(?model)
	{
		EventBus.displayNewStatusMessage.dispatch("End of player's turn");
		
		Index.activeGame.updatePlayerStats();
		
		// Using end game conditions
		removePlayersFromGame();
		
		// Check endgame conditions
		if (Index.activeGame.players.length < 2)
		{
			var winner:PlayerModel = Index.activeGame.players[0];
			
			// There can only be one
			if (flagAllYourBaseAreBelongToUsEnabled)
			{
				endGame_conditionAllYourBaseAreBelongToUs(winner);
			}
			else
			{
				endGame_conditionWarWarNeverChangesWarNeverEnds(winner);
			}
		}
		
		// TODO: Count up number of worlds to check Master of Expansion winning condition
		
		// TODO: Show end of turn message, and introduce next player
		Actuate.timer(END_OF_TURN_DELAY).onComplete(function() {
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
			if (flagAllYourBaseAreBelongToUsEnabled && player.baseCount == 0)
			{
				// ALL YOUR BASE ARE BELONG TO US - (medium) capture all bases belonging to your enemies.
				playersToRemoveFromGame.push(player);
			}
			else if (player.baseCount == 0 && player.unitCount == 0)
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
	}
	
	function endGame_conditionMasterOfExpansion(player:PlayerModel) 
	{
		gameOverMenu.setup(
			"Victory for " + player.name(),
			"Master of Expansion",
			Index.activeGame);
			
		gameOverMenu.show();
	}
	
	function endGame_conditionAllYourBaseAreBelongToUs(player:PlayerModel) 
	{
		gameOverMenu.setup(
			"Victory for " + player.name(),
			"All your base are belong to us",
			Index.activeGame);
			
		gameOverMenu.show();
	}
	
	function endGame_conditionWarWarNeverChangesWarNeverEnds(player:PlayerModel) 
	{
		gameOverMenu.setup(
			"Victory for " + player.name(),
			"War, War Never Changes, War Never Ends",
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