package net.mkv25.game.screens;

import flash.events.KeyboardEvent;
import flash.ui.Keyboard;
import net.mkv25.base.core.Screen;
import net.mkv25.base.core.Text;
import net.mkv25.base.ui.BubbleCircleUI;
import net.mkv25.base.ui.ButtonUI;
import net.mkv25.base.ui.IconButtonUI;
import net.mkv25.base.ui.TextUI;
import net.mkv25.game.event.EventBus;
import net.mkv25.game.ui.MapUI;
import openfl.Assets;

class MainScreen extends Screen
{
	var button:ButtonUI;
	var map:MapUI;
	
	public function new() 
	{
		super();
	}
	
	override private function setup():Void 
	{
		setBackground("img/main-layout-player6.png");
		
		button = new ButtonUI();
		button.setup("BACK", onBackAction);
		button.move(horizontalCenter, verticalCenter);
		
		map = new MapUI();
		map.move(0, 50);
		map.setup(Index.gameMap);
		Index.gameMap.changed.dispatch(Index.gameMap);
		
		artwork.addChild(map.artwork);
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
	
	function onBackAction(?model:ButtonUI)
	{
		var bloopSfx = Assets.getSound("sounds/bloop.wav");
		bloopSfx.play();
		
		EventBus.restartGame.dispatch(this);
	}
}