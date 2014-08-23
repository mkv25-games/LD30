package net.mkv25.base.core;

import openfl.Assets;
import flash.display.BitmapData;
import flash.geom.Point;
import flash.geom.Rectangle;

class ImageRegion
{
	public static function getImageRegion(source:String, x:Int, y:Int, width:Int, height:Int):BitmapData {		
		return Image.getImage(source, new Rectangle(x, y, width, height));
	}
	
	private static function getImage(source:String, rectangle:Rectangle, outputOffset:Point = null):BitmapData {		
		var output:BitmapData = new BitmapData(cast rectangle.width, cast rectangle.height);
		var source:BitmapData = Assets.getBitmapData(source);
		if (outputOffset == null) outputOffset = new Point();
		
		output.copyPixels(source, rectangle, outputOffset);
		
		return output;
	}
}