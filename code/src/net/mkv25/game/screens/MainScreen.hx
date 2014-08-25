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
import net.mkv25.game.models.PlayerModel;
import net.mkv25.game.ui.InGameMenuUI;
import net.mkv25.game.ui.MapUI;
import net.mkv25.game.ui.PlayerHandUI;
import net.mkv25.game.ui.StatusBarUI;
import openfl.Assets;

class MainScreen extends Screen
{
	var button:IconButtonUI;
	
	var map:MapUI;
	var statusBar:StatusBarUI;
	var playerHand:PlayerHandUI;
	var adviceText:TextUI;
	
	public static var LAYOUTS:Array<String> = [
		"img/main-layout-player1.png",
		"img/main-layout-player2.png",
		"img/main-layout-player3.png",
		"img/main-layout-player4.png",
		"img/main-layout-player5.png",
		"img/main-layout-player6.png"
	];
	
	public function new() 
	{
		super();
	}
	
	override private function setup():Void 
	{
		setBackground("img/main-layout-player6.png");
		
		button = new IconButtonUI();
		button.setup("img/icon-back.png", returnToSpaceMap);
		button.move(60, 80);
		
		map = new MapUI();
		map.move(0, 50);
		map.setupMap(Index.activeGame.space);
		
		statusBar = new StatusBarUI();
		playerHand = new PlayerHandUI();
		playerHand.move(0, 550);
		
		adviceText = cast TextUI.makeFor("Welcome to the game", 0x000000).fontSize(28).size(Screen.WIDTH, 40).move(0, Screen.HEIGHT - 45);
		
		artwork.addChild(map.artwork);
		artwork.addChild(button.artwork);
		artwork.addChild(statusBar.artwork);
		artwork.addChild(playerHand.artwork);
		artwork.addChild(adviceText.artwork);
		
		EventBus.activePlayerChanged.add(handleActivePlayerChange);
		EventBus.displayNewStatusMessage.add(handleDisplayNewStatus);
		EventBus.mapViewChanged.add(onMapViewChanged);
	}
	
	function handleActivePlayerChange(activePlayer:PlayerModel)
	{
		setBackgroundToMatchPlayer(Index.activeGame.activePlayer);
		playerHand.display(Index.activeGame.activePlayer.playerHand);
	}
	
	function setBackgroundToMatchPlayer(player:PlayerModel)
	{
		var layoutAsset = MainScreen.LAYOUTS[player.playerNumberZeroBased];
		setBackground(layoutAsset);
	}
	
	function handleDisplayNewStatus(message:String)
	{
		adviceText.setText(message);
	}
	
	override public function show():Void 
	{
		super.show();
		
		Index.activeGame.space.changed.dispatch(Index.activeGame.space);
		
		if (Index.activeGame.activePlayer != null) 
		{
			setBackgroundToMatchPlayer(Index.activeGame.activePlayer);
			playerHand.display(Index.activeGame.activePlayer.playerHand);
		}
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
	
	function onMapViewChanged(?model)
	{
		if (map.currentModel != Index.activeGame.space)
		{
			button.show();
		}
		else
		{
			button.hide();
		}
	}
	
	function returnToSpaceMap(?model)
	{
		var bloopSfx = Assets.getSound("sounds/bloop.wav");
		bloopSfx.play();
		
		map.setupMap(Index.activeGame.space);
	}
}