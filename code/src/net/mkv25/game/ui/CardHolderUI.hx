package net.mkv25.game.ui;

import flash.display.Graphics;
import flash.events.MouseEvent;
import net.mkv25.base.core.Signal;
import net.mkv25.base.ui.BitmapUI;
import net.mkv25.game.event.EventBus;
import net.mkv25.game.models.PlayableCard;

class CardHolderUI extends BitmapUI
{
	public var assignedCard:PlayableCard;
	public var selected:Signal;
	
	private var flagSelected:Bool = false;

	public function new() 
	{
		super();
		
		assignedCard = null;
		flagSelected = false;
		selected = new Signal();
		
		artwork.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
		artwork.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		artwork.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		artwork.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
	}
	
	public function setupCard(card:PlayableCard):CardHolderUI
	{
		this.assignedCard = card;
		
		var graphics:Graphics = artwork.graphics;
		graphics.clear();
		
		if (assignedCard == null)
		{
			bitmap.bitmapData = null;
		}
		else
		{
			this.setBitmapData(assignedCard.picture);
			
			// draw extended hit box
			graphics.beginFill(0x000000, 0.01);
			graphics.drawRect(-bitmap.width/2,- bitmap.height/2, bitmap.width, bitmap.height);
			graphics.endFill();
		}
		
		return this;
	}
	
	public function select():Void
	{
		this.flagSelected = true;
		overState();
	}
	
	public function deselect():Void
	{
		this.flagSelected = false;
		upState();
	}
	
	function selectedState():Void
	{
		center(bitmap, 0, -40);
	}
	
	function upState()
	{
		if (flagSelected) {
			selectedState();
			return;
		}
		
		center(bitmap, 0, 0);
	}
	
	function overState()
	{
		if (flagSelected) {
			selectedState();
			return;
		}
		
		center(bitmap, 0, -30);
	}
	
	function downState()
	{
		if (flagSelected) {
			selectedState();
			return;
		}
		
		center(bitmap, 0, -30);
	}
	
	function onMouseOver(e)
	{
		overState();
	}
	
	function onMouseOut(e)
	{
		upState();
	}
	
	function onMouseDown(e)
	{
		downState();
		this.zoomIn();
		this.selected.dispatch(this);
	}
	
	function onMouseUp(e)
	{
		overState();
	}
	
}