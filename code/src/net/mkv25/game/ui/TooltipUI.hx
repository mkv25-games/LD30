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

class TooltipUI extends BaseUI
{
	var text:TextUI;
	
	var lastSeenObject:DisplayObject;
	var regsiteredObjects:Map<DisplayObject, String>;

	public function new() 
	{
		super();
		
		regsiteredObjects = new Map<DisplayObject, String>();
		
		text = cast TextUI.makeFor("Tooltip goes here", 0xEEEEEE).fontSize(22).alignCenter().size(400, 100);
		
		artwork.addChild(text.artwork);
		
		artwork.alpha = 0.0;
		disable();
		hide();
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
		
		displayObject.addEventListener(MouseEvent.MOUSE_OVER, function(?event) {
			showTooltipFor(displayObject);
		});
		
		displayObject.addEventListener(MouseEvent.MOUSE_OUT, function(?event) {
			checkToHideTooltip(displayObject);
		});
		
		displayObject.addEventListener(MouseEvent.MOUSE_UP, function(?event) {
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
		text.setText(tooltip);
		draw();
		positionTooltip();
		
		// display straight away if partially visible, or wait a moment
		if (artwork.alpha > 0.0)
		{
			artwork.alpha = 1.0;
			show();
		}
		Actuate.tween(artwork, 0.5, { alpha: 1.0 } ).delay(0.75);
	}
	
	function checkToHideTooltip(displayObject:DisplayObject)
	{
		if (lastSeenObject == displayObject)
		{
			Actuate.tween(artwork, 1.0, { alpha: 0.0 } );
		}
	}
	
	public function hideTooltip():Void
	{
		visible = false;
	}
	
	function draw()
	{
		text.autoSize(300);
		
		var g:Graphics = artwork.graphics;
		g.clear();
		g.lineStyle(2, 0x999999, 0.5);
		g.beginFill(0x111111, 0.7);
		g.drawRect(0, 0, text.artwork.width, text.artwork.height);
		g.endFill();
	}
	
	function positionTooltip()
	{
		// position near last seen object
		if (lastSeenObject != null)
		{
			moveRelativeTo(lastSeenObject, - (artwork.width / 2), artwork.height + 10);
		}
		else
		{
			center(artwork, Screen.WIDTH / 2, Screen.HEIGHT / 2);
		}
		
		// restrict boundaries
		if (artwork.x < 5) {
			artwork.x = 5;
		}
		
		if (artwork.x > Screen.WIDTH - artwork.width) {
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