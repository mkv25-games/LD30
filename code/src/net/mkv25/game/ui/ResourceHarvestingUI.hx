package net.mkv25.game.ui;

import net.mkv25.base.core.Recycler;
import net.mkv25.base.ui.BaseUI;
import net.mkv25.base.ui.BitmapUI;
import net.mkv25.game.event.EventBus;
import net.mkv25.game.provider.IconProvider;

class ResourceHarvestingUI extends BaseUI
{
	var resourceRecycler:Recycler<BitmapUI>;
	var resourceCounter:BaseUI;

	public function new() 
	{
		super();
		
		IconProvider.setup();
		
		resourceRecycler = new Recycler<BitmapUI>(BitmapUI);
		
		EventBus.spawnResourcesForCardHolder.add(handle_spawningOfResources);
	}
	
	function handle_spawningOfResources(model:CardHolderUI):Void
	{
		collectResourcesFor(model);
	}
	
	function checksForValidCard(card:CardHolderUI):Void
	{
		resourceCounter = Index.resourceCounterHud;
		
		if (resourceCounter == null)
		{
			throw "Need to call setup Index.resourceCounterHud with a valid UI element before spawning resources.";
		}
		
		if (card == null)
		{
			throw "Cannot collect resources for a null card holder.";
		}
		
		if (card.assignedCard == null)
		{
			throw "Cannot collect resources for a card holder with no assigned card.";
		}
		
		if (card.assignedCard.resources == 0)
		{
			throw "Cannnot collect 0 resources from assigned card: " + card.assignedCard.name + ".";
		}
	}
	
	function collectResourcesFor(card:CardHolderUI):Void
	{
		resourceRecycler.recycleAll();
		
		checksForValidCard(card);
		
		var resourceCount:Int = card.assignedCard.resources;
		
		for (i in 0...resourceCount)
		{
			var icon = resourceRecycler.get();
			artwork.addChild(icon.artwork);
			
			icon.show();
			icon.scale = 1.0;
			icon.artwork.alpha = 1.0;
			icon.setBitmapData(IconProvider.ICON_RESOURCE_COUNTER);
			
			var delayTime:Float = (i * 0.15);
			var animationTime:Float = 0.5;
			
			var animation = icon.moveBetween(card, resourceCounter, animationTime, delayTime);
			if (animation != null)
			{
				animation.onComplete(cashInResourceCounter, [icon]);
			}
			else
			{
				cashInResourceCounter(icon);
			}
		}
	}
	
	function cashInResourceCounter(icon:BitmapUI):Void
	{
		icon.zoomOut();
		
		var player = Index.activeGame.activePlayer;
		player.resources++;
		
		EventBus.activePlayerResourcesChanged.dispatch(player);
	}
	
}