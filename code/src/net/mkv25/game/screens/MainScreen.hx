package net.mkv25.game.screens;

import flash.events.KeyboardEvent;
import flash.ui.Keyboard;
import motion.Actuate;
import net.mkv25.base.core.Screen;
import net.mkv25.base.core.Text;
import net.mkv25.base.ui.BubbleCircleUI;
import net.mkv25.base.ui.ButtonUI;
import net.mkv25.base.ui.IconButtonUI;
import net.mkv25.base.ui.TextUI;
import net.mkv25.game.event.EventBus;
import net.mkv25.game.models.PlayerHand;
import net.mkv25.game.models.PlayerModel;
import net.mkv25.game.ui.DeploymentUI;
import net.mkv25.game.ui.InGameMenuUI;
import net.mkv25.game.ui.MapUI;
import net.mkv25.game.ui.MovementUI;
import net.mkv25.game.ui.PlayerHandUI;
import net.mkv25.game.ui.PortalsUI;
import net.mkv25.game.ui.ResourceHarvestingUI;
import net.mkv25.game.ui.StatusBarUI;
import net.mkv25.game.ui.UnitSelectionUI;
import openfl.Assets;

class MainScreen extends Screen
{
	var map:MapUI;
	var deployment:DeploymentUI;
	var movement:MovementUI;
	var portals:PortalsUI;
	var unitSelection:UnitSelectionUI;
	
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
		
		map = Index.mapHud;
		map.move(0, 50);
		
		deployment = Index.deploymentHud;
		deployment.move(0, 50);
		deployment.hide();
		
		movement = Index.movementHud;
		movement.move(0, 50);
		movement.hide();
		
		portals = Index.portalsHud;
		portals.move(0, 50);
		portals.hide();
		
		unitSelection = new UnitSelectionUI();
		unitSelection.move(62, 452);
		unitSelection.hide();
		
		statusBar = new StatusBarUI();
		playerHand = new PlayerHandUI();
		playerHand.move(0, 550);
		
		adviceText = cast TextUI.makeFor("Welcome to the game", 0xFFFFFF).fontSize(24).size(Screen.WIDTH, 40).move(0, 480);
		adviceText.artwork.mouseEnabled = adviceText.artwork.mouseChildren = false; 
		
		artwork.addChild(map.artwork);
		artwork.addChild(unitSelection.artwork);
		artwork.addChild(deployment.artwork);
		artwork.addChild(movement.artwork);
		artwork.addChild(portals.artwork);
		artwork.addChild(statusBar.artwork);
		artwork.addChild(playerHand.artwork);
		artwork.addChild(adviceText.artwork);
		
		EventBus.activePlayerChanged.add(onActivePlayerChange);
		EventBus.displayNewStatusMessage.add(handleDisplayNewStatus);
	}
	
	function onActivePlayerChange(activePlayer:PlayerModel)
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
		message = (message == null) ? "" : message;
		
		adviceText.setText(message.toUpperCase());
		
		var target = adviceText.artwork;
		
		Actuate.stop(target);
		Actuate.apply(target, { alpha: 0.0, y: 500 } );
		
		target.visible = true;
		Actuate.tween(target, 0.6, { alpha: 1.0, y: 480 } ).onComplete(
			function(target)
			{
				Actuate.tween(target, 1.0, { alpha: 0 } ).delay(3.0);
			}, [target]
		);
	}
	
	override public function show():Void 
	{
		super.show();
		
		Index.activeGame.space.changed.dispatch(Index.activeGame.space);
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
}