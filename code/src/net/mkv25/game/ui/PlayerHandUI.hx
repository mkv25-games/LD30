package net.mkv25.game.ui;

import flash.display.Sprite;
import net.mkv25.base.ui.BaseUI;
import net.mkv25.base.ui.BitmapUI;
import net.mkv25.game.models.PlayerHand;

class PlayerHandUI extends BaseUI
{
	private var model:PlayerHand;
	
	var cards:Array<BitmapUI>;
	var recycler:Sprite;
	
	public function new() 
	{
		super();
		
		cards = new Array<BitmapUI>();
		recycler = new Sprite();
		
		init();
	}
	
	public function init():Void
	{
		for (i in 0...PlayerHand.MAX_HAND_SIZE)
		{
			var card = new BitmapUI();
			cards.push(card);
		}
	}
	
	public function display(playersHand:PlayerHand):PlayerHandUI
	{
		this.model = playersHand;
		
		for (i in 0...cards.length)
		{
			var cardHolder = cards[i];
			if (i < playersHand.hand.length)
			{
				var card = playersHand.hand[i];
				cardHolder.setBitmapData(card.picture);
				artwork.addChild(cardHolder.artwork);
				
				var overlap = 50;
				cardHolder.move((cardHolder.artwork.width / 2) + (i * (cardHolder.artwork.width - overlap)), cardHolder.artwork.height / 2);
			}
			else
			{
				recycler.addChild(cardHolder.artwork);
			}
		}
		
		return this;
	}
	
}