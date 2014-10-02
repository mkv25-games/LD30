package net.mkv25.base.ui;

import motion.Actuate;
import net.mkv25.base.core.Text;
import openfl.Assets;
import flash.display.Bitmap;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.text.TextFormatAlign;
import openfl.events.Event;

class ButtonUI extends BaseUI 
{
	private static inline var DEFAULT_ASSET_PREFIX:String = "img/button/button_select";
	
	var bitmap:Bitmap;
	var textField:TextField;
	var assetPrefix:String;
	
	var waitingOnActivation:Bool;
	var action:Dynamic->Void;
	
	public function new() 
	{
		super();
		
		bitmap = new Bitmap();
		textField = Text.makeTextField("fonts/trebuc.ttf", 24, 0xFFFFFF, TextFormatAlign.CENTER);
		assetPrefix = DEFAULT_ASSET_PREFIX;
		
		waitingOnActivation = false;
		action = null;
		
		artwork.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
		artwork.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		artwork.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		artwork.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		
		artwork.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
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
		if (waitingOnActivation)
			return;
			
		if (action == null)
			return;
		
		waitingOnActivation = true;
		Actuate.timer(0.1).onComplete(onActivationComplete);
	}
	
	function onActivationComplete():Void
	{
		action(this);
		waitingOnActivation = false;
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
	
	function onAddedToStage(e)
	{
		upState();
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