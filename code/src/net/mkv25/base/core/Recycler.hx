package net.mkv25.base.core;

import net.mkv25.base.ui.BaseUI;
import openfl.display.DisplayObject;
import openfl.display.Sprite;

class Recycler<T>
{
	var type:Class<T>;
	
	var inUse:Array<T>;
	var unused:Array<T>;
	
	var recycler:Sprite;
	
	public function new(type:Class<T>)
	{
		this.type = type;
		
		inUse = new Array<T>();
		unused = new Array<T>();
		
		recycler = new Sprite();
	}
	
	public function get():T
	{
		var instance:T = (unused.length > 0) ? unused.pop() : Type.createInstance(type, []);
		inUse.push(instance);
		
		return instance;
	}
	
	public function recycleAll():Void
	{
		while (inUse.length > 0)
		{
			var instance:T = inUse.pop();
			
			// return to pool of unused items
			unused.push(instance);
			
			// move artwork off stage
			if (Std.is(instance, DisplayObject))
			{
				var artwork:DisplayObject = cast instance;
				recycler.addChild(artwork);
			}
			else if (Std.is(instance, BaseUI))
			{
				var base:BaseUI = cast instance;
				var artwork:DisplayObject = base.artwork;
				
				if (artwork != null)
				{
					recycler.addChild(artwork);
				}
			}
		}
	}
}