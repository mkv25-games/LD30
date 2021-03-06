package net.mkv25.game.ui;

import flash.text.TextFormatAlign;
import net.mkv25.base.core.Screen;
import net.mkv25.base.ui.BaseUI;
import net.mkv25.base.ui.BitmapUI;
import net.mkv25.base.ui.TextUI;
import net.mkv25.game.event.EventBus;
import net.mkv25.game.models.PlayerModel;
import net.mkv25.game.models.ResourceTransactionModel;
import net.mkv25.game.provider.IconProvider;

class StatusBarUI extends BaseUI
{
	var playerNameText:TextUI;
	
	var counterUnitsText:TextUI;
	var counterTerritoryText:TextUI;
	var counterResourcesText:TextUI;
	
	var iconUnits:BitmapUI;
	var iconTerritory:BitmapUI;
	var iconResources:BitmapUI;

	var resourceHarvester:ResourceHarvestingUI;
	var resourceSpender:ResourceSpendingUI;
	var currentTransaction:ResourceTransactionModel;
	
	public function new() 
	{
		super();
		
		init();
	
		EventBus.activePlayerUpdated.add(onActivePlayerChanged);
		EventBus.activePlayerChanged.add(onActivePlayerChanged);
		
		EventBus.playerResourcesAdded.add(onResourcesAdded);
		EventBus.playerResourcesRemoved.add(onResourcesRemoved);
		
		Index.resourceCounterHud = iconResources;
	}
	
	private function init():Void
	{
		IconProvider.setup();
		
		playerNameText = cast TextUI.makeFor("Setup phase", 0x000000).fontSize(28).align(TextFormatAlign.LEFT).size(300, 40).move(10, 5);
		
		var rhs = Screen.WIDTH - 90;
		var spacing = 70;
		counterUnitsText = cast TextUI.makeFor("0", 0x000000).fontSize(28).align(TextFormatAlign.LEFT).size(50, 40).move(rhs - (spacing * 0), 7);
		counterTerritoryText = cast TextUI.makeFor("0", 0x000000).fontSize(28).align(TextFormatAlign.LEFT).size(50, 40).move(rhs - (spacing * 1), 7);
		counterResourcesText = cast TextUI.makeFor("0", 0x000000).fontSize(28).align(TextFormatAlign.LEFT).size(50, 40).move(rhs - (spacing * 2), 7);
		
		iconUnits = cast BitmapUI.makeFor(IconProvider.ICON_STATUS_UNITS).move(rhs - 20 - (spacing * 0), 25); 
		iconTerritory = cast BitmapUI.makeFor(IconProvider.ICON_STATUS_TERRITORY).move(rhs - 20 - (spacing * 1), 25); 
		iconResources = cast BitmapUI.makeFor(IconProvider.ICON_STATUS_RESOURCES).move(rhs - 20 - (spacing * 2), 25); 
		
		resourceHarvester = new ResourceHarvestingUI();
		resourceSpender = new ResourceSpendingUI();
		
		Index.tooltipHud.registerTooltip(iconUnits.artwork, "Number of units"); 
		Index.tooltipHud.registerTooltip(iconTerritory.artwork, "Controlled territory"); 
		Index.tooltipHud.registerTooltip(iconResources.artwork, "Available resources"); 
		
		artwork.addChild(playerNameText.artwork);
		artwork.addChild(counterUnitsText.artwork);
		artwork.addChild(counterTerritoryText.artwork);
		artwork.addChild(counterResourcesText.artwork);
		artwork.addChild(iconUnits.artwork);
		artwork.addChild(iconTerritory.artwork);
		artwork.addChild(iconResources.artwork);
		artwork.addChild(resourceHarvester.artwork);
		artwork.addChild(resourceSpender.artwork);
		
		resourceHarvester.cashedInCounter.add(onCounterCashedIn);
		resourceSpender.cashedOutCounter.add(onCounterCashedOut);
	}
	
	function onCounterCashedIn(transaction:ResourceTransactionModel):Void
	{
		if (currentTransaction == transaction)
		{
			currentTransaction.resourceChange--;
			var displayAmount = currentTransaction.playerResources - currentTransaction.resourceChange;
			counterResourcesText.setText(Std.string(displayAmount));
		}
	}
	
	function onCounterCashedOut(transaction:ResourceTransactionModel):Void
	{
		if (currentTransaction == transaction)
		{
			currentTransaction.resourceChange++;
			var displayAmount = currentTransaction.playerResources - currentTransaction.resourceChange;
			counterResourcesText.setText(Std.string(displayAmount));
		}
	}
	
	function onActivePlayerChanged(player:PlayerModel):Void
	{
		playerNameText.setText("Player " + (player.playerNumberZeroBased + 1) + "'s Turn");
		
		counterResourcesText.setText(Std.string(player.resources));
		counterTerritoryText.setText(Std.string(player.territory));
		counterUnitsText.setText(Std.string(player.unitCount() + player.baseCount()));
	}
	
	function onResourcesRemoved(transaction:ResourceTransactionModel):Void
	{
		this.currentTransaction = transaction;
		
		var displayAmount = transaction.playerResources - transaction.resourceChange;
		counterResourcesText.setText(Std.string(displayAmount));
		
		resourceSpender.spendResources(transaction);
	}
	
	function onResourcesAdded(transaction:ResourceTransactionModel):Void
	{
		this.currentTransaction = transaction;
		
		var displayAmount = transaction.playerResources - transaction.resourceChange;
		counterResourcesText.setText(Std.string(displayAmount));
		
		resourceHarvester.collectResources(transaction);
	}
	
	function onTerritoryChanged(player:PlayerModel):Void
	{
		counterTerritoryText.setText(Std.string(player.territory));
	}
	
	function onUnitCountChange(player:PlayerModel):Void
	{
		counterUnitsText.setText(Std.string(player.unitCount()));
	}
	
}