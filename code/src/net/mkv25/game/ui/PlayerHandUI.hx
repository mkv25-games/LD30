package net.mkv25.game.ui;

import flash.display.Sprite;
import net.mkv25.base.ui.BaseUI;
import net.mkv25.base.ui.BitmapUI;
import net.mkv25.game.event.EventBus;
import net.mkv25.game.models.PlayableCard;
import net.mkv25.game.models.PlayerHand;

class PlayerHandUI extends BaseUI
{
	private var model:PlayerHand;
	
	var cards:Array<CardHolderUI>;
	var recycler:Sprite;
	
	public function new() 
	{
		super();
		
		cards = new Array<CardHolderUI>();
		recycler = new Sprite();
		
		init();
	}
	
	public function init():Void
	{
		for (i in 0...PlayerHand.MAX_HAND_SIZE)
		{
			var card = new CardHolderUI();
			card.selected.add(onCardHolderSelected);
			cards.push(card);
		}
		
		EventBus.playerWantsTo_cancelTheCurrentAction.add(deselectTheActiveCard);
		EventBus.removeCardFromActivePlayersHand.add(removeCardFromHand);
	}
	
	public function display(playersHand:PlayerHand):PlayerHandUI
	{
		this.model = playersHand;
		
		// populate cards with data
		for (i in 0...cards.length)
		{
			var cardHolder = cards[i];
			if (i < playersHand.hand.length)
			{
				var card = playersHand.hand[i];
				cardHolder.setupCard(card);
				cardHolder.enable();
				
				var overlap = 50;
				cardHolder.move((cardHolder.artwork.width / 2) + (i * (cardHolder.artwork.width - overlap)), cardHolder.artwork.height / 2);
			}
			else
			{
				cardHolder.setup(null);
				recycler.addChild(cardHolder.artwork);
			}
		}
		
		// reset selection state of cards
		for (card in cards)
		{
			artwork.addChild(card.artwork);
			card.deselect();
		}
		
		return this;
	}
	
	function onCardHolderSelected(selectedCard:CardHolderUI):Void
	{
		// reset selection state of other cards
		for (card in cards)
		{
			artwork.addChild(card.artwork);
			if(card != selectedCard) {
				card.deselect();
			}
		}
		// bring selected card to front
		artwork.addChild(selectedCard.artwork);
		
		// mark it as selected
		selectedCard.select();
		
		// tell the world
		EventBus.displayNewStatusMessage.dispatch("Card selected: " + selectedCard.assignedCard.name);
		EventBus.cardSelectedFromHandByPlayer.dispatch(selectedCard.assignedCard);
	}
	
	function deselectTheActiveCard(?model):Void
	{
		// reset selection state of cards
		for (card in cards)
		{
			artwork.addChild(card.artwork);
			card.deselect();
		}
	}
	
	function removeCardFromHand(selectedCard:PlayableCard):Void
	{
		model.hand.remove(selectedCard);
		model.discards.push(selectedCard);
			
		for (card in cards)
		{
			if (card.isSelected()) {
				card.disable();
				card.popOut();
			}
		}
		
		if (model.hand.length == 0)
		{
			EventBus.playerHasRanOutCards.dispatch(this);
		}
	}
}