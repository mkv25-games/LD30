package net.mkv25.game.ui;

import flash.display.Graphics;
import net.mkv25.base.ui.BaseUI;
import net.mkv25.base.ui.BitmapUI;
import net.mkv25.base.ui.IconButtonUI;
import net.mkv25.base.ui.TextUI;
import net.mkv25.game.event.EventBus;
import net.mkv25.game.models.MapUnit;
import openfl.geom.Point;
import openfl.text.TextFormatAlign;

class PortalsUI extends BaseUI
{
	public var cancelButton:IconButtonUI;
	public var portal1Button:IconButtonUI;
	public var portal2Button:IconButtonUI;
	public var confirmButton:IconButtonUI;
	
	var base1Icon:BitmapUI;
	var base2Icon:BitmapUI;
	
	var p1:Point = new Point();
	var p2:Point = new Point();
	
	public function new() 
	{
		super();
		
		init();
	}
	
	function init() 
	{
		cancelButton = new IconButtonUI();
		cancelButton.setup("img/icon-cancel.png", cancelButtonSelected);
		cancelButton.move(MapUI.MAP_WIDTH - 220, 40);
		
		portal1Button = new IconButtonUI();
		portal1Button.setup("img/icon-portal-1.png", portalButtonSelected);
		portal1Button.move(MapUI.MAP_WIDTH - 160, 40);
		
		portal2Button = new IconButtonUI();
		portal2Button.setup("img/icon-portal-2.png", portalButtonSelected);
		portal2Button.move(MapUI.MAP_WIDTH - 100, 40);
		
		confirmButton = new IconButtonUI();
		confirmButton.setup("img/icon-confirm.png", confirmButtonSelected);
		confirmButton.move(MapUI.MAP_WIDTH - 40, 40);
		
		base1Icon = new BitmapUI();
		base1Icon.move(portal1Button.artwork.x, portal1Button.artwork.y);
		base1Icon.disable();
		
		base2Icon = new BitmapUI();
		base2Icon.move(portal2Button.artwork.x, portal2Button.artwork.y);
		base2Icon.disable();
		
		Index.tooltipHud.registerTooltip(cancelButton.artwork, "Cancel portal connection"); 
		Index.tooltipHud.registerTooltip(portal1Button.artwork, "The first base in the connection"); 
		Index.tooltipHud.registerTooltip(portal2Button.artwork, "The second base in the connection"); 
		Index.tooltipHud.registerTooltip(confirmButton.artwork, "Confirm connection"); 
		
		artwork.addChild(cancelButton.artwork);
		artwork.addChild(portal1Button.artwork);
		artwork.addChild(portal2Button.artwork);
		artwork.addChild(confirmButton.artwork);
		artwork.addChild(base1Icon.artwork);
		artwork.addChild(base2Icon.artwork);
		
		drawConnectingLine();
	}
	
	function drawConnectingLine():Void
	{
		var graphics:Graphics = artwork.graphics;
		graphics.clear();
		
		p1.setTo(portal1Button.artwork.x, portal1Button.artwork.y);
		p2.setTo(portal2Button.artwork.x, portal2Button.artwork.y);
		
		graphics.lineStyle(6, 0xFFFFFF, 0.3);
		graphics.moveTo(p1.x, p1.y);
		graphics.lineTo(p2.x, p2.y);
		
		graphics.lineStyle(6, 0xFFFFFF, 0.3);
		graphics.moveTo(p2.x, p2.y);
		graphics.lineTo(p1.x, p1.y);
	}
	
	public function update(startUnit:MapUnit, endUnit:MapUnit):Void
	{
		updateIcon(base1Icon, startUnit);
		(startUnit == null) ? portal1Button.show() : portal1Button.hide();
		
		updateIcon(base2Icon, endUnit);
		(endUnit == null) ? portal2Button.show() : portal2Button.hide();
	}
	
	function updateIcon(icon:BitmapUI, unit:MapUnit):Void
	{
		if (unit == null)
		{
			icon.setBitmapData(null);
		}
		else
		{
			icon.setBitmapData(unit.icon);
		}
	}
	
	public function reset():Void
	{
		portal1Button.disable();
		portal2Button.disable();
		confirmButton.disable();
		
		base1Icon.setBitmapData(null);
		base2Icon.setBitmapData(null);
	}
	
	function cancelButtonSelected(?model) 
	{
		EventBus.playerWantsTo_cancelTheCurrentAction.dispatch(this);
	}
	
	function portalButtonSelected(?model) 
	{
		EventBus.playerWantsTo_connectBaseAtSelectedLocation.dispatch(this);
	}
	
	function confirmButtonSelected(?model) 
	{
		EventBus.playerWantsTo_openThePortal.dispatch(this);
	}
	
}