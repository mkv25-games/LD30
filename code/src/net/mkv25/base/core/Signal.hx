package net.mkv25.base.core;

import flash.Vector;
	
class Signal
{
	public var listeners:Vector < Dynamic -> Void > ;
	
	public function new()
	{
		listeners = new Vector < Dynamic -> Void > ();
	}
	
	public function add (listener: Dynamic -> Void):Void
	{
		listeners.push(listener);
	}
	
	public function remove (listener: Dynamic -> Void):Void
	{
		var i = -1;
		for (k in listeners)
		{
			i++;
			if (k == listener)
				break;
		}
		if(i >= 0)
			listeners.splice(i, 1);
	}
	
	public function removeAll():Void
	{
		var list = this.listeners;
		while(list.length > 0)
			list.pop();
	}
	
	public function dispatch(args:Dynamic):Void
	{
		var list = this.listeners;
		for (listener in list)
		{
			if(listener != null)
				listener(args);
		}
	}
}