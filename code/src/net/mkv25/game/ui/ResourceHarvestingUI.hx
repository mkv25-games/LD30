package net.mkv25.game.ui;

import motion.Actuate;
import net.mkv25.base.core.Recycler;
import net.mkv25.base.core.Signal;
import net.mkv25.base.ui.BaseUI;
import net.mkv25.base.ui.BitmapUI;
import net.mkv25.game.event.EventBus;
import net.mkv25.game.models.ResourceTransactionModel;
import net.mkv25.game.provider.IconProvider;

class ResourceHarvestingUI extends BaseUI
{
	public var cashedInCounter:Signal;
	
	var resourceRecycler:Recycler<BitmapUI>;
	
	var resourceCounter:BaseUI;
	var discardPile:BaseUI;

	public function new() 
	{
		super();
		
		IconProvider.setup();
		
		cashedInCounter = new Signal();
		
		resourceRecycler = new Recycler<BitmapUI>(BitmapUI);
	}
	
	function checksForValidHud():Void
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
	}
	
	public function collectResources(transaction:ResourceTransactionModel):Void
	{
		checksForValidHud();
		
		var amount = cast transaction.resourceChange;
		for (i in 0...amount)
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
				animation.onComplete(cashInResourceCounter, [icon, transaction]);
			}
			else
			{
				cashInResourceCounter(icon, transaction);
			}
		}
	}
	
	function cashInResourceCounter(icon:BitmapUI, transaction:ResourceTransactionModel):Void
	{
		cashedInCounter.dispatch(transaction);
		
		icon.zoomOut().onComplete(resourceRecycler.recycle, [icon]);
	}
	
}