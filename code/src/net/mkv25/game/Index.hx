package net.mkv25.game;

import net.mkv25.base.core.CoreModel;
import net.mkv25.base.core.Screen;
import net.mkv25.base.core.ScreenController;
import net.mkv25.base.ui.DebugUI;
import net.mkv25.game.controllers.GameFlowController;
import net.mkv25.game.models.ActiveGame;
import net.mkv25.game.models.MapModel;
import net.mkv25.game.provider.CardProvider;
import net.mkv25.game.screens.IntroScreen;
import net.mkv25.game.screens.MainScreen;

class Index
{
	private static var failsafe:Bool = false;
	
	// models
	public static var activeGame:ActiveGame;
	
	// controllers
	public static var screenController:ScreenController;
	public static var gameFlowController:GameFlowController;
	
	// providers
	public static var cardProvider:CardProvider;
	
	// screens
	public static var introScreen:Screen;
	public static var mainScreen:Screen;
	
	// debug
	public static var debug:DebugUI;
	
	// play time
	public static function setup():Void
	{
		// prevent method from being executed more then once
		if (failsafe)
		{
			throw "The glass has already been broken.";
		}
		failsafe = true;
		
		// models
		activeGame = null;
		
		// controllers
		screenController = new ScreenController();
		gameFlowController = new GameFlowController();
		
		// providers
		cardProvider = new CardProvider();
		
		// screens
		introScreen = new IntroScreen();
		mainScreen = new MainScreen();
		
		// debug
		// debug = new DebugUI(screenController);
		
		// wiring
		gameFlowController.setup();
		cardProvider.setup();
	}
}