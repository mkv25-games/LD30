package net.mkv25.base.ui;

import flash.events.Event;
import flash.text.TextField;
import flash.text.TextFieldType;
import flash.text.TextFormatAlign;
import net.mkv25.base.core.Signal;
import net.mkv25.base.core.Text;

class TextUI extends BaseUI
{
	var text:TextField;
	
	public var textChanged:Signal;

	public function new() 
	{
		super();
	}
	
	public function setup(label:String, color:Int=0x136713)
	{
		if (text == null)
			text = Text.makeTextField("fonts/trebuc.ttf", 22, color, TextFormatAlign.CENTER, false);
		
		setText(label);
		artwork.addChild(text);
		
		return this;
	}
	
	public function getText():String
	{
		return text.text;
	}
	
	public function setText(label:String)
	{
		text.text = label;
	}
	
	public function align(alignment:Dynamic):TextUI
	{
		var format = text.defaultTextFormat;
		format.align = alignment;
		
		text.defaultTextFormat = format;
		text.setTextFormat(format);
		
		return this;
	}
	
	public function fontSize(size:Float):TextUI
	{
		var format = text.defaultTextFormat;
		format.size = size;
		
		text.defaultTextFormat = format;
		text.setTextFormat(format);
		
		return this;
	}
	
	public function leading(distance:Int):TextUI
	{
		var format = text.defaultTextFormat;
		format.leading = distance;
		
		text.defaultTextFormat = format;
		text.setTextFormat(format);
		
		return this;
	}
	
	public function makeTextInput():TextUI
	{
		text.type = TextFieldType.INPUT;
		text.selectable = true;
		
		artwork.mouseEnabled = true;
		artwork.mouseChildren = true;
		text.mouseEnabled = true;
		
		textChanged = new Signal();
		text.addEventListener(Event.CHANGE, textChanged.dispatch);
		
		return this;
	}
	
	public function maxChars(length:Int):TextUI
	{
		text.maxChars = length;
		
		return this;
	}
	
	override public function size(width:Float, height:Float):BaseUI 
	{
		text.width = width;
		text.height = height;
		
		return this;
	}
	
	public static function makeFor(label:String, color:Int=0x136713):TextUI
	{
		var text:TextUI = new TextUI();
		
		text.setup(label, color);
		
		return text;
	}
}