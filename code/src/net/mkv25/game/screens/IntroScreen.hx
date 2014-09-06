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
	var button:ButtonUI;
	
	public function new() 
	{
		super();
	}
	
	override private function setup():Void 
	{
		setBackground("img/title-screen.png");
		
		button = new ButtonUI();
		button.setup("NEW GAME", onBeginAction);
		button.move(horizontalCenter, verticalCenter + 100);
		
		artwork.addChild(button.artwork);
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
	
	function onBeginAction(?model:ButtonUI)
	{
		SoundEffects.playBloop();
		
		EventBus.startNewGame.dispatch(this);
	}
}