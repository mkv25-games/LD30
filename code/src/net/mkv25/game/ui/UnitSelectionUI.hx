package net.mkv25.game.ui;

import net.mkv25.base.ui.BaseUI;
import net.mkv25.base.ui.BitmapUI;
import net.mkv25.base.ui.BubbleCircleUI;
import net.mkv25.base.ui.TextUI;
import net.mkv25.game.event.EventBus;
import net.mkv25.game.models.MapUnit;
import net.mkv25.game.models.PlayerModel;
import net.mkv25.game.provider.IconProvider;

class UnitSelectionUI extends BaseUI
{
	var unitIcon:BitmapUI;
	var circle:BubbleCircleUI;
	
	var unitNameText:TextUI;
	var strengthText:TextUI;

	public function new() 
	{
		super();
		
		circle = new BubbleCircleUI();
		
		var icon = IconProvider.ICON_6_PLAYER;
		unitIcon = new BitmapUI();
		unitIcon.setBitmapData(icon);
		
		unitNameText = cast TextUI.makeFor("Unit name".toUpperCase(), 0xFFFFFF).fontSize(16).alignLeft().size(150, 25).move(50, -25);
		strengthText = cast TextUI.makeFor("Strength: 0".toUpperCase(), 0xEEEEEE).fontSize(14).alignLeft().size(150, 25).move(50, 0);
		
		artwork.addChild(circle.artwork);
		artwork.addChild(unitIcon.artwork);
		artwork.addChild(unitNameText.artwork);
		artwork.addChild(strengthText.artwork);
		
		this.disable();
		
		EventBus.unitSelectionChanged.add(onUnitSelectionChanged);
	}
	
	function onUnitSelectionChanged(unit:MapUnit):Void
	{
		if (unit != null)
		{
			unitIcon.setBitmapData(unit.icon);
			
			if (unit.type != null)
			{
				unitNameText.setText(unit.type.name.toUpperCase());
				strengthText.setText(("Strength: " + unit.type.strength).toUpperCase());
			}
			else
			{
				unitNameText.setText("Unknown unit type".toUpperCase());
				strengthText.setText("Strength unknown".toUpperCase());
			}
			
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