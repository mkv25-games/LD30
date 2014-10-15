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
	
	var previousPageButton:IconButtonUI;
	var nextPageButton:IconButtonUI;
	var backToIndexButton:IconButtonUI;
	
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
		
		previousPageButton = new IconButtonUI();
		previousPageButton.setup("img/icon-back.png", navigateToPreviousPage);
		previousPageButton.move(40, Screen.HEIGHT - 40);
		
		nextPageButton = new IconButtonUI();
		nextPageButton.setup("img/icon-forward.png", navigateToNextPage);
		nextPageButton.move(Screen.WIDTH - 40, Screen.HEIGHT - 40);
		
		backToIndexButton = new IconButtonUI();
		backToIndexButton.setup("img/icon-exit-page.png", navigateBackToIndex);
		backToIndexButton.move(Screen.WIDTH * 0.5, Screen.HEIGHT - 40);
		
		artwork.addChild(previousPageButton.artwork);
		artwork.addChild(nextPageButton.artwork);
		artwork.addChild(backToIndexButton.artwork);
		
		showPage(0);
	}
	
	function showPage(page:Int):Void
	{
		var numPages = pageAssets.length;
		currentPageIndex = (numPages + page) % numPages;
		
		var assetPath = pageAssets[currentPageIndex];
		
		setBackground(assetPath);
		
		var lastPage = pageAssets.length - 1;
		(currentPageIndex == 0) ? previousPageButton.disable() : previousPageButton.enable();
		(currentPageIndex == lastPage) ? nextPageButton.disable() : nextPageButton.enable();
		
		(currentPageIndex == 0 || currentPageIndex == lastPage) ? backToIndexButton.show() : backToIndexButton.hide();
	}
	
	override public function handleKeyAction(event:KeyboardEvent):Void
	{
		if (lockKeysFlag)
		{
			return;
		}
		
		if (event.keyCode == Keyboard.LEFT)
		{
			navigateToPreviousPage();
		}
		else if (event.keyCode == Keyboard.RIGHT)
		{
			navigateToNextPage();
		}
		else if (event.keyCode == Keyboard.DOWN || event.keyCode == Keyboard.UP)
		{
			navigateBackToIndex();
		}
	}
	
	function navigateToPreviousPage(?model)
	{
		SoundEffects.playBloop();
		
		showPage(currentPageIndex - 1);
	}
	
	function navigateToNextPage(?model)
	{
		SoundEffects.playBloop();
		
		showPage(currentPageIndex + 1);
	}
	
	function navigateBackToIndex(?model)
	{
		SoundEffects.playBloop();
		
		Index.screenController.showLastScreen();
	}
}