package net.mkv25.base.ui;

import flash.display.Bitmap;
import openfl.Assets;

class BitmapUI extends BaseUI
{
	var bitmap:Bitmap;
	
	public function new() 
	{
		super();
		
		bitmap = new Bitmap();
	}
	
	public function setup(path:String)
	{
		bitmap.bitmapData = Assets.getBitmapData(path);
		
		center(bitmap);
		
		artwork.addChild(bitmap);
	}
}