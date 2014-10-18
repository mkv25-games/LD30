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
	
	var imagePrefix:String;
	
	var buttonBitmap:Bitmap;
	var iconBitmap:Bitmap;
	var iconPath:String;
	
	var action:Dynamic->Void;
	var logic:ButtonLogic;
	
	public function new() 
	{
		super();
		
		imagePrefix = DEFAULT_ASSET_PREFIX;
		
		buttonBitmap = new Bitmap();
		iconBitmap = new Bitmap();
		iconPath = null;
		
		action = null;
		logic = new ButtonLogic(artwork);
		logic.upState = upState;
		logic.overState = overState;
		logic.downState = downState;
		logic.activate = activate;
	}
	
	override public function enable() 
	{
		super.enable();
		
		artwork.alpha = 1.0;
	}
	
	override public function disable() 
	{
		super.disable();
		
		artwork.alpha = 0.4;
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
	
	function activate():Void
	{
		if (action == null)
		{
			return;
		}
		action(this);
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
}