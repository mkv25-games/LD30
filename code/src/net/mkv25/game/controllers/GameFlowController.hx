package net.mkv25.game.controllers;

import net.mkv25.game.event.EventBus;
import net.mkv25.game.models.ActiveGame;
import net.mkv25.game.models.PlayableCard;

class GameFlowController
{

	public function new() 
	{
		
	}
	
	public function setup()
	{
		EventBus.startNewGame.add(handle_startNewGame);
		EventBus.restartGame.add(handle_restartGame);
		
		EventBus.cardSelectedFromHandByPlayer.add(handle_cardSelectedByPlayer);
	}
	
	function handle_startNewGame(?model) {
		var number_of_players = 6;
		
		Index.activeGame = new ActiveGame(number_of_players);
		
		Index.screenController.showScreen(Index.mainScreen);
		Index.activeGame.selectNextPlayer();
		
		EventBus.mapRequiresRedraw.dispatch(this);
	}
	
	function handle_restartGame(?model) {
		Index.screenController.showScreen(Index.introScreen);
	}
	
	function handle_cardSelectedByPlayer(?model) {
		var card:PlayableCard;
		if (Std.is(model, PlayableCard)) {
			card = cast model;
		}
		else {
			throw "Selected thing was not a playable card.";
		}
		
		if (card.deployable)
		{
			EventBus.askPlayer_whereTheyWantToDeployTheirUnitCard.dispatch(card);
			return;
		}
		
		if (card.movement > 0)
		{
			EventBus.askPlayer_howTheyWantToPlayTheirActionCard.dispatch(card);
			return;
		}
		
		throw "Don't know what to do with card: (" + card.name + ")";
	}
	
}