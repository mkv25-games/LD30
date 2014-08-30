package net.mkv25.game.controllers;

import net.mkv25.base.core.ScreenController;
import net.mkv25.game.event.EventBus;
import net.mkv25.game.models.PlayableCard;
import net.mkv25.game.ui.ConstructionMenuUI;
import net.mkv25.game.ui.InGameMenuUI;
import net.mkv25.game.ui.ResearchMenuUI;

class CardActionController
{
	var optionMenu:InGameMenuUI;
	var researchMenu:ResearchMenuUI;
	var constructionMenu:ConstructionMenuUI;
	var activeCard:PlayableCard;
	var specialActions:Dynamic;

	public function new() 
	{
		
	}
	
	public function setup(screenController:ScreenController):Void
	{
		EventBus.cardSelectedFromHandByPlayer.add(checkTypeOfCardSelectedByPlayer);
		EventBus.askPlayer_howTheyWantToPlayTheirActionCard.add(showOptionsForActionCard);
		EventBus.askPlayer_whereTheyWantToDeployTheirUnitCard.add(showOptionsForUnitCard);
		EventBus.playerWantsTo_cancelTheCurrentAction.add(clearAnyActiveState);
		EventBus.playerWantsTo_performASpecialAction.add(figureOutWhichActionIsOnTheCard);
		EventBus.playerWantsTo_buyACard.add(processCardPurchase);
		EventBus.playerWantsTo_discardTheCurrentCard.add(removeTheActiveCardFromThePlayersHand);

		createMenus(screenController);
		
		specialActions = {
			"research": playerWantsToResearch,
			"build units": playerWantsToBuildUnits,
			"connect bases": playerWantsToConnectBases,
			"gather resources": playerWantsToGatherResources
		}
	}
	
	function checkTypeOfCardSelectedByPlayer(?model)
	{
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
	
	function createMenus(screenController:ScreenController):Void
	{		
		optionMenu = new InGameMenuUI();
		optionMenu.hide();
		screenController.addLayer(optionMenu.artwork);
		
		researchMenu = new ResearchMenuUI();
		researchMenu.hide();
		screenController.addLayer(researchMenu.artwork);
		
		constructionMenu = new ConstructionMenuUI();
		constructionMenu.hide();
		screenController.addLayer(constructionMenu.artwork);
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
		optionMenu.setCardName(card.name);
		optionMenu.setOption1("move a unit".toUpperCase(), EventBus.playerWantsTo_moveAUnit.dispatch, card);
		optionMenu.setOption2(card.action.toUpperCase(), EventBus.playerWantsTo_performASpecialAction.dispatch, card);
		
		optionMenu.show();
	}
	
	function showOptionsForUnitCard(card:PlayableCard):Void
	{
		activeCard = card;
		
		EventBus.displayNewStatusMessage.dispatch("Pick an option");
		optionMenu.setCardName(card.name);
		optionMenu.setOption1("deploy unit".toUpperCase(), EventBus.playerWantsTo_deployAUnit.dispatch, card);
		optionMenu.setOption2(null, null);
		
		optionMenu.show();
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
		researchMenu.show();
	}
	
	function playerWantsToBuildUnits(card:PlayableCard):Void
	{
		constructionMenu.show();
	}
	
	function playerWantsToConnectBases(card:PlayableCard):Void
	{
		// TODO: Count the number of bases
		// Warn if there are too few bases to connect
		// Ask player to select two bases
	}
	
	function playerWantsToGatherResources(card:PlayableCard):Void
	{
		var resources:Int = card.resources;
		if (resources > 0) {
			var activePlayer = Index.activeGame.activePlayer;
			activePlayer.resources += resources;
			
			EventBus.activePlayerResourcesChanged.dispatch(activePlayer);
			
			discardActiveCard();
		}
	}
	
	function processCardPurchase(card:PlayableCard):Void
	{
		var activePlayer = Index.activeGame.activePlayer;
		if (activePlayer.resources >= card.cost) {
			activePlayer.resources = activePlayer.resources - card.cost;
			
			EventBus.activePlayerResourcesChanged.dispatch(activePlayer);
			EventBus.addNewCardToActivePlayersDiscardPile.dispatch(card);
			
			discardActiveCard();
		}
	}
	
	function removeTheActiveCardFromThePlayersHand(?model):Void
	{
		discardActiveCard();
	}
	
	function discardActiveCard():Void
	{
		if (activeCard != null)
		{
			EventBus.removeCardFromActivePlayersHand.dispatch(activeCard);
			activeCard = null;
		}
		else
		{
			throw "No active card set to discard.";
		}
	}
	
}