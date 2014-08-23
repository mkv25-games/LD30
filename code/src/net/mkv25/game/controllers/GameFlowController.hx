package net.mkv25.game.controllers;

import net.mkv25.game.event.EventBus;

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
		Index.screenController.showScreen(Index.mainScreen);
	}
	
	private function handle_restartGame(?model) {
		Index.screenController.showScreen(Index.introScreen);
	}
	
}