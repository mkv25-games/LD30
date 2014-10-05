package net.mkv25.base.core;

import openfl.Assets;
import flash.display.BitmapData;
import flash.geom.Point;
import flash.geom.Rectangle;

class ImageRegion
{
	public static function getImageRegion(sourcePath:String, x:Int, y:Int, width:Int, height:Int):BitmapData {		
		return ImageRegion.getImage(sourcePath, new Rectangle(x, y, width, height));
	}
	
	private static function getImage(sourcePath:String, rectangle:Rectangle, outputOffset:Point = null):BitmapData {		
		var output:BitmapData = new BitmapData(cast rectangle.width, cast rectangle.height);
		var source:BitmapData = Assets.getBitmapData(sourcePath);
		if (outputOffset == null) outputOffset = new Point();
		
		output.copyPixels(source, rectangle, outputOffset);
		
		return output;
	}
	
	public static function getFrame(sourcePath:String, index:Int, width:Int, height:Int):BitmapData
	{
		var source:BitmapData = Assets.getBitmapData(sourcePath);
		var COLUMNS = source.width / width;
		var ROWS = source.height / height;
		
		var x = index % COLUMNS;
		var y = Math.floor(index / COLUMNS);
		
		var frameImage = ImageRegion.getImageRegion(sourcePath, Std.int(x * width), Std.int(y * height), width, height);
		return frameImage;
	}
}