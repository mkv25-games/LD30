package net.mkv25.game.ui;

import net.mkv25.base.ui.BaseUI;
import net.mkv25.base.ui.BitmapUI;
import net.mkv25.base.ui.IconButtonUI;
import net.mkv25.base.ui.TextUI;
import net.mkv25.game.event.EventBus;
import openfl.text.TextFormatAlign;

class MovementUI extends BaseUI
{
	public var cancelButton:IconButtonUI;
	public var selectUnitButton:IconButtonUI;
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
		cancelButton.move(MapUI.MAP_WIDTH - 160, 40);
		
		selectUnitButton = new IconButtonUI();
		selectUnitButton.setup("img/icon-move.png", moveButtonSelected);
		selectUnitButton.move(MapUI.MAP_WIDTH - 100, 40);
		
		confirmButton = new IconButtonUI();
		confirmButton.setup("img/icon-confirm.png", confirmButtonSelected);
		confirmButton.move(MapUI.MAP_WIDTH - 40, 40);
		
		Index.tooltipHud.registerTooltip(cancelButton.artwork, "Cancel movement action"); 
		Index.tooltipHud.registerTooltip(selectUnitButton.artwork, "Change unit selection"); 
		Index.tooltipHud.registerTooltip(confirmButton.artwork, "Confirm movement"); 
		
		artwork.addChild(cancelButton.artwork);
		artwork.addChild(selectUnitButton.artwork);
		artwork.addChild(confirmButton.artwork);
	}
	
	function cancelButtonSelected(?model) 
	{
		EventBus.playerWantsTo_cancelTheCurrentAction.dispatch(this);
	}
	
	function moveButtonSelected(?model) 
	{
		EventBus.playerWantsTo_moveUnitAtSelectedLocation.dispatch(this);
	}
	
	function confirmButtonSelected(?model) 
	{
		EventBus.playerWantsTo_confirmTheSelectedMovementAction.dispatch(this);
	}
	
}