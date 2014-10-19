package net.mkv25.base.core;

class Color implements ISerializable
{
	public var value:Int;
	public var alpha:Float;

	public function new(value:Int=0x000000, alpha:Float=1.0) 
	{
		this.value = value;
		this.alpha = alpha;
	}
	
	public function readFrom(object:Dynamic)
	{
		if (object == null)
		{
			return;
		}
		
		value = Std.parseInt(object.value);
		alpha = Std.parseFloat(object.alpha);
	}
	
	public function serialize():Dynamic
	{
		var result:Dynamic = { };
		
		result.value = Std.string(value);
		result.alpha = Std.string(alpha);
		
		return result;
	}
}