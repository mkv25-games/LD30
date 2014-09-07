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
import net.mkv25.game.ui.GameLengthSelectionUI;
import net.mkv25.game.ui.InGameMenuUI;
import net.mkv25.game.ui.MapUI;
import net.mkv25.game.ui.MovementUI;
import net.mkv25.game.ui.PlayerCountSelectionUI;
import net.mkv25.game.ui.PlayerHandUI;
import net.mkv25.game.ui.PortalsUI;
import net.mkv25.game.ui.StatusBarUI;
import net.mkv25.ld30.dbvos.WinningConditionsRow;
import net.mkv25.ld30.enums.WinningConditionsEnum;
import openfl.Assets;

class GameSetupScreen extends Screen
{
	var playerCountSelection:PlayerCountSelectionUI;
	var gameLengthSelection:GameLengthSelectionUI;
	var startButton:ButtonUI;
	
	public function new() 
	{
		super();
	}
	
	override private function setup():Void 
	{
		setBackground("img/setup-screen.png");
		
		playerCountSelection = new PlayerCountSelectionUI();
		playerCountSelection.move(0, 0);
		
		gameLengthSelection = new GameLengthSelectionUI();
		gameLengthSelection.move(0, 255);
		
		startButton = new ButtonUI();
		startButton.setup("START GAME", onStartAction);
		startButton.move(horizontalCenter, 600);
		
		artwork.addChild(playerCountSelection.artwork);
		artwork.addChild(gameLengthSelection.artwork);
		artwork.addChild(startButton.artwork);
	}
	
	override public function show():Void 
	{
		super.show();
		
		var defaultNumberOfPlayers:Int = 2;
		playerCountSelection.update(defaultNumberOfPlayers);
		
		var defaultWinningCondition = Index.dbvos.WINNING_CONDITIONS.getRowCast(WinningConditionsEnum.SHORT_GAME);
		gameLengthSelection.update(defaultWinningCondition);
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