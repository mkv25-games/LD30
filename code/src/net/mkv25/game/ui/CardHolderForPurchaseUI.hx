package net.mkv25.game.ui;

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