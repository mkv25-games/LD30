package net.mkv25.game.ui;

import flash.display.Sprite;
import motion.Actuate;
import net.mkv25.base.core.Recycler;
import net.mkv25.base.core.Screen;
import net.mkv25.base.ui.BaseUI;
import net.mkv25.base.ui.BitmapUI;
import net.mkv25.base.ui.TextUI;
import net.mkv25.game.event.EventBus;
import net.mkv25.game.models.PlayableCard;
import net.mkv25.game.models.PlayerHand;
import net.mkv25.game.provider.CardPictureProvider;
import openfl.Assets;
import openfl.text.TextFormatAlign;

class PlayerHandUI extends BaseUI
{
	private var model:PlayerHand;
	
	var cardRecycler:Recycler<CardHolderUI>;
	var cards:Array<CardHolderUI>;
	
	var discardCountText:TextUI;
	var deckCountText:TextUI;
	
	var discardIcon:BitmapUI;
	var deckIcon:BitmapUI;
	
	public function new() 
	{
		super();
		
		cardRecycler = new Recycler<CardHolderUI>(CardHolderUI);
		cards = new Array<CardHolderUI>();
		
		init();
		
		Index.discardPileHud = discardIcon;
	}
	
	public function init():Void
	{
		discardCountText = cast TextUI.makeFor("X : DISCARDS", 0x111111).fontSize(24).align(TextFormatAlign.LEFT).size(200, 40).move(45, 250 - 42);
		deckCountText = cast TextUI.makeFor("DECK : X", 0x111111).fontSize(24).align(TextFormatAlign.RIGHT).size(200, 40).move(Screen.WIDTH - 200 - 45, 250 - 42);
		
		discardIcon = cast BitmapUI.makeFor(Assets.getBitmapData("img/icon-discard.png")).move(25, 250 - 25);
		deckIcon = cast BitmapUI.makeFor(Assets.getBitmapData("img/icon-draw.png")).move(Screen.WIDTH - 25, 250 - 25);
		
		EventBus.playerWantsTo_cancelTheCurrentAction.add(deselectTheActiveCard);
		EventBus.addNewCardToActivePlayersDiscardPile.add(addNewCardToDiscardPile);
		EventBus.removeCardFromActivePlayersHand.add(removeCardFromHand);
		EventBus.trashCardFromActivePlayersHand.add(trashCardFromHand);
		
		artwork.addChild(discardCountText.artwork);
		artwork.addChild(deckCountText.artwork);
		artwork.addChild(discardIcon.artwork);
		artwork.addChild(deckIcon.artwork);
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
		cardRecycler.recycleAll();
		while (cards.length > 0)
		{
			cards.pop();
		}
		
		updateHandCounts();
		
		// populate cards with data
		var cardsInHand = playersHand.getHand();
		for (i in 0...PlayerHand.MAX_HAND_SIZE)
		{
			var cardHolder = cardRecycler.get();
			cards.push(cardHolder);
			Actuate.stop(cardHolder.artwork);
			artwork.addChild(cardHolder.artwork);
			
			cardHolder.selected.removeAll();
			cardHolder.selected.add(onCardHolderSelected);
			
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
				Actuate.timer(0.5 + i * 0.25).onComplete(moveCardFromDeckToHand, [cardHolder, (i + 1)]);
			}
			else
			{
				cardHolder.setup(null);
				cardHolder.selected.removeAll();
			}
		}
		
		// reset selection state of cards
		for (card in cards)
		{
			artwork.addChild(card.artwork);
			card.deselect();
		}
		
		// renable after a delay for animations
		var totalAnimationTime = 0.5 + (cards.length * 0.25) + 0.5;
		Actuate.timer(totalAnimationTime).onComplete(enable);
		
		return this;
	}
	
	function moveCardFromDeckToHand(cardHolder:CardHolderUI, cardNumber:Int):Void
	{
		cardHolder.animateDrawFromDeck(deckIcon.artwork.x, deckIcon.artwork.y, cardHolder.artwork.x, cardHolder.artwork.y);
		
		var cardCountInAnimation:Int = (model.getDeck().length + model.getHand().length - cardNumber);
		deckCountText.setText("DRAW DECK : " + cardCountInAnimation);
	}
	
	function updateHandCounts():Void
	{
		if (model == null)
		{
			return;
		}
		
		discardCountText.setText(model.getDiscards().length + " : DISCARDS");
		deckCountText.setText("DRAW DECK : " + model.getDeck().length);
		
		(model.getDeck().length > 0) ? deckIcon.enable() : deckIcon.disable();
		(model.getDiscards().length > 0) ? discardIcon.enable() : discardIcon.disable();
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
		
		var cardHolder:CardHolderUI = cardRecycler.get();
		artwork.addChild(cardHolder.artwork);
		
		cardHolder.move(Screen.WIDTH / 2, - 200);
		cardHolder.show();
		cardHolder.scale = 1.0;
		cardHolder.artwork.alpha = 1.0;
		cardHolder.setupCard(card);
		cardHolder.disable();
		
		cardHolder.move(artwork.mouseX, artwork.mouseY);
		
		cardHolder.zoomIn().onComplete(cardHolder.animateDiscard, [discardIcon.artwork.x, discardIcon.artwork.y]);
		
		updateHandCounts();
	}
	
	function removeCardFromHand(selectedCard:PlayableCard):Void
	{
		model.removeCardFromHand(selectedCard);
		
		for (card in cards)
		{
			if (card.isSelected())
			{
				card.disable();
				card.animateDiscard(discardIcon.artwork.x, discardIcon.artwork.y);
			}
		}
		
		if (model.numberOfCardsInHand() == 0)
		{
			EventBus.playerHasRanOutCards.dispatch(this);
		}
		
		updateHandCounts();
	}
	
	function trashCardFromHand(selectedCard:PlayableCard):Void
	{
		model.trashCardFromHand(selectedCard);
		
		for (card in cards)
		{
			if (card.isSelected())
			{
				card.disable();
				card.animateDiscard(card.artwork.x, card.artwork.y - card.artwork.height);
			}
		}
		
		if (model.numberOfCardsInHand() == 0)
		{
			EventBus.playerHasRanOutCards.dispatch(this);
		}
		
		updateHandCounts();
	}
}