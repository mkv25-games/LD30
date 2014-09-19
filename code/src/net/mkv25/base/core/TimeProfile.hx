package net.mkv25.base.core;

import haxe.ds.IntMap;
import haxe.ds.StringMap;
import haxe.Timer;
import net.mkv25.base.core.TimeProfile.TimeProfileRecord;

class TimeProfile
{
	public static var records = new StringMap<TimeProfileRecord>();

	public static function logEvent(key:String):Void
	{
		var record = findRecord(key);
		
		record.trackEvent();
	}
	
	static inline function findRecord(key:String):TimeProfileRecord
	{
		var record:TimeProfileRecord;
		if (records.exists(key)) {
			record = records.get(key);
		}
		else
		{
			record = new TimeProfileRecord(key);
			records.set(key, record);
		}
		return record;
	}
	
}

class TimeProfileRecord
{
	public var key:String;
	
	public var lastCount:Int;
	public var lastFrame:Int;
	public var total:Int;
	
	public var history:Array<Int>;
	
	public function new(key:String)
	{
		this.key = key;
		
		lastCount = 0;
		lastFrame = Math.round(Timer.stamp());
		total = 0;
		
		history = new Array<Int>();
	}
	
	public function trackEvent():Void
	{
		var frame = Math.round(Timer.stamp());
		if (lastFrame != frame)
		{
			if (history.length >= 5)
			{
				history.shift();
			}
			history.push(lastCount);
			
			lastFrame = frame;
			lastCount = 0;
		}
		
		lastCount++;
		total++;
	}
	
	public function lastFive():String
	{
		if (history.length == 0)
		{
			return "[]";
		}
		return "[" + history.join(", ") + "]";
	}
}