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
import net.mkv25.game.models.PlayerHand;
import net.mkv25.game.ui.MapUI;
import net.mkv25.game.ui.PlayerHandUI;
import net.mkv25.game.ui.StatusBarUI;
import openfl.Assets;

class MainScreen extends Screen
{
	var button:ButtonUI;
	var map:MapUI;
	var statusBar:StatusBarUI;
	var playerHand:PlayerHandUI;
	var adviceText:TextUI;
	
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
		
		statusBar = new StatusBarUI();
		playerHand = new PlayerHandUI();
		playerHand.move(0, 550);
		playerHand.display(new PlayerHand());
		
		adviceText = cast TextUI.makeFor("Welcome to the game", 0x000000).fontSize(28).size(Screen.WIDTH, 40).move(0, Screen.HEIGHT - 45);
		
		artwork.addChild(map.artwork);
		artwork.addChild(button.artwork);
		artwork.addChild(statusBar.artwork);
		artwork.addChild(playerHand.artwork);
		artwork.addChild(adviceText.artwork);
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