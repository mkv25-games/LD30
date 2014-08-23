package net.mkv25.base.ui;

import motion.Actuate;
import net.mkv25.base.core.Text;
import openfl.Assets;
import flash.display.Bitmap;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.text.TextFormatAlign;

class IconButtonUI extends BaseUI 
{
	private static inline var DEFAULT_ASSET_PREFIX:String = "img/button/button_plain";
	
	var buttonBitmap:Bitmap;
	var iconBitmap:Bitmap;
	var iconPath:String;
	
	var waitingOnActivation:Bool;
	var action:Dynamic->Void;
	var imagePrefix:String;
	
	public function new() 
	{
		super();
		
		buttonBitmap = new Bitmap();
		iconBitmap = new Bitmap();
		iconPath = null;
		imagePrefix = DEFAULT_ASSET_PREFIX;
		
		waitingOnActivation = false;
		action = null;
		
		artwork.addEventListener(MouseEvent.CLICK, onMouseClick);
		artwork.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
		artwork.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		artwork.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		artwork.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
	}
	
	public function setup(iconPath:String, action:Dynamic->Void, imagePrefix:String=DEFAULT_ASSET_PREFIX):Void
	{
		this.iconPath = iconPath;
		this.action = action;
		this.imagePrefix = imagePrefix;
		
		iconBitmap.bitmapData = Assets.getBitmapData(iconPath);
		center(iconBitmap);
		
		artwork.addChild(buttonBitmap);
		artwork.addChild(iconBitmap);
		
		upState();
	}
	
	function onMouseClick(e):Void
	{
		// activate();
	}
	
	function activate():Void {
		if (waitingOnActivation)
			return;
			
		if (action == null)
			return;
		
		waitingOnActivation = true;
		Actuate.timer(0.1).onComplete(onActivationComplete);
	}
	
	function onActivationComplete():Void {
		action(this);
		waitingOnActivation = false;
	}
	
	function upState()
	{
		buttonBitmap.bitmapData = Assets.getBitmapData(imagePrefix + "_up.png");
		center(buttonBitmap);
	}
	
	function overState()
	{
		buttonBitmap.bitmapData = Assets.getBitmapData(imagePrefix + "_over.png");
		center(buttonBitmap);
	}
	
	function downState()
	{
		buttonBitmap.bitmapData = Assets.getBitmapData(imagePrefix + "_down.png");
		center(buttonBitmap);
	}
	
	function onMouseOver(e)
	{
		overState();
	}
	
	function onMouseOut(e)
	{
		upState();
	}
	
	function onMouseDown(e)
	{
		downState();
		
		activate();
	}
	
	function onMouseUp(e)
	{
		overState();
	}
}