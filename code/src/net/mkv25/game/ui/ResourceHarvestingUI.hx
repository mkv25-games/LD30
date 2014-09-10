package net.mkv25.game.ui;

import motion.Actuate;
import net.mkv25.base.core.Recycler;
import net.mkv25.base.ui.BaseUI;
import net.mkv25.base.ui.BitmapUI;
import net.mkv25.game.event.EventBus;
import net.mkv25.game.provider.IconProvider;

class ResourceHarvestingUI extends BaseUI
{
	var resourceRecycler:Recycler<BitmapUI>;
	
	var resourceCounter:BaseUI;
	var discardPile:BaseUI;

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
		discardPile = Index.discardPileHud;
		
		if (resourceCounter == null)
		{
			throw "Need to setup Index.resourceCounterHud with a valid UI element before spawning resources.";
		}
		
		if (resourceCounter == null)
		{
			throw "Need to setup Index.discardPileHud with a valid UI element before spawning resources.";
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
			icon.artwork.alpha = 0.0;
			icon.setBitmapData(IconProvider.ICON_RESOURCE_COUNTER);
			
			var delayTime:Float = 0.8 + (i * 0.15);
			var animationTime:Float = 0.5;
			
			Actuate.tween(icon.artwork, 0.2, { alpha: 1.0 } ).delay(delayTime);
			var animation = icon.moveBetween(discardPile, resourceCounter, animationTime, delayTime);
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