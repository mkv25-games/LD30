package net.mkv25.game.controllers;

import motion.Actuate;
import net.mkv25.game.event.EventBus;
import net.mkv25.game.models.ActiveGame;
import net.mkv25.game.models.PlayableCard;

class GameFlowController
{
	public static inline var END_OF_TURN_DELAY:Float = 2.5;

	public function new() 
	{
		
	}
	
	public function setup()
	{
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
		
		EventBus.mapRequiresRedraw.dispatch(this);
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
		// TODO: Show end of turn message, and introduce next player
		EventBus.displayNewStatusMessage.dispatch("End of player's turn");
		
		Actuate.timer(END_OF_TURN_DELAY).onComplete(function() {
			Index.activeGame.startNextPlayersTurn();
		});
	}
	
	
}