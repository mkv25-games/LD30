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

class OptionsScreen extends Screen
{
	var continueGameButton:ButtonUI;
	var beginnersGuideButton:ButtonUI;
	
	var exitGameButton:ButtonUI;
	
	public function new() 
	{
		super();
	}
	
	override private function setup():Void 
	{
		setBackground("img/setup-screen.png");
		
		continueGameButton = new ButtonUI();
		continueGameButton.setup("CONTINUE", onContinueGameAction);
		continueGameButton.move(horizontalCenter, verticalCenter - 200);
		
		beginnersGuideButton = new ButtonUI();
		beginnersGuideButton.setup("BEGINNERS GUIDE", onBeginnersGuideAction);
		beginnersGuideButton.move(horizontalCenter, verticalCenter - 100);
		
		exitGameButton = new ButtonUI();
		exitGameButton.setup("EXIT GAME", onExitGameAction);
		exitGameButton.move(horizontalCenter, verticalCenter + 100);
		
		artwork.addChild(continueGameButton.artwork);
		artwork.addChild(beginnersGuideButton.artwork);
		artwork.addChild(exitGameButton.artwork);
	}
	
	override public function handleKeyAction(event:KeyboardEvent):Void
	{
		if (lockKeysFlag)
		{
			return;
		}
		
		if (event.keyCode == Keyboard.LEFT)
		{
			
		}
		else if (event.keyCode == Keyboard.RIGHT)
		{
			
		}
		else if (event.keyCode == Keyboard.DOWN)
		{
			
		}
	}
	
	function onContinueGameAction(?model:ButtonUI)
	{
		SoundEffects.playBloop();
		
		Index.screenController.showScreen(Index.mainScreen);
	}
	
	function onBeginnersGuideAction(?model:ButtonUI)
	{
		SoundEffects.playBloop();
		
		Index.screenController.showScreen(Index.guideScreen);
	}
	
	function onExitGameAction(?model:ButtonUI)
	{
		SoundEffects.playBloop();
		
		Index.screenController.showScreen(Index.introScreen);
	}
}