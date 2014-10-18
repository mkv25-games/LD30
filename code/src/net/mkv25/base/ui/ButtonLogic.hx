package net.mkv25.base.ui;

import motion.Actuate;
import motion.actuators.GenericActuator.IGenericActuator;
import openfl.display.DisplayObject;
import openfl.events.Event;
import openfl.events.MouseEvent;

class ButtonLogic
{
	var artwork:DisplayObject;
	
	var waitingOnActivation:Bool;
	
	var readyToActivate:Bool;
	var mobileTouchTimer:IGenericActuator;
	
	public var upState:Void->Void;
	public var overState:Void->Void;
	public var downState:Void->Void;
	public var activate:Void->Void;

	public function new(artwork:DisplayObject) 
	{
		this.artwork = artwork;
		
		waitingOnActivation = false;
		
		readyToActivate = false;
		mobileTouchTimer = null;
		
		artwork.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
		artwork.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		artwork.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		artwork.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		
		artwork.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
	}
	
	function checkForActivation()
	{
		if (waitingOnActivation)
			return;
		
		waitingOnActivation = true;
		Actuate.timer(0.1).onComplete(onActivationComplete);
	}
	
	function onActivationComplete():Void
	{
		activate();
		waitingOnActivation = false;
	}
	
	function onAddedToStage(e)
	{
		upState();
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
		
		#if mobile
			readyToActivate = true;
			mobileTouchTimer = Actuate.tween(this, 0.75, {}).onComplete(preventActivation);
		#else
			checkForActivation();
		#end
	}
	
	function onMouseUp(e)
	{
		overState();
		
		#if mobile
			if (mobileTouchTimer != null)
			{
				mobileTouchTimer.onComplete(null);
				Actuate.stop(this);
			}
			
			if (readyToActivate)
			{
				activate();
			}
		#end
	}
	
	function preventActivation()
	{
		readyToActivate = false;
	}
	
}