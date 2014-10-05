package net.mkv25.base.ui;

import flash.events.Event;
import flash.Lib;
import flash.system.System;
import net.mkv25.base.core.Signal;
import openfl.Assets;
import flash.display.BitmapData;
import flash.display.Bitmap;

class AnimationUI 
{
	public var artwork:Bitmap;
	public var complete:Signal;
	public var lastFrame(get, null):Int;
	
	var frame:Int;
	var frames:Array<Int>;
	
	var fps:Int = 5;
	var loop:Bool = false;
	var startTime:Float;
	
	public function new() 
	{
		artwork = new Bitmap();
		
		frame = 0;
		frames = [frame];
		
		complete = new Signal();
	}
	
	function draw(frame:Int):Void
	{
		throw "Not implemented";
	}
	
	function onEnterFrame(e)
	{
		if (artwork.stage == null)
			return;
		
		var time:Float = timeNow() - startTime;
		var frame:Int = Math.floor(time / 1000 * fps) % frames.length;
		
		draw(frames[frame]);
		
		if (!loop && frame == lastFrame)
		{
			stop();
			complete.dispatch(this);
		}
	}
	
	public function play()
	{
		stop();
		startTime = timeNow();
		loop = true;
		artwork.addEventListener(Event.ENTER_FRAME, onEnterFrame);
	}
	
	public function playOnce()
	{
		play();
		loop = false;
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
	
	function timeNow():Float
	{
		return Lib.getTimer();
	}
	
	function get_lastFrame():Int
	{
		if (frames == null || frames.length == 0)
		{
			return -1;
		}
		
		return frames[frames.length - 1];
	}
	
	public function show()
	{
		artwork.visible = true;
	}
	
	public function hide()
	{
		artwork.visible = false;
	}
}