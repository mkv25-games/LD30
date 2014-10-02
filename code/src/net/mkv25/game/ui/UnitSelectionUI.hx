package net.mkv25.game.ui;

import net.mkv25.base.ui.BaseUI;
import net.mkv25.base.ui.BitmapUI;
import net.mkv25.base.ui.BubbleCircleUI;
import net.mkv25.game.event.EventBus;
import net.mkv25.game.models.MapUnit;
import net.mkv25.game.models.PlayerModel;
import net.mkv25.game.provider.IconProvider;

class UnitSelectionUI extends BaseUI
{
	public var unitIcon:BitmapUI;
	public var circle:BubbleCircleUI;

	public function new() 
	{
		super();
		
		circle = new BubbleCircleUI();
		unitIcon = new BitmapUI();
		
		var icon = IconProvider.ICON_6_PLAYER;
		unitIcon.setBitmapData(icon);
		
		artwork.addChild(circle.artwork);
		artwork.addChild(unitIcon.artwork);
		
		circle.disable();
		unitIcon.disable();
		this.disable();
		
		EventBus.unitSelectionChanged.add(onUnitSelectionChanged);
	}
	
	function onUnitSelectionChanged(unit:MapUnit):Void
	{
		if (unit != null)
		{
			unitIcon.setBitmapData(unit.icon);
			
			show();
		}
		else
		{
			hide();
		}
	}
	
	override public function show() 
	{
		super.show();
		
		var player:PlayerModel = Index.activeGame.activePlayer;
		if (player != null)
		{
			circle.draw(unitIcon.artwork.width, player.playerColour.value, 0x444444);
		}
		
		circle.popIn();
		unitIcon.zoomIn();
	}
}