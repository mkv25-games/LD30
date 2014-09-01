package net.mkv25.game.ui;

import net.mkv25.base.ui.BaseUI;
import net.mkv25.base.ui.BitmapUI;
import net.mkv25.base.ui.IconButtonUI;
import net.mkv25.base.ui.TextUI;
import net.mkv25.game.event.EventBus;
import openfl.text.TextFormatAlign;

class PortalsUI extends BaseUI
{
	public var cancelButton:IconButtonUI;
	public var portal1Button:IconButtonUI;
	public var portal2Button:IconButtonUI;
	public var confirmButton:IconButtonUI;
	
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
		
		artwork.addChild(cancelButton.artwork);
		artwork.addChild(portal1Button.artwork);
		artwork.addChild(portal2Button.artwork);
		artwork.addChild(confirmButton.artwork);
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