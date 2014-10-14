package net.mkv25.base.core;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.KeyboardEvent;
import motion.Actuate;
import openfl.Assets;

class Screen
{
	public static var WIDTH:Int = 500;
	public static var HEIGHT:Int = 800;
	
	public var artwork:Sprite;

	private var background:Bitmap;
	private var setupFlag:Bool;
	private var lockKeysFlag:Bool;
	
	public var showComplete:Signal;
	public var hidden:Signal;
	
	var horizontalCenter(get_horizontalCenter, null):Float;
	var verticalCenter(get_verticalCenter, null):Float;
	
	public function new() 
	{
		artwork = new Sprite();
		
		background = new Bitmap();
		
		setupFlag = false;
		lockKeysFlag = false;
		
		showComplete = new Signal();
		hidden = new Signal();
		
		artwork.addChild(background);
	}
	
	public function setBackground(asset:String):Void
	{
		background.bitmapData = Assets.getBitmapData(asset);
		background.width = Screen.WIDTH;
		background.height = Screen.HEIGHT;
		background.smoothing = true;
	}
	
	private function setup():Void
	{
		throw "Abstract method, requires an override in a sub class.";
	}
	
	public function show():Void
	{
		if (!setupFlag)
		{
			setup();
			setupFlag = true;
		}
		
		artwork.alpha = 0.0;
		Actuate.tween(artwork, 0.5, { alpha: 1.0 } ).onComplete(showComplete.dispatch, [this]);
	}
	
	// key handling - rely on external controller to pass events to active screen
	public function handleKeyAction(event:KeyboardEvent):Void
	{		
		#if debug
			throw "No default key handler defined for screen on key press: " + event.keyCode;
		#end
	}
	
	public function lockKeys()
	{
		lockKeysFlag  = true;
	}
	
	public function unlockKeys()
	{
		lockKeysFlag = false;
	}
	
	// utility calculations
	public inline function get_horizontalCenter() {
		return WIDTH / 2;
	}
	
	public inline function get_verticalCenter() {
		return HEIGHT / 2;
	}
}