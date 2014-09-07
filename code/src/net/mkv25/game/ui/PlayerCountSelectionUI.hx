package net.mkv25.game.ui;

import flash.display.BitmapData;
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

class PlayerCountSelectionUI extends BaseUI
{
	var numberOfPlayersText:TextUI;
	
	var options:Sprite;
	var optionMap:IntMap<ToggleButtonUI>;
	var option1Player:ToggleButtonUI;
	var option2Player:ToggleButtonUI;
	var option3Player:ToggleButtonUI;
	var option4Player:ToggleButtonUI;
	var option5Player:ToggleButtonUI;
	var option6Player:ToggleButtonUI;
	
	public function new() 
	{
		super();
		
		IconProvider.setup();
		
		numberOfPlayersText = cast TextUI.makeFor("Number of players".toUpperCase(), 0xFFFFFF).fontSize(28).size(Screen.WIDTH, 40).move(0, 20);
		
		options = new Sprite();
		options.x = Screen.WIDTH / 2;
		options.y = 150;
		
		optionMap = new IntMap<ToggleButtonUI>();
		
		option1Player = cast createPlayerOption(1, IconProvider.ICON_1_PLAYER, selectOption1Player).move( -100, -50);
		option2Player = cast createPlayerOption(2, IconProvider.ICON_2_PLAYER, selectOption2Player).move( 0, -50);
		option3Player = cast createPlayerOption(3, IconProvider.ICON_3_PLAYER, selectOption3Player).move( 100, -50);
		option4Player = cast createPlayerOption(4, IconProvider.ICON_4_PLAYER, selectOption4Player).move( -100, 50);
		option5Player = cast createPlayerOption(5, IconProvider.ICON_5_PLAYER, selectOption5Player).move( 0, 50);
		option6Player = cast createPlayerOption(6, IconProvider.ICON_6_PLAYER, selectOption6Player).move( 100, 50);
		
		// No single player support yet
		option1Player.disable();
		
		artwork.addChild(numberOfPlayersText.artwork);
		artwork.addChild(options);
	}
	
	function createPlayerOption(numberOfPlayers:Int, icon:BitmapData, action:Dynamic->Void):ToggleButtonUI
	{
		var option = new ToggleButtonUI();
		
		option.setIcon(icon);
		option.selected.add(action);
		optionMap.set(numberOfPlayers, option);
		options.addChild(option.artwork);
		
		return option;
	}
	
	public function update(numberOfPlayers:Int):Void
	{
		numberOfPlayersText.setText((numberOfPlayers + " player mode").toUpperCase());
		
		var option:ToggleButtonUI = optionMap.get(numberOfPlayers);
		option.select();
		
		deselectAllOptionsExceptFor(option);
		
		EventBus.playerCountChanged.dispatch(numberOfPlayers);
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
	
	function selectOption1Player(?model):Void
	{
		update(1);
	}
	
	function selectOption2Player(?model):Void
	{
		update(2);
	}
	
	function selectOption3Player(?model):Void
	{
		update(3);
	}
	
	function selectOption4Player(?model):Void
	{
		update(4);
	}
	
	function selectOption5Player(?model):Void
	{
		update(5);
	}
	
	function selectOption6Player(?model):Void
	{
		update(6);
	}
}