package net.mkv25.base.core;

class CoreModel
{
	public var changed:Signal;

	public function new() 
	{
		changed = new Signal();
	}

	function read(property:String, from:Dynamic, defaultTo:Dynamic):Dynamic
	{
		if (from == null) return defaultTo;
		return Reflect.hasField(from, property) ? Reflect.field(from, property) : defaultTo;
	}
	
	function write(property:String, to:Dynamic, value:Dynamic):Void
	{
		if (to == null) throw "Value of 'to' is null, cannot write.";
		if (value != null) Reflect.setField(to, property, value);
	}
	
	function readInt(property:String, from:Dynamic, defaultTo:Dynamic):Dynamic
	{
		if (from == null) return defaultTo;
		return Reflect.hasField(from, property) ? Std.parseInt(Reflect.field(from, property)) : defaultTo;
	}
	
	function readFloat(property:String, from:Dynamic, defaultTo:Dynamic):Dynamic
	{
		if (from == null) return defaultTo;
		var value = Reflect.hasField(from, property) ? Std.parseFloat(Reflect.field(from, property)) : defaultTo;
		if (Math.isNaN(value))
			return defaultTo;
		return value;
	}
	
	function readEnum(type:Enum<Dynamic>, property:String, from:Dynamic, defaultTo:Dynamic):Dynamic
	{
		var value = read(property, from, null);
		if (value == null) return defaultTo;
		return Type.createEnum(type, value);
	}
	
	function writeEnum(property:String, to:Dynamic, value:Dynamic):Void
	{
		if (value == null) return;
		write(property, to, Std.string(value));
	}
	
	function readBool(property:String, from:Dynamic, defaultTo:Bool):Bool
	{
		var value = read(property, from, null);
		if (value == null) return defaultTo;
		return (value == "true");
	}
	
	function writeBool(property:String, to:Dynamic, value:Bool)
	{
		write(property, to, Std.string(value));
	}
}