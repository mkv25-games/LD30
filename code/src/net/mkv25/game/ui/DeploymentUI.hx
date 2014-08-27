package net.mkv25.game.ui;

import net.mkv25.base.ui.BaseUI;
import net.mkv25.base.ui.BitmapUI;
import net.mkv25.base.ui.IconButtonUI;
import net.mkv25.game.event.EventBus;

class DeploymentUI extends BaseUI
{
	public var deployButton:IconButtonUI;
	public var cancelButton:IconButtonUI;
	
	public function new() 
	{
		super();
		
		init();
	}
	
	function init() 
	{
		deployButton = new IconButtonUI();
		deployButton.setup("img/icon-deploy.png", deployButtonSelected);
		deployButton.move(MapUI.MAP_WIDTH - 40, 40);
		
		cancelButton = new IconButtonUI();
		cancelButton.setup("img/icon-cancel.png", cancelButtonSelected);
		cancelButton.move(MapUI.MAP_WIDTH - 100, 40);
		
		artwork.addChild(deployButton.artwork);
		artwork.addChild(cancelButton.artwork);
	}
	
	function deployButtonSelected(?model) 
	{
		EventBus.playerWantsTo_deployUnitAtSelectedLocationButton.dispatch(this);
	}
	
	function cancelButtonSelected(?model) 
	{
		EventBus.playerWantsTo_cancelTheCurrentAction.dispatch(this);
	}
	
}