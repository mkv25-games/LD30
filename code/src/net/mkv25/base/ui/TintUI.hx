package net.mkv25.base.ui;

import flash.display.Graphics;
import openfl.display.Sprite;

class TintUI
{
	public static function createTint(color:UInt, alpha:Float, width:Float, height:Float):Sprite
	{
		var tint:Sprite = new Sprite();
		
		var graphics:Graphics = tint.graphics;
		
		graphics.beginFill(color, alpha);
		graphics.drawRect(0, 0, width, height);
		graphics.endFill();
		
		return tint;
	}
}