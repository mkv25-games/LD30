package net.mkv25.game.provider;
import flash.display.Bitmap;
import flash.display.BitmapData;
import net.mkv25.base.core.Image.ImageRegion;

class HexProvider
{
	public static var HEX_SIZE:Int = 50;

	public static var EMPTY_HEX:BitmapData;
	public static var HIGHLIGHTED_HEX:BitmapData;
	public static var MARKED_HEX:BitmapData;
	public static var BLOCKED_HEX:BitmapData;
	
	public static function setup():Void
	{
		EMPTY_HEX = getHex(1);
		HIGHLIGHTED_HEX = getHex(2);
		MARKED_HEX = getHex(9);
		BLOCKED_HEX = getHex(10);
	}
	
	private static function getHex(index:Int = 1):BitmapData {
		var hexImage = ImageRegion.getImageRegion("img/hexes.png", index * HEX_SIZE, 0, HEX_SIZE, HEX_SIZE);
		return hexImage;
	}
	
}