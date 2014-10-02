package net.mkv25.game.ui;

import motion.actuators.GenericActuator.IGenericActuator;
import flash.display.Graphics;
import flash.events.MouseEvent;
import motion.Actuate;
import motion.easing.Elastic;
import motion.easing.Quad;
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
	
	override public function enable() 
	{
		super.enable();
		
		artwork.alpha = 1.0;
	}
	
	override public function disable() 
	{
		super.disable();
		
		artwork.alpha = 0.4;
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
			this.bitmap.smoothing = true;
			
			// draw extended hit box
			graphics.beginFill(0x000000, 0.01);
			graphics.drawRect(-bitmap.width/2,- bitmap.height/2, bitmap.width, bitmap.height);
			graphics.endFill();
		}
		
		upState();
		
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
	
	public function isSelected():Bool
	{
		return flagSelected;
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
	
	public function animateDiscard(discardX:Float, discardY:Float):IGenericActuator
	{
		Actuate.apply(artwork, { alpha: 1.0, scaleX: 1.0, scaleY: 1.0 } );
		return Actuate.tween(artwork, 0.6, { x: discardX, y: discardY } ).ease(Quad.easeOut).onComplete(function()
		{
			return Actuate.tween(artwork, 0.6, { alpha: 0.0, scaleX: 0.5, scaleY: 0.5 } );
		});
	}
	
	public function animateDrawFromDeck(deckX:Float, deckY:Float, targetX:Float, targetY:Float):IGenericActuator
	{
		Actuate.apply(artwork, { alpha: 0.0, scaleX: 0.5, scaleY: 0.5, x: deckX, y: deckY } );
		return Actuate.tween(artwork, 0.6, { x: targetX, y: targetY, alpha: 1.0, scaleX: 1.0, scaleY: 1.0 } ).ease(Quad.easeOut);
	}
	
}