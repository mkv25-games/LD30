package net.mkv25.game.ui;

import haxe.ds.IntMap;
import net.mkv25.base.core.Screen;
import net.mkv25.base.ui.BaseUI;
import net.mkv25.base.ui.TextUI;
import net.mkv25.base.ui.ToggleButtonUI;
import net.mkv25.game.event.EventBus;
import net.mkv25.game.provider.IconProvider;
import net.mkv25.ld30.dbvos.WinningConditionsRow;
import net.mkv25.ld30.enums.WinningConditionsEnum;
import openfl.display.Sprite;

class GameLengthSelectionUI extends BaseUI
{
	var gameLengthText:TextUI;
	var gameModeText:TextUI;
	var winningConditionText:TextUI;
	
	var options:Sprite;
	var optionMap:IntMap<ToggleButtonUI>;
	var optionShort:ToggleButtonUI;
	var optionMedium:ToggleButtonUI;
	var optionLong:ToggleButtonUI;

	
	public function new() 
	{
		super();
		
		IconProvider.setup();
		
		gameLengthText = cast TextUI.makeFor("Game Mode".toUpperCase(), 0xFFFFFF).fontSize(28).size(Screen.WIDTH, 40).move(0, 10);
		gameModeText = cast TextUI.makeFor("Winning Condition".toUpperCase(), 0xFFFFFF).fontSize(28).size(Screen.WIDTH, 40).move(0, 140);
		winningConditionText = cast TextUI.makeFor("Detailed explanation\nof rules".toUpperCase(), 0x999999).fontSize(24).size(Screen.WIDTH, 70).move(0, 180);
		
		options = new Sprite();
		options.x = Screen.WIDTH / 2;
		options.y = 95;
		
		optionMap = new IntMap<ToggleButtonUI>();
		
		optionShort = new ToggleButtonUI();
		optionShort.setIcon(IconProvider.ICON_SHORT_GAME).move( -100, 0);
		optionShort.selected.add(selectOptionShort);
		optionMap.set(WinningConditionsEnum.SHORT_GAME, optionShort);
		
		optionMedium = new ToggleButtonUI();
		optionMedium.setIcon(IconProvider.ICON_MEDIUM_GAME).move(0, 0);
		optionMedium.selected.add(selectOptionMedium);
		optionMap.set(WinningConditionsEnum.MEDIUM_GAME, optionMedium);
		
		optionLong = new ToggleButtonUI();
		optionLong.setIcon(IconProvider.ICON_LONG_GAME).move(100, 0);
		optionLong.selected.add(selectOptionLong);
		optionMap.set(WinningConditionsEnum.LONG_GAME, optionLong);
		
		options.addChild(optionShort.artwork);
		options.addChild(optionMedium.artwork);
		options.addChild(optionLong.artwork);
		
		artwork.addChild(gameLengthText.artwork);
		artwork.addChild(options);
		artwork.addChild(gameModeText.artwork);
		artwork.addChild(winningConditionText.artwork);
	}
	
	public function update(winningCondition:WinningConditionsRow):Void
	{
		gameModeText.setText(winningCondition.title.toUpperCase());
		winningConditionText.setText(winningCondition.fullDescription.toUpperCase());
		
		var option:ToggleButtonUI = optionMap.get(winningCondition.id);
		option.select();
		
		deselectAllOptionsExceptFor(option);
		
		EventBus.winningConditionChanged.dispatch(winningCondition);
	}
	
	function deselectAllOptionsExceptFor(selectedOption:ToggleButtonUI):Void
	{
		for (option in optionMap)
		{
			if (option == selectedOption)
			{
				continue;
			}
			option.deselect();
		}
	}
	
	function selectOptionShort(?model):Void
	{
		var row = Index.dbvos.WINNING_CONDITIONS.getRowCast(WinningConditionsEnum.SHORT_GAME);
		update(row);
	}
	
	function selectOptionMedium(?model):Void
	{
		var row = Index.dbvos.WINNING_CONDITIONS.getRowCast(WinningConditionsEnum.MEDIUM_GAME);
		update(row);
	}
	
	function selectOptionLong(?model):Void
	{
		var row = Index.dbvos.WINNING_CONDITIONS.getRowCast(WinningConditionsEnum.LONG_GAME);
		update(row);
	}
	
}