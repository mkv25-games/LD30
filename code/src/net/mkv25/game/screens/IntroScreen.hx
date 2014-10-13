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

class IntroScreen extends Screen
{
	var newGameButton:ButtonUI;
	var guideButton:ButtonUI;
	
	public function new() 
	{
		super();
	}
	
	override private function setup():Void 
	{
		setBackground("img/title-screen.png");
		
		newGameButton = new ButtonUI();
		newGameButton.setup("NEW GAME", onNewGameAction);
		newGameButton.move(horizontalCenter, verticalCenter + 100);
		
		guideButton = new ButtonUI();
		guideButton.setup("BEGINNERS GUIDE", onBeginnersGuideAction);
		guideButton.move(horizontalCenter, verticalCenter + 200);
		
		artwork.addChild(newGameButton.artwork);
		artwork.addChild(guideButton.artwork);
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
	
	function onNewGameAction(?model:ButtonUI)
	{
		SoundEffects.playBloop();
		
		Index.screenController.showScreen(Index.gameSetupScreen);
	}
	
	function onBeginnersGuideAction(?model:ButtonUI)
	{
		SoundEffects.playBloop();
		
		// Index.screenController.showScreen(Index.beginnersGuideScreen);
	}
}