package net.mkv25.game.ui;

import flash.display.BitmapData;
import net.mkv25.base.core.AnimationFrameCache;
import net.mkv25.base.core.Image.ImageRegion;
import net.mkv25.base.ui.AnimationUI;
import openfl.Assets;
import openfl.display.Bitmap;

class ExplosionAnimationUI extends AnimationUI
{
	var assetPath:String = "img/animation/explosion_x64.png";
	var animationPrefix:String = "explosion_";
	var frameWidth:Int = 64;
	var frameHeight:Int = 64;
	
	public function new() 
	{
		super();
		
		frames = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15];
		fps = 15;
	}
	
	override function draw(frame:Int):Void 
	{
		artwork.bitmapData = getFrame(frame);
	}

	function getFrame(frame:Int):BitmapData
	{
		var id:String = animationPrefix + Std.string(frame);
		var frameBitmap:BitmapData = AnimationFrameCache.singleton.getFrame(id);
		if (frameBitmap == null)
		{
			frameBitmap = ImageRegion.getFrame(assetPath, frame, frameWidth, frameHeight);
			AnimationFrameCache.singleton.setFrame(id, frameBitmap);
		}
		
		return frameBitmap;
	}
}