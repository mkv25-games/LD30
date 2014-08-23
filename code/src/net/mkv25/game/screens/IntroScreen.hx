package net.mkv25.game.screens;

import flash.events.KeyboardEvent;
import flash.ui.Keyboard;
import net.mkv25.base.core.Screen;
import net.mkv25.base.core.Text;
import net.mkv25.base.ui.BubbleCircleUI;
import net.mkv25.base.ui.ButtonUI;
import net.mkv25.base.ui.IconButtonUI;
import net.mkv25.base.ui.TextUI;
import openfl.Assets;

class IntroScreen extends Screen
{
	var button:ButtonUI;
	var bubble:BubbleCircleUI;
	var text:TextUI;
	var icon:IconButtonUI;
	
	public function new() 
	{
		super();
	}
	
	override private function setup():Void 
	{
		setBackground("img/intro_screen.png");
		
		button = new ButtonUI();
		button.setup("Begin", onBeginAction);
		button.move(horizontalCenter, verticalCenter - 100);
		
		bubble = new BubbleCircleUI();
		bubble.draw(50, 0xFF9933);
		bubble.move(horizontalCenter, verticalCenter + 100);
		
		text = new TextUI();
		text.setup("Keys: LEFT, RIGHT, DOWN", 0xFF9933).size(300, 50).center(text.artwork, cast horizontalCenter, 70);
		text.setText(Text.formatInThousands(1234567890));
		
		icon = new IconButtonUI();
		icon.setup("img/example_icon.png", onIconAction);
		bubble.artwork.addChild(icon.artwork);		
		
		artwork.addChild(button.artwork);
		artwork.addChild(bubble.artwork);
		artwork.addChild(text.artwork);
	}
	
	override public function handleKeyAction(event:KeyboardEvent):Void
	{
		if (lockKeysFlag)
		{
			return;
		}
		
		if (event.keyCode == Keyboard.LEFT)
		{
			lockKeys();
			bubble.animateMove(horizontalCenter - 170, verticalCenter).onComplete(unlockKeys);
			playPopSfx();
		}
		else if (event.keyCode == Keyboard.RIGHT)
		{
			lockKeys();
			bubble.animateMove(horizontalCenter + 170, verticalCenter).onComplete(unlockKeys);
			playPopSfx();
		}
		else if (event.keyCode == Keyboard.DOWN)
		{
			lockKeys();
			bubble.animateMove(horizontalCenter, verticalCenter + 100).onComplete(unlockKeys);
			playPopSfx();
		}
	}
	
	function playPopSfx()
	{
		var popSfx = Assets.getSound("sounds/pop.wav");
		popSfx.play();
	}
	
	function onBeginAction(?model:ButtonUI)
	{
		bubble.popIn();
		
		var bloopSfx = Assets.getSound("sounds/bloop.wav");
		bloopSfx.play();
	}
	
	function onIconAction(?model:IconButtonUI)
	{
		icon.popIn();
		
		var levelSfx = Assets.getSound("sounds/level.wav");
		levelSfx.play();
	}
}