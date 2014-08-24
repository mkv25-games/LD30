package net.mkv25.game.provider;
import flash.display.BitmapData;
import net.mkv25.base.core.Image.ImageRegion;


class CardPictureProvider
{
	public static var PICTURE_COLS:Int = 6;
	public static var PICTURE_WIDTH:Int = 140;
	public static var PICTURE_HEIGHT:Int = 200;
	
	public static function getPicture(index:Int = 1):BitmapData {
		
		var x = index % PICTURE_COLS;
		var y = Math.floor(index / PICTURE_COLS);
		
		var image = ImageRegion.getImageRegion("img/cards.png", x * PICTURE_WIDTH, y * PICTURE_HEIGHT, PICTURE_WIDTH, PICTURE_HEIGHT);
		return image;
	}
	
}