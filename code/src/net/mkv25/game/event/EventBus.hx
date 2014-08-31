package net.mkv25.game.event;

import net.mkv25.base.core.Signal;

class EventBus 
{
	// general screen navigation
	public static var requestNextScreen = new Signal();
	public static var requestLastScreen = new Signal();
	
	// general actions actions
	public static var startNewGame = new Signal();
	public static var restartGame = new Signal();
	public static var displayNewStatusMessage = new Signal();
	
	// card actions
	public static var cardSelectedFromHandByPlayer = new Signal();
	public static var removeCardFromActivePlayersHand = new Signal();
	public static var trashCardFromActivePlayersHand = new Signal();
	public static var addNewCardToActivePlayersDiscardPile = new Signal();
	public static var activePlayerResourcesChanged = new Signal();
	public static var playerHasRanOutCards = new Signal();
	
	// actions while figuring out what the player wants to do
	public static var askPlayer_howTheyWantToPlayTheirActionCard = new Signal();
	public static var askPlayer_whereTheyWantToDeployTheirUnitCard = new Signal();
	public static var playerWantsTo_deployUnitAtSelectedLocation = new Signal();
	public static var playerWantsTo_moveUnitAtSelectedLocation = new Signal();
	public static var playerWantsTo_confirmTheSelectedMovementAction = new Signal();
	public static var playerWantsTo_cancelTheCurrentAction = new Signal();
	public static var playerWantsTo_discardTheCurrentCard = new Signal();
	public static var playerWantsTo_moveAUnit = new Signal();
	public static var playerWantsTo_performASpecialAction = new Signal();
	public static var playerWantsTo_deployAUnit = new Signal();
	public static var playerWantsTo_buyACard = new Signal();
	
	// game turn events
	public static var activePlayerChanged = new Signal();
	
	// map stuff
	public static var mapRequiresRedraw = new Signal();
	public static var mapViewChanged = new Signal();
	public static var mapMarkerPlacedOnMap = new Signal();
	
	public function new() 
	{
		
	}
	
}