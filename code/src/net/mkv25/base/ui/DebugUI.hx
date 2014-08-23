package net.mkv25.base.ui;

import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.Lib;
import flash.text.TextField;
import flash.text.TextFormatAlign;
import flash.ui.Keyboard;
import net.mkv25.base.core.ScreenController;
import net.mkv25.base.core.Text;
import net.mkv25.base.core.VersionMacro;

class DebugUI extends BaseUI
{
	var topLeftText:TextField;
	var screenController:ScreenController;
	
	var lastTimer:Int;
	var frame:Int;
	var lastKey:String;
	
	public function new(screenController:ScreenController) 
	{
		super();
		
		this.screenController = screenController;
		
		lastTimer = 0;
		frame = 0;
		lastKey = "";
		
		artwork.mouseEnabled = false;
		artwork.mouseChildren = false;
		
		topLeftText = Text.makeTextField("fonts/lucon.ttf", 14, 0xFFFFFF, TextFormatAlign.LEFT);
		topLeftText.width = 300;
		topLeftText.height = 200;
		
		artwork.addChild(topLeftText);
		artwork.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		
		screenController.addLayer(artwork);
	}
	
	function onEnterFrame(e)
	{
		if (artwork.stage == null)
			return;
			
		var stage = artwork.stage;
		
		if (lastKey.length == 0)
		{
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			lastKey = "KEY WAIT";
		}
		
		if (frame < stage.frameRate)
		{
			frame++;
			return;
		}
		else
		{
			frame = 1;
		}
		
		var NL = "\n";	
		
		var time = Lib.getTimer();
		var diff = stage.frameRate / (time - lastTimer) * 1000;
		lastTimer = time;
		
		var output:String = "";
		output += "SIZE  " + stage.stageWidth + "x" + stage.stageHeight + NL;
		output += "SCALE " + Math.round(screenController.scale * 100) / 100 + NL;
		output += "FPS   " + Math.round(diff * 10) / 10 + " / " + stage.frameRate + NL;
		output += "VERSION " + VersionMacro.getGameVersion("application.xml") + NL;
		output += "MOUSE " + stage.mouseX + ", " + stage.mouseY + NL;
		output += lastKey + NL;
		
		topLeftText.text = output;
		screenController.addLayer(artwork);
	}
	
	function onKeyUp(e:KeyboardEvent)
	{
		lastKey = "LAST KEY: (" + e.keyCode + ", " + e.charCode + ")";
	}
}