package net.mkv25.game.controllers;

import net.mkv25.game.event.EventBus;
import net.mkv25.game.models.ActiveGame;

class GameFlowController
{

	public function new() 
	{
		
	}
	
	public function setup()
	{
		EventBus.startNewGame.add(handle_startNewGame);
		EventBus.restartGame.add(handle_restartGame);
	}
	
	private function handle_startNewGame(?model) {
		var number_of_players = 6;
		
		Index.activeGame = new ActiveGame(number_of_players);
		Index.activeGame.selectNextPlayer();
		
		Index.screenController.showScreen(Index.mainScreen);
		EventBus.mapRequiresRedraw.dispatch(this);
	}
	
	private function handle_restartGame(?model) {
		Index.screenController.showScreen(Index.introScreen);
	}
	
}