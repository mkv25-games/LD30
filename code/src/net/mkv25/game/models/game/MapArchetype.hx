package net.mkv25.game.models.game;

import net.mkv25.base.core.CoreModel;
import net.mkv25.base.core.ISerializable;
import net.mkv25.base.core.Pointer;
import net.mkv25.game.models.startVariants.IStartVariant;

class MapArchetype extends CoreModel implements ISerializable
{
	public var variant(default, null):Pointer<IStartVariant>;
	public var seed(default, null):Int;
	
	public function new() 
	{
		super();
		
		variant = new Pointer<IStartVariant>(null, IStartVariant); 
		seed = 0;
	}
	
	public function readFrom(object:Dynamic):Void
	{
		variant = new Pointer<IStartVariant>(read("variant", object), IStartVariant);
		seed = read("seed", object, 0);
	}
	
	public function serialize():Dynamic
	{
		var result:Dynamic = { };
		
		writeObject("variant", result, variant);
		write("seed", result, seed);
		
		return result;
	}
}