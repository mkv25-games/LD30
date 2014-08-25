package net.mkv25.game.event;

import net.mkv25.base.core.Signal;

class EventBus 
{
	// general screen navigation
	public static var requestNextScreen = new Signal();
	public static var requestLastScreen = new Signal();
	
	// specific actions
	public static var startNewGame = new Signal();
	public static var restartGame = new Signal();
	public static var cardSelectedFromHandByPlayer = new Signal();
	public static var askPlayerHowTheyWantToPlayTheirActionCard = new Signal();
	public static var askPlayerWhereTheyWantToDeployTheirUnitCard = new Signal();
	public static var playerWantsToMoveAUnit = new Signal();
	public static var playerWantsToPerformASpecialAction = new Signal();
	public static var playerWantsToCancelTheCurrentAction = new Signal();
	
	// global events
	public static var activePlayerChanged = new Signal();
	public static var displayNewStatusMessage = new Signal();
	
	// map stuff
	public static var mapRequiresRedraw = new Signal();
	public static var mapViewChanged = new Signal();
	
	public function new() 
	{
		
	}
	
}