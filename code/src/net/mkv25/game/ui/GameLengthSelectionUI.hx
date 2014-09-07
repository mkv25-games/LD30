package net.mkv25.game.ui;

import net.mkv25.base.core.Screen;
import net.mkv25.base.ui.BaseUI;
import net.mkv25.base.ui.TextUI;
import net.mkv25.ld30.dbvos.WinningConditionsRow;

class GameLengthSelectionUI extends BaseUI
{
	var gameLengthText:TextUI;
	var gameModeText:TextUI;
	var winningConditionText:TextUI;

	public function new() 
	{
		super();
		
		gameLengthText = cast TextUI.makeFor("Game Mode".toUpperCase(), 0xFFFFFF).fontSize(28).size(Screen.WIDTH, 40).move(0, 10);
		gameModeText = cast TextUI.makeFor("Winning Condition".toUpperCase(), 0xFFFFFF).fontSize(28).size(Screen.WIDTH, 40).move(0, 140);
		winningConditionText = cast TextUI.makeFor("Detailed explanation\nof rules".toUpperCase(), 0x999999).fontSize(24).size(Screen.WIDTH, 70).move(0, 180);
		
		artwork.addChild(gameLengthText.artwork);
		artwork.addChild(gameModeText.artwork);
		artwork.addChild(winningConditionText.artwork);
	}
	
	public function update(winningCondition:WinningConditionsRow):Void
	{
		gameModeText.setText(winningCondition.title.toUpperCase());
		winningConditionText.setText(winningCondition.fullDescription.toUpperCase());
	}
	
}