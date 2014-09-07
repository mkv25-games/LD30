package net.mkv25.base.ui;

import flash.display.BitmapData;
import motion.Actuate;
import net.mkv25.base.core.Signal;
import net.mkv25.base.core.Text;
import openfl.Assets;
import flash.display.Bitmap;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.text.TextFormatAlign;

class ToggleButtonUI extends BaseUI 
{
	private static inline var DEFAULT_ASSET_PREFIX:String = "img/button/button_toggle";
	
	public var selected:Signal;
	
	var flagSelected:Bool;
	
	var buttonBitmap:Bitmap;
	var iconBitmap:Bitmap;
	var iconPath:String;
	
	var waitingOnActivation:Bool;
	var action:Dynamic->Void;
	var imagePrefix:String;
	
	public function new() 
	{
		super();
		
		selected = new Signal();
		
		flagSelected = false;
		
		buttonBitmap = new Bitmap();
		iconBitmap = new Bitmap();
		iconPath = null;
		imagePrefix = DEFAULT_ASSET_PREFIX;
		
		waitingOnActivation = false;
		action = null;
		
		artwork.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
		artwork.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		artwork.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		artwork.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		
		artwork.addChild(buttonBitmap);
		artwork.addChild(iconBitmap);
	}
	
	public function setup(iconPath:String):ToggleButtonUI
	{
		iconBitmap.bitmapData = Assets.getBitmapData(iconPath);
		center(iconBitmap);
		
		upState();
		
		return this;
	}
	
	public function setIcon(bitmapData:BitmapData):ToggleButtonUI
	{
		iconBitmap.bitmapData = bitmapData;
		center(iconBitmap);
		
		upState();
		
		return this;
	}
	
	public function select():Void
	{
		this.flagSelected = true;
		overState();
	}
	
	public function deselect():Void
	{
		this.flagSelected = false;
		upState();
	}
	
	public function isSelected():Bool
	{
		return flagSelected;
	}
	
	function selectedState():Void
	{
		buttonBitmap.bitmapData = Assets.getBitmapData(imagePrefix + "_selected.png");
		center(buttonBitmap);
	}
	
	function upState()
	{
		if (flagSelected) {
			selectedState();
			return;
		}
		
		buttonBitmap.bitmapData = Assets.getBitmapData(imagePrefix + "_up.png");
		center(buttonBitmap);
	}
	
	function overState()
	{
		if (flagSelected) {
			selectedState();
			return;
		}
		
		buttonBitmap.bitmapData = Assets.getBitmapData(imagePrefix + "_over.png");
		center(buttonBitmap);
	}
	
	function downState()
	{
		if (flagSelected) {
			selectedState();
			return;
		}
		
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
		this.selected.dispatch(this);
	}
	
	function onMouseUp(e)
	{
		overState();
	}
}