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
import net.mkv25.game.models.PlayerHand;
import net.mkv25.game.models.PlayerModel;
import net.mkv25.game.ui.DeploymentUI;
import net.mkv25.game.ui.InGameMenuUI;
import net.mkv25.game.ui.MapUI;
import net.mkv25.game.ui.MovementUI;
import net.mkv25.game.ui.PlayerHandUI;
import net.mkv25.game.ui.PortalsUI;
import net.mkv25.game.ui.StatusBarUI;
import net.mkv25.ld30.dbvos.WinningConditionsRow;
import net.mkv25.ld30.enums.WinningConditionsEnum;
import openfl.Assets;

class GameSetupScreen extends Screen
{
	var gameLengthText:TextUI;
	var gameModeText:TextUI;
	var winningConditionText:TextUI;
	
	var startButton:ButtonUI;
	
	public function new() 
	{
		super();
	}
	
	override private function setup():Void 
	{
		setBackground("img/setup-screen.png");
		
		gameLengthText = cast TextUI.makeFor("Game Mode".toUpperCase(), 0xFFFFFF).fontSize(28).size(Screen.WIDTH, 40).move(0, 260);
		gameModeText = cast TextUI.makeFor("Winning Condition".toUpperCase(), 0xFFFFFF).fontSize(28).size(Screen.WIDTH, 40).move(0, 390);
		winningConditionText = cast TextUI.makeFor("Detailed explanation\nof rules".toUpperCase(), 0x999999).fontSize(24).size(Screen.WIDTH, 70).move(0, 430);
		
		startButton = new ButtonUI();
		startButton.setup("START GAME", onStartAction);
		startButton.move(horizontalCenter, 600);
		
		artwork.addChild(gameLengthText.artwork);
		artwork.addChild(gameModeText.artwork);
		artwork.addChild(winningConditionText.artwork);
		artwork.addChild(startButton.artwork);
	}
	
	override public function show():Void 
	{
		super.show();
		
		var winningCondition = Index.dbvos.WINNING_CONDITIONS.getRowCast(WinningConditionsEnum.SHORT_GAME);
		
		gameModeText.setText(winningCondition.title.toUpperCase());
		winningConditionText.setText(winningCondition.fullDescription.toUpperCase());
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
	
	function onStartAction(?model:ButtonUI)
	{
		SoundEffects.playBloop();
		
		EventBus.startNewGame.dispatch(this);
	}
}