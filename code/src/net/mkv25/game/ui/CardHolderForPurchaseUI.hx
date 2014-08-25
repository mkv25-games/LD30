package net.mkv25.game.ui;

import flash.display.Graphics;
import flash.events.MouseEvent;
import net.mkv25.base.core.Signal;
import net.mkv25.base.ui.BitmapUI;
import net.mkv25.game.event.EventBus;
import net.mkv25.game.models.PlayableCard;
import net.mkv25.game.ui.CardHolderUI;

class CardHolderForPurchaseUI extends CardHolderUI
{
	public function new() 
	{
		super();
	}
	
	override function overState()
	{
		super.overState();
		
		center(bitmap, 0, 0);
		scale = 0.9;
	}
	
	override function upState() 
	{
		super.upState();
		
		center(bitmap, 0, 0);
		scale = 0.8;
	}
	
	override function downState() 
	{
		super.upState();
		
		center(bitmap, 0, 0);
		scale = 0.75;
	}
	
}