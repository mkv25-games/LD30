package net.mkv25.base.core;

class Color
{
	public var value:Int;
	public var alpha:Float;

	public function new(value:Int=0x000000, alpha:Float=1.0) 
	{
		this.value = value;
		this.alpha = alpha;
	}
}