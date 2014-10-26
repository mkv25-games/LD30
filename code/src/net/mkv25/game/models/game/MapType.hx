package net.mkv25.game.models.game;

import net.mkv25.base.core.CoreModel;
import net.mkv25.game.models.startVariants.IStartVariant;

class MapType extends CoreModel
{
	public var variant(default, null):String;
	
	public function new() 
	{
		super();
	}
}