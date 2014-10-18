package net.mkv25.game.ui;

import haxe.Timer;
import motion.Actuate;
import net.mkv25.base.core.Screen;
import net.mkv25.base.core.ScreenController;
import net.mkv25.base.ui.BaseUI;
import net.mkv25.base.ui.TextUI;
import openfl.display.DisplayObject;
import openfl.display.Graphics;
import openfl.events.MouseEvent;
import openfl.Lib;

class TooltipUI extends BaseUI
{
	var text:TextUI;
	
	var lastSeenObject:DisplayObject;
	var regsiteredObjects:Map<DisplayObject, String>;
	
	var mouseDown:Bool;

	public function new() 
	{
		super();
		
		regsiteredObjects = new Map<DisplayObject, String>();
		
		init();
	}
	
	function init()
	{
		text = cast TextUI.makeFor("Tooltip goes here", 0x222222).fontSize(18).alignCenter().size(400, 100);
		
		artwork.addChild(text.artwork);
		
		artwork.alpha = 0.0;
		disable();
		hide();
		
		// register events
		Lib.current.stage.addEventListener(MouseEvent.MOUSE_UP, function(?event) {
			mouseDown = false;
			lastSeenObject = null;
			checkToHideTooltip(null);
		});
	}
	
	public function setup(screenController:ScreenController):Void
	{
		screenController.addLayer(artwork);
	}
	
	public function registerTooltip(displayObject:DisplayObject, tooltip:String):Void
	{
		if (displayObject == null)
		{
			return;
		}
		
		regsiteredObjects.set(displayObject, tooltip);
		
		#if mobile
			displayObject.addEventListener(MouseEvent.MOUSE_DOWN, function(?event) {
				mouseDown = true;
				showMobileTooltipFor(displayObject);
			});	
		#else
			displayObject.addEventListener(MouseEvent.MOUSE_OVER, function(?event) {
				showTooltipFor(displayObject);
			});
			
			displayObject.addEventListener(MouseEvent.MOUSE_OUT, function(?event) {
				checkToHideTooltip(displayObject);
			});
		#end
		
		displayObject.addEventListener(MouseEvent.MOUSE_UP, function(?event) {
			mouseDown = false;
			checkToHideTooltip(displayObject);
		});
	}
	
	public function showTooltipFor(displayObject:DisplayObject):Void
	{
		var tooltip = regsiteredObjects.get(displayObject);
		
		// clear the active tooltip and kill any timers
		lastSeenObject = null;
		Actuate.stop(displayObject);
		
		// show and position tooltip
		lastSeenObject = displayObject;
		text.setText(tooltip.toUpperCase());
		draw();
		positionTooltip();
		
		// clear any animations, and wait to display tooltip
		Actuate.apply(artwork, { alpha: 0.0 } );
		Actuate.tween(artwork, 0.5, { alpha: 1.0 } ).delay(0.75).onComplete(function()
		{
			#if mobile
				openfl.feedback.Haptic.vibrate(5, 200);
			#end
		});
	}
	
	function showMobileTooltipFor(displayObject:DisplayObject):Void
	{
		Actuate.timer(0.8).onComplete(function() {
			if (mouseDown) {
				showTooltipFor(displayObject);
			}
		});
	}
	
	function checkToHideTooltip(displayObject:DisplayObject)
	{
		if (lastSeenObject == displayObject)
		{
			Actuate.tween(artwork, 1.0, { alpha: 0.0 } );
		}
	}
	
	function draw()
	{
		text.autoSize(300);
		
		var g:Graphics = artwork.graphics;
		g.clear();
		g.lineStyle(2, 0xCECECE, 0.7);
		g.beginFill(0xEFEFEF, 0.8);
		g.drawRect(0, 0, text.artwork.width, text.artwork.height);
		g.endFill();
	}
	
	function positionTooltip()
	{
		// position near last seen object
		if (lastSeenObject != null)
		{
			#if mobile
				moveRelativeTo(lastSeenObject, - (artwork.width / 2), - (lastSeenObject.height / 2) - 10 - artwork.height);
			#else
				moveRelativeTo(lastSeenObject, - (artwork.width / 2), (lastSeenObject.height / 2) + 10);
			#end
		}
		else
		{
			center(artwork, Screen.WIDTH / 2, Screen.HEIGHT / 2);
		}
		
		// restrict boundaries
		if (artwork.x < 5) {
			artwork.x = 5;
		}
		
		if (artwork.x > Screen.WIDTH - artwork.width){
			artwork.x = Screen.WIDTH - artwork.width;
		}
		
		if (artwork.y < 5) {
			artwork.y = 5;
		}
		
		if (artwork.y > Screen.HEIGHT - artwork.height) {
			artwork.y = Screen.HEIGHT - artwork.height;
		}
	}
	
}