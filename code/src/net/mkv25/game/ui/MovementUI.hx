package net.mkv25.game.ui;

import net.mkv25.base.ui.BaseUI;
import net.mkv25.base.ui.BitmapUI;
import net.mkv25.base.ui.IconButtonUI;
import net.mkv25.game.event.EventBus;

class MovementUI extends BaseUI
{
	public var moveButton:IconButtonUI;
	public var cancelButton:IconButtonUI;
	
	public function new() 
	{
		super();
		
		init();
	}
	
	function init() 
	{
		moveButton = new IconButtonUI();
		moveButton.setup("img/icon-move.png", moveButtonSelected);
		moveButton.move(MapUI.MAP_WIDTH - 40, 40);
		
		cancelButton = new IconButtonUI();
		cancelButton.setup("img/icon-cancel.png", cancelButtonSelected);
		cancelButton.move(MapUI.MAP_WIDTH - 100, 40);
		
		artwork.addChild(moveButton.artwork);
		artwork.addChild(cancelButton.artwork);
	}
	
	function moveButtonSelected(?model) 
	{
		EventBus.playerWantsTo_moveUnitAtSelectedLocation.dispatch(this);
	}
	
	function cancelButtonSelected(?model) 
	{
		EventBus.playerWantsTo_cancelTheCurrentAction.dispatch(this);
	}
	
}