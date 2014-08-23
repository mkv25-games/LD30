package net.mkv25.game;

import net.mkv25.base.core.CoreModel;
import net.mkv25.base.core.Screen;
import net.mkv25.base.core.ScreenController;
import net.mkv25.base.ui.DebugUI;
import net.mkv25.game.screens.IntroScreen;

class Index
{
	private static var failsafe:Bool = false;
	
	// models
	public static var exampleModel:CoreModel;
	
	// controllers
	public static var screenController:ScreenController;
	public static var debug:DebugUI;
	
	// screens
	public static var introScreen:Screen;
	
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
		exampleModel = new CoreModel();
		
		// controllers
		screenController = new ScreenController();
		debug = new DebugUI(screenController);
		
		// screens
		introScreen = new IntroScreen();
	}
}