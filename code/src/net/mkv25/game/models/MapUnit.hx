package net.mkv25.game.models;

import flash.display.BitmapData;
import net.mkv25.base.core.CoreModel;
import net.mkv25.game.enums.PlayableCardType;

class MapUnit implements IMapThing extends CoreModel
{
	public var icon:BitmapData;
	public var depth:Int;
	public var unit:PlayableCard;
	public var owner:PlayerModel;

	public function new() 
	{
		super();
	}
	
	public function getIcon():BitmapData 
	{
		return this.icon;
	}
	
	public function getDepth():Int 
	{
		return this.depth;
	}
	
}