package net.mkv25.base.core;

import openfl.Assets;
import flash.text.TextField;

class Text 
{
	public static function makeTextField(fontId:String, size:Int, color:Int, align:Dynamic, bold:Bool=false):TextField
	{
		var tf:TextField = new TextField();
		
		var format = tf.defaultTextFormat;
		var font = Assets.getFont(fontId);
		format.font = font.fontName;
		format.size = size;
		format.color = color;
		format.align = align;
		format.bold = bold;
		
		var text = tf;
		text.defaultTextFormat = format;
		text.setTextFormat(format);
		text.embedFonts = true;
		text.mouseEnabled = false;
		text.selectable = false;
		text.wordWrap = true;
		
		return tf;
	}
	
	public static function formatInThousands(number:Float):String
	{
		return numberFormat(number, 0, false, false);
	}
	
	public static function numberFormat(number:Float, maxDecimals:Int=2, forceDecimals:Bool=false, siStyle:Bool=true):String
	{
		var i:Int = 0;
		var inc:Float = Math.pow(10, maxDecimals);
		var str:String = Std.string(Math.round(inc * number) / inc);
		var hasSep:Bool = str.indexOf(".") == -1, sep:Int = hasSep ? str.length : str.indexOf(".");
		var ret:String = (hasSep && !forceDecimals ? "" : (siStyle ? "," : ".")) + str.substr(sep+1);
		if (forceDecimals) {
			var limit = maxDecimals - (str.length - (hasSep ? sep - 1 : sep)) + 1;
			for (j  in 0...limit)
				ret += "0";
		}
		while (i + 3 < (str.substr(0, 1) == "-" ? sep - 1 : sep))
			ret = (siStyle ? "." : ",") + str.substr(sep - (i += 3), 3) + ret;
		return str.substr(0, sep - i) + ret;
	}
}