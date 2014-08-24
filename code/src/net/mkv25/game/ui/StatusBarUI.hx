package net.mkv25.game.ui;

import flash.text.TextFormatAlign;
import net.mkv25.base.core.Screen;
import net.mkv25.base.ui.BaseUI;
import net.mkv25.base.ui.BitmapUI;
import net.mkv25.base.ui.TextUI;
import net.mkv25.game.provider.IconProvider;

class StatusBarUI extends BaseUI
{
	var playerNameText:TextUI;
	
	var counterUnitsText:TextUI;
	var counterTerritoryText:TextUI;
	var counterResourcesText:TextUI;
	
	var iconUnits:BitmapUI;
	var iconTerritory:BitmapUI;
	var iconResources:BitmapUI;

	public function new() 
	{
		super();
		
		init();
	}
	
	private function init():Void
	{
		IconProvider.setup();
		
		playerNameText = cast TextUI.makeFor("Player 1's Turn", 0x000000).fontSize(28).align(TextFormatAlign.LEFT).size(300, 40).move(10, 5);
		
		var rhs = Screen.WIDTH - 40;
		var spacing = 70;
		counterUnitsText = cast TextUI.makeFor("0", 0x000000).fontSize(28).align(TextFormatAlign.LEFT).size(50, 40).move(rhs - (spacing * 0), 7);
		counterTerritoryText = cast TextUI.makeFor("0", 0x000000).fontSize(28).align(TextFormatAlign.LEFT).size(50, 40).move(rhs - (spacing * 1), 7);
		counterResourcesText = cast TextUI.makeFor("0", 0x000000).fontSize(28).align(TextFormatAlign.LEFT).size(50, 40).move(rhs - (spacing * 2), 7);
		
		iconUnits = cast BitmapUI.makeFor(IconProvider.ICON_STATUS_UNITS).move(rhs - 20 - (spacing * 0), 25); 
		iconTerritory = cast BitmapUI.makeFor(IconProvider.ICON_STATUS_TERRITORY).move(rhs - 20 - (spacing * 1), 25); 
		iconResources = cast BitmapUI.makeFor(IconProvider.ICON_STATUS_RESOURCES).move(rhs - 20 - (spacing * 2), 25); 
		
		artwork.addChild(playerNameText.artwork);
		artwork.addChild(counterUnitsText.artwork);
		artwork.addChild(counterTerritoryText.artwork);
		artwork.addChild(counterResourcesText.artwork);
		artwork.addChild(iconUnits.artwork);
		artwork.addChild(iconTerritory.artwork);
		artwork.addChild(iconResources.artwork);
	}
	
}