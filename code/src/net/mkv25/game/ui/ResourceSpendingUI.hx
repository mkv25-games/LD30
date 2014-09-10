package net.mkv25.game.ui;

import motion.Actuate;
import net.mkv25.base.core.Recycler;
import net.mkv25.base.core.Signal;
import net.mkv25.base.ui.BaseUI;
import net.mkv25.base.ui.BitmapUI;
import net.mkv25.game.event.EventBus;
import net.mkv25.game.models.ResourceTransactionModel;
import net.mkv25.game.provider.IconProvider;

class ResourceSpendingUI extends BaseUI
{
	public var cashedOutCounter:Signal;
	
	var resourceRecycler:Recycler<BitmapUI>;
	
	var resourceCounter:BaseUI;

	public function new() 
	{
		super();
		
		IconProvider.setup();
		
		cashedOutCounter = new Signal();
		
		resourceRecycler = new Recycler<BitmapUI>(BitmapUI);
	}
	
	function checksForValidHud():Void
	{
		resourceCounter = Index.resourceCounterHud;
		
		if (resourceCounter == null)
		{
			throw "Need to setup Index.resourceCounterHud with a valid UI element before spawning resources.";
		}
	}
	
	public function spendResources(transaction:ResourceTransactionModel):Void
	{
		checksForValidHud();
		
		resourceRecycler.recycleAll();
		
		var amount = cast Math.abs(transaction.resourceChange);
		for (i in 0...amount)
		{
			var icon = resourceRecycler.get();
			artwork.addChild(icon.artwork);
			
			icon.show();
			icon.scale = 1.0;
			icon.artwork.alpha = 0.0;
			icon.setBitmapData(IconProvider.ICON_RESOURCE_COUNTER);
			
			var delayTime:Float = 0.0 + (i * 0.15);
			var animationTime:Float = 0.5;
			
			Actuate.apply(icon.artwork, { alpha: 1.0 } ).delay(delayTime);
			cashOutResourceCounter(icon, transaction, delayTime);
		}
	}
	
	function cashOutResourceCounter(icon:BitmapUI, transaction:ResourceTransactionModel, delayTime:Float):Void
	{
		icon.move(resourceCounter.artwork.x, resourceCounter.artwork.y);
		
		Actuate.tween(icon.artwork, 0.2, { alpha: 0.0, y: icon.artwork.y - 25 } )
			.delay(delayTime)
			.onComplete(cashedOutCounter.dispatch, [transaction]);
	}
	
}