package net.mkv25.game.ui;

import flash.display.Graphics;
import flash.display.Sprite;
import net.mkv25.base.core.Screen;
import net.mkv25.base.ui.BaseUI;
import net.mkv25.base.ui.ButtonUI;
import net.mkv25.base.ui.IconButtonUI;
import net.mkv25.base.ui.TextUI;
import net.mkv25.game.event.EventBus;
import net.mkv25.game.models.PlayerModel;
import net.mkv25.game.provider.CardPictureProvider;
import net.mkv25.game.provider.CardProvider;

class ResearchMenuUI extends BaseUI
{
	private static inline var SIZE:Int = 500;
	var backgroundCover:Sprite;
	var backgroundTint:Sprite;
	var titleText:TextUI;
	
	var cancelButton:IconButtonUI;
	
	var cards:Array<CardHolderUI>;
	var cardLayer:Sprite;
	
	public function new() 
	{
		super();
		
		cards = new Array<CardHolderUI>();
		cardLayer = new Sprite();
		
		init();
	}
	
	function init()
	{
		var hs = ResearchMenuUI.SIZE / 2;
		
		createBackgroundCover();
		createBackgroundTint();
		
		titleText = cast TextUI.makeFor("develop a technology".toUpperCase(), 0xFFFFFF).fontSize(32).size(ResearchMenuUI.SIZE, 40).move(0, 70);
		
		createCards();
		
		cancelButton = new IconButtonUI();
		cancelButton.setup("img/icon-back.png", cancelAction);
		cancelButton.move(hs, hs + 220);
		
		artwork.addChild(cancelButton.artwork);
		artwork.addChild(titleText.artwork);
	}
	
	override public function show() 
	{
		super.show();
		
		updateCards();
	}
	
	function createCards()
	{
		var sourceCards = Index.cardProvider.actionCards;
		for (sourceCard in sourceCards)
		{
			var card = new CardHolderForPurchaseUI();
			card.setupCard(sourceCard);
			card.scale = 0.8;
			cards.push(card);
			cardLayer.addChild(card.artwork);
			
			card.selected.add(onCardSelectedForPurchase);
		}
		
		artwork.addChild(cardLayer);
	}
	
	function updateCards()
	{
		var player:PlayerModel = Index.activeGame.activePlayer;
		for (card in cards)
		{
			if (card.assignedCard.cost > player.resources)
			{
				card.disable();
			}
			else
			{
				card.enable();
			}
		}
		
		positionCards();
	}
	
	function positionCards()
	{
		var columns = 3;
		
		var n:Int = 0;
		for (card in cards)
		{
			var column = n % columns;
			var row = Math.floor(n / columns);
			
			card.scale = 0.8;
			card.artwork.x = (column + 0.5) * card.artwork.width;
			card.artwork.y = (row + 0.5) * card.artwork.height;
			
			n++;
		}
		
		cardLayer.x = (ResearchMenuUI.SIZE / 2) - (cardLayer.width / 2);
		cardLayer.y = (ResearchMenuUI.SIZE / 2) - (cardLayer.height / 2) + 20;
	}
	
	function createBackgroundCover()
	{
		backgroundCover = new Sprite();
		
		var g:Graphics = backgroundCover.graphics;
		g.beginFill(0x000000, 0.1);
		g.drawRect(0, 0, ResearchMenuUI.SIZE, ResearchMenuUI.SIZE);
		g.endFill();
		
		backgroundCover.x = 0;
		backgroundCover.y = 0;
		artwork.addChild(backgroundCover);
	}
	
	function createBackgroundTint()
	{
		backgroundTint = new Sprite();
		
		var g:Graphics = backgroundTint.graphics;
		g.beginFill(0x000000, 0.4);
		g.drawRect(0, 0, Screen.WIDTH, Screen.HEIGHT);
		g.endFill();
		
		backgroundTint.x = 0;
		backgroundTint.y = 50;
		artwork.addChild(backgroundTint);
	}
	
	public function setTitle(text:String):Void
	{
		this.titleText.setText(text.toUpperCase());
	}
	
	function cancelAction(?model):Void
	{
		EventBus.playerWantsTo_cancelTheCurrentAction.dispatch(this);
		hide();
	}
	
	function onCardSelectedForPurchase(card:CardHolderUI)
	{
		EventBus.playerWantsTo_buyACard.dispatch(card.assignedCard);
	}
}