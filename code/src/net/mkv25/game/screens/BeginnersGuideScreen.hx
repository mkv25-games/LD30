package net.mkv25.game.screens;

import flash.events.KeyboardEvent;
import flash.ui.Keyboard;
import net.mkv25.base.core.Screen;
import net.mkv25.base.core.Text;
import net.mkv25.base.ui.BubbleCircleUI;
import net.mkv25.base.ui.ButtonUI;
import net.mkv25.base.ui.IconButtonUI;
import net.mkv25.base.ui.TextUI;
import net.mkv25.game.audio.SoundEffects;
import net.mkv25.game.event.EventBus;
import openfl.Assets;

class BeginnersGuideScreen extends Screen
{
	private var pageAssets:Array<String>;
	private var currentPageIndex:Int;
	
	public function new() 
	{
		super();
	}
	
	override private function setup():Void 
	{
		this.pageAssets = [
			"img/guide/guide-p1.png",
			"img/guide/guide-p2.png",
			"img/guide/guide-p3.png",
			"img/guide/guide-p4.png",
			"img/guide/guide-p5.png",
			"img/guide/guide-p6.png"
		];
		
		showPage(0);
	}
	
	function showPage(page:Int):Void
	{
		var numPages = pageAssets.length;
		currentPageIndex = (numPages + page) % numPages;
		
		var assetPath = pageAssets[currentPageIndex];
		
		setBackground(assetPath);
	}
	
	override public function handleKeyAction(event:KeyboardEvent):Void
	{
		if (lockKeysFlag)
		{
			return;
		}
		
		if (event.keyCode == Keyboard.LEFT)
		{
			showPage(currentPageIndex - 1);
		}
		else if (event.keyCode == Keyboard.RIGHT)
		{
			showPage(currentPageIndex + 1);
		}
		else if (event.keyCode == Keyboard.DOWN || event.keyCode == Keyboard.UP)
		{
			Index.screenController.showScreen(Index.introScreen);
		}
	}
}