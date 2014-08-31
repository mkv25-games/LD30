package net.mkv25.game.ui;

import net.mkv25.base.ui.BaseUI;
import net.mkv25.base.ui.BitmapUI;
import net.mkv25.base.ui.TextUI;
import net.mkv25.game.models.PlayerModel;
import net.mkv25.game.provider.IconProvider;
import openfl.text.TextFormatAlign;

class UnitCountIndicatorUI extends BaseUI
{
	var bitmap:BitmapUI;
	var text:TextUI;

	public function new() 
	{
		super();
		
		bitmap = new BitmapUI();
		text = cast TextUI.makeFor("0", 0xFFFFFF).fontSize(15).align(TextFormatAlign.CENTER).size(30, 22);
		
		center(text.artwork);
		
		artwork.addChild(bitmap.artwork);
		artwork.addChild(text.artwork);
		
		artwork.mouseEnabled = artwork.mouseChildren = false;
	}
	
	public function setup(player:PlayerModel, label:String):Void
	{
		bitmap.setBitmapData(IconProvider.getPlayerIconFor(player));
		text.setText(label);
	}
	
}