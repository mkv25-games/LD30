package net.mkv25.game.controllers;
import net.mkv25.base.core.ScreenController;
import net.mkv25.game.event.EventBus;
import net.mkv25.game.models.PlayableCard;
import net.mkv25.game.ui.InGameMenuUI;

class CardActionController
{
	var menu:InGameMenuUI;
	var activeCard:PlayableCard;

	public function new() 
	{
		
	}
	
	public function setup(screenController:ScreenController):Void
	{
		EventBus.askPlayerHowTheyWantToPlayTheirActionCard.add(showOptionsForActionCard);
		EventBus.askPlayerWhereTheyWantToDeployTheirUnitCard.add(showOptionsForUnitCard);
		EventBus.playerWantsToCancelTheCurrentAction.add(clearAnyActiveState);
		
		menu = new InGameMenuUI();
		menu.hide();
		
		screenController.addLayer(menu.artwork);
	}
	
	function clearAnyActiveState(?model):Void
	{
		activeCard = null;
	}
	
	function showOptionsForActionCard(card:PlayableCard):Void
	{
		activeCard = card;
		
		EventBus.displayNewStatusMessage.dispatch("Choose an action for this card.");
		menu.setCardName(card.name);
		menu.setOption1("move a unit".toUpperCase(), EventBus.playerWantsToMoveAUnit.dispatch, card);
		menu.setOption2(card.action.toUpperCase(), EventBus.playerWantsToPerformASpecialAction.dispatch, card);
		
		menu.show();
	}
	
	function showOptionsForUnitCard(card:PlayableCard):Void
	{
		activeCard = card;
		
		EventBus.displayNewStatusMessage.dispatch("Where do you want to deploy this unit?");
		menu.setCardName(card.name);
		menu.setOption1("deploy in space".toUpperCase(), EventBus.playerWantsToMoveAUnit.dispatch, card);
		menu.setOption2("deploy on planet".toUpperCase(), EventBus.playerWantsToPerformASpecialAction.dispatch, card);
		
		menu.show();
	}
	
}