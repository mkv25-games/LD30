package net.mkv25.game.controllers;
import net.mkv25.base.core.ScreenController;
import net.mkv25.game.event.EventBus;
import net.mkv25.game.models.PlayableCard;
import net.mkv25.game.ui.InGameMenuUI;

class CardActionController
{
	var menu:InGameMenuUI;
	var activeCard:PlayableCard;
	var specialActions:Dynamic;

	public function new() 
	{
		
	}
	
	public function setup(screenController:ScreenController):Void
	{
		EventBus.askPlayer_howTheyWantToPlayTheirActionCard.add(showOptionsForActionCard);
		EventBus.askPlayer_whereTheyWantToDeployTheirUnitCard.add(showOptionsForUnitCard);
		EventBus.playerWantsTo_cancelTheCurrentAction.add(clearAnyActiveState);
		EventBus.playerWantsTo_performASpecialAction.add(figureOutWhichActionIsOnTheCard);
		
		menu = new InGameMenuUI();
		menu.hide();
		
		screenController.addLayer(menu.artwork);
		
		specialActions = {
			"research": playerWantsToResearch,
			"build units": playerWantsToBuildUnits,
			"connect bases": playerWantsToConnectBases,
			"gather resources": playerWantsToGatherResources
		}
	}
	
	function clearAnyActiveState(?model):Void
	{
		EventBus.displayNewStatusMessage.dispatch("Action cancelled");
		activeCard = null;
	}
	
	function showOptionsForActionCard(card:PlayableCard):Void
	{
		activeCard = card;
		
		EventBus.displayNewStatusMessage.dispatch("Pick an option");
		menu.setCardName(card.name);
		menu.setOption1("move a unit".toUpperCase(), EventBus.playerWantsTo_moveAUnit.dispatch, card);
		menu.setOption2(card.action.toUpperCase(), EventBus.playerWantsTo_performASpecialAction.dispatch, card);
		
		menu.show();
	}
	
	function showOptionsForUnitCard(card:PlayableCard):Void
	{
		activeCard = card;
		
		EventBus.displayNewStatusMessage.dispatch("Pick an option");
		menu.setCardName(card.name);
		menu.setOption1("deploy in space".toUpperCase(), EventBus.playerWantsTo_deployAUnitInSpace.dispatch, card);
		menu.setOption2("deploy on planet".toUpperCase(), EventBus.playerWantsTo_deployAUnitOnPlanet.dispatch, card);
		
		menu.show();
	}
	
	function figureOutWhichActionIsOnTheCard(card:PlayableCard):Void
	{
		if (Reflect.hasField(specialActions, card.action))
		{
			var action:PlayableCard->Void = cast Reflect.getProperty(specialActions, card.action);
			action(card);
		}
		else {
			throw "Unknown special card action: (" + card.name + ")";
		}
	}
	
	function playerWantsToResearch(card:PlayableCard):Void
	{
		
	}
	
	function playerWantsToBuildUnits(card:PlayableCard):Void
	{
		
	}
	
	function playerWantsToConnectBases(card:PlayableCard):Void
	{
		
	}
	
	function playerWantsToGatherResources(card:PlayableCard):Void
	{
		var resources:Int = card.resources;
		if (resources > 0) {
			var activePlayer = Index.activeGame.activePlayer;
			activePlayer.resources += resources;
			
			EventBus.activePlayerResourcesChanged.dispatch(activePlayer);
			EventBus.removeCardFromActivePlayersHand.dispatch(card);
		}
	}
	
}