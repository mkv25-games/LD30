package net.mkv25.game.provider;

import flash.display.Bitmap;
import flash.display.BitmapData;
import net.mkv25.base.core.Image.ImageRegion;

class IconProvider
{
	public static var ICON_COLS:Int = 10;
	public static var ICON_SIZE:Int = 40;
	
	public static var ICON_STATUS_UNITS:BitmapData;
	public static var ICON_STATUS_TERRITORY:BitmapData;
	public static var ICON_STATUS_RESOURCES:BitmapData;

	private static var alreadySetup:Bool = false;
	public static function setup():Void
	{
		if (alreadySetup) {
			return;
		}
		alreadySetup = true;
		
		ICON_STATUS_UNITS = getIcon(3);
		ICON_STATUS_RESOURCES = getIcon(2);
		ICON_STATUS_TERRITORY = getIcon(1);
		
	}
	
	private static function getIcon(index:Int = 1):BitmapData {
		
		var x = index % ICON_COLS;
		var y = Math.round(index / ICON_COLS);
		
		var iconImage = ImageRegion.getImageRegion("img/icons.png", x * ICON_SIZE, y * ICON_SIZE, ICON_SIZE, ICON_SIZE);
		return iconImage;
	}
	
}