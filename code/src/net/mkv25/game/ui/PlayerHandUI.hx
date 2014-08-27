package net.mkv25.game.ui;

import flash.display.Sprite;
import motion.Actuate;
import net.mkv25.base.ui.BaseUI;
import net.mkv25.base.ui.BitmapUI;
import net.mkv25.game.event.EventBus;
import net.mkv25.game.models.PlayableCard;
import net.mkv25.game.models.PlayerHand;
import net.mkv25.game.provider.CardPictureProvider;

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
		EventBus.addNewCardToActivePlayersDiscardPile.add(addNewCardToDiscardPile);
		EventBus.removeCardFromActivePlayersHand.add(removeCardFromHand);
		EventBus.trashCardFromActivePlayersHand.add(trashCardFromHand);
	}
	
	override public function disable() 
	{
		super.disable();
		
		artwork.alpha = 1.0;
	}
	
	public function display(playersHand:PlayerHand):PlayerHandUI
	{
		this.model = playersHand;
		
		// while animating
		disable();
		
		// populate cards with data
		var cardsInHand = playersHand.getHand();
		for (i in 0...cards.length)
		{
			var cardHolder = cards[i];
			if (i < playersHand.numberOfCardsInHand())
			{
				var card = cardsInHand[i];
				cardHolder.setupCard(card);
				cardHolder.enable();
				cardHolder.scale = 1.0;
				
				var overlap = 50;
				cardHolder.artwork.x = (CardPictureProvider.PICTURE_WIDTH / 2) + (i * (CardPictureProvider.PICTURE_WIDTH - overlap));
				cardHolder.artwork.y = CardPictureProvider.PICTURE_HEIGHT / 2;
				
				cardHolder.hide();
				Actuate.timer(0.5 + i * 0.15).onComplete(cardHolder.zoomIn);
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
		
		// renable after a delay for animations
		var totalAnimationTime = 0.5 + (cards.length * 0.15) + 1.0;
		Actuate.timer(totalAnimationTime).onComplete(enable);
		
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
	
	function addNewCardToDiscardPile(card:PlayableCard):Void
	{
		model.addCardToDiscards(card);
	}
	
	function removeCardFromHand(selectedCard:PlayableCard):Void
	{
		model.removeCardFromHand(selectedCard);
		
		for (card in cards)
		{
			if (card.isSelected()) {
				card.disable();
				card.popOut();
			}
		}
		
		if (model.numberOfCardsInHand() == 0)
		{
			EventBus.playerHasRanOutCards.dispatch(this);
		}
	}
	
	function trashCardFromHand(selectedCard:PlayableCard):Void
	{
		model.trashCardFromHand(selectedCard);
		
		for (card in cards)
		{
			if (card.isSelected()) {
				card.disable();
				card.popOut();
			}
		}
		
		if (model.numberOfCardsInHand() == 0)
		{
			EventBus.playerHasRanOutCards.dispatch(this);
		}
	}
}