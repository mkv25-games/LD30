package net.mkv25.base.ui;

import flash.events.Event;
import flash.Lib;
import flash.system.System;
import openfl.Assets;
import flash.display.BitmapData;
import flash.display.Bitmap;

class AnimationUI 
{
	public var artwork:Bitmap;
	
	var frame:Int;
	var frames:Array<Int>;
	
	var fps:Int = 5;
	
	public function new() 
	{
		artwork = new Bitmap();
		
		frame = 0;
		frames = [frame];
	}
	
	function draw(frame:Int):Void
	{
		throw "Not implemented";
	}
	
	function onEnterFrame(e)
	{
		if (artwork.stage == null)
			return;
		
		var time:Float = Lib.getTimer();
		var frame:Int = Math.floor(time / 1000 * fps);
		draw(frames[frame % frames.length]);
	}
	
	public function play()
	{
		stop();
		artwork.addEventListener(Event.ENTER_FRAME, onEnterFrame);
	}
	
	public function stop()
	{
		artwork.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
	}
	
	public function setFramesPerSecond(fps:Int):Void
	{
		this.fps = fps;
	}
	
	public function setFrames(frames:Array<Int>):Void
	{
		if (frames == null) throw "Invalid parameter, cannot set frames to null.";
		
		this.frames = frames;
	}
	
	public function drawFirst():Void
	{
		draw(frames[0]);
	}
}