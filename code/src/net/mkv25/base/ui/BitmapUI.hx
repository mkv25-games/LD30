package net.mkv25.base.ui;

import flash.display.Bitmap;
import flash.display.BitmapData;
import net.mkv25.base.core.Image.ImageRegion;
import openfl.Assets;

class BitmapUI extends BaseUI
{
	var bitmap:Bitmap;
	
	public function new() 
	{
		super();
		
		bitmap = new Bitmap();
	}
	
	public function setup(path:String):BitmapUI
	{
		if (path == null)
		{
			bitmap.bitmapData = null;
			return this;
		}
		
		bitmap.bitmapData = Assets.getBitmapData(path);
		
		center(bitmap);
		
		artwork.addChild(bitmap);
		
		return this;
	}
	
	public function setBitmapData(bmp:BitmapData):BitmapUI
	{
		bitmap.bitmapData = bmp;
		
		center(bitmap);
		
		artwork.addChild(bitmap);
		
		return this;
	}
	
	public static function makeFor(bitmapData:BitmapData):BitmapUI
	{
		var bitmap:BitmapUI = new BitmapUI();
		
		bitmap.setBitmapData(bitmapData);
		
		return bitmap;
	}
}