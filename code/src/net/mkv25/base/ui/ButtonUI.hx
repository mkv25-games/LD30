package net.mkv25.base.ui;

import motion.Actuate;
import net.mkv25.base.core.Text;
import openfl.Assets;
import flash.display.Bitmap;
import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFormatAlign;

class ButtonUI extends BaseUI
{
	private static inline var DEFAULT_ASSET_PREFIX:String = "img/button/button_select";
	
	var action:ButtonUI->Void;
	
	var bitmap:Bitmap;
	var textField:TextField;
	var assetPrefix:String;
	
	var logic:ButtonLogic;
	
	public function new() 
	{
		super();
		
		action = null;
		
		bitmap = new Bitmap();
		textField = Text.makeTextField("fonts/trebuc.ttf", 24, 0xFFFFFF, TextFormatAlign.CENTER);
		assetPrefix = DEFAULT_ASSET_PREFIX;
		
		logic = new ButtonLogic(artwork);
		logic.upState = upState;
		logic.overState = overState;
		logic.downState = downState;
		logic.activate = activate;
	}
	
	public function setup(label:String, action:Dynamic->Void, assetPrefix:String=DEFAULT_ASSET_PREFIX):Void
	{
		this.action = action;
		this.assetPrefix = assetPrefix;
		
		artwork.addChild(bitmap);
		artwork.addChild(textField);
		
		textField.text = label;
		
		upState();
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
	
	function updateLabelSize()
	{
		textField.height = textField.textHeight + 5;
		if (bitmap == null)
		{
			textField.width = 100;
		}
		else
		{
			textField.width = bitmap.width;
		}
		center(textField);
	}
	
	function activate():Void
	{
		if (action == null)
		{
			return;
		}
		
		#if mobile
			openfl.feedback.Haptic.vibrate(100, 250);
		#end
		
		action(this);
	}
	
	function upState()
	{
		#if mobile
		
		overState();
		return;
		
		#else
		
		bitmap.bitmapData = Assets.getBitmapData(assetPrefix + "_up.png");
		center(bitmap);
		updateLabelSize();
		
		#end
	}
	
	function overState()
	{
		bitmap.bitmapData = Assets.getBitmapData(assetPrefix + "_over.png");
		center(bitmap);
		updateLabelSize();
	}
	
	function downState()
	{
		bitmap.bitmapData = Assets.getBitmapData(assetPrefix + "_down.png");
		center(bitmap);
		updateLabelSize();
	}
}