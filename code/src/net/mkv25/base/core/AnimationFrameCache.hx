package net.mkv25.base.core;

import flash.display.BitmapData;

class AnimationFrameCache
{
	public static var singleton(get, null):AnimationFrameCache;
	static function get_singleton()
	{
		if (singleton == null)
			singleton = new AnimationFrameCache();
		
		return singleton;
	}
	
	var frames:Map<String, BitmapData>;
	
	private function new()
	{
		frames = new Map<String, BitmapData>();
	}
	
	public function getFrame(id:String):BitmapData
	{
		return frames.get(id);
	}
	
	public function setFrame(id:String, bmp:BitmapData):Void
	{
		frames.set(id, bmp);
	}
}