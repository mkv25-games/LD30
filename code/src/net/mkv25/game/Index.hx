package net.mkv25.game;

import flash.display.Stage;
import net.mkv25.base.core.CoreModel;
import net.mkv25.base.core.Screen;
import net.mkv25.base.core.ScreenController;
import net.mkv25.base.ui.BaseUI;
import net.mkv25.base.ui.DebugUI;
import net.mkv25.game.controllers.ConnectPortalsController;
import net.mkv25.game.controllers.DeployUnitController;
import net.mkv25.game.controllers.GameFlowController;
import net.mkv25.game.controllers.CardActionController;
import net.mkv25.game.controllers.MapFocusController;
import net.mkv25.game.controllers.MoveUnitController;
import net.mkv25.game.models.ActiveGame;
import net.mkv25.game.models.MapModel;
import net.mkv25.game.provider.CardProvider;
import net.mkv25.game.screens.BeginnersGuideScreen;
import net.mkv25.game.screens.GameSetupScreen;
import net.mkv25.game.screens.IntroScreen;
import net.mkv25.game.screens.MainScreen;
import net.mkv25.game.ui.DeploymentUI;
import net.mkv25.game.ui.MapUI;
import net.mkv25.game.ui.MovementUI;
import net.mkv25.game.ui.PortalsUI;
import net.mkv25.ld30.dbvos.DBVOsModel;

class Index
{
	private static var failsafe:Bool = false;
	
	// models
	public static var dbvos:DBVOsModel;
	public static var activeGame:ActiveGame;
	
	// controllers
	public static var screenController:ScreenController;
	public static var gameFlowController:GameFlowController;
	public static var cardActionController:CardActionController;
	public static var deployUnitController:DeployUnitController;
	public static var moveUnitController:MoveUnitController;
	public static var connectPortalsController:ConnectPortalsController;
	public static var mapFocusController:MapFocusController;
	
	// providers
	public static var cardProvider:CardProvider;
	
	// screens
	public static var introScreen:Screen;
	public static var guideScreen:Screen;
	public static var mainScreen:Screen;
	public static var gameSetupScreen:Screen;
	
	// core ui elements
	public static var mapHud:MapUI;
	public static var deploymentHud:DeploymentUI;
	public static var movementHud:MovementUI;
	public static var portalsHud:PortalsUI;
	public static var resourceCounterHud:BaseUI;
	public static var discardPileHud:BaseUI;
	
	// debug
	public static var debug:DebugUI;
	
	// play time
	public static function setup(stage:Stage):Void
	{
		// prevent method from being executed more then once
		if (failsafe)
		{
			throw "The glass has already been broken.";
		}
		failsafe = true;
		
		// models
		dbvos = new DBVOsModel();
		activeGame = null;
		
		// controllers
		screenController = new ScreenController();
		gameFlowController = new GameFlowController();
		cardActionController = new CardActionController();
		deployUnitController = new DeployUnitController();
		moveUnitController = new MoveUnitController();
		connectPortalsController = new ConnectPortalsController();
		mapFocusController = new MapFocusController();
		
		// providers
		cardProvider = new CardProvider();
		
		// screens
		introScreen = new IntroScreen();
		guideScreen = new BeginnersGuideScreen();
		mainScreen = new MainScreen();
		gameSetupScreen = new GameSetupScreen();
		
		// core ui elements
		mapHud = new MapUI();
		deploymentHud = new DeploymentUI();
		movementHud = new MovementUI();
		portalsHud = new PortalsUI();
		
		// debug
		// debug = new DebugUI(screenController);
		
		// wiring
		screenController.setup(stage);
		cardProvider.setup();
		gameFlowController.setup(screenController);
		cardActionController.setup(screenController);
		deployUnitController.setup(mapHud, deploymentHud);
		moveUnitController.setup(mapHud, movementHud);
		connectPortalsController.setup(mapHud, portalsHud);
		mapFocusController.setup(mapHud);
		
		// start
		Index.screenController.showScreen(Index.introScreen);
	}
}