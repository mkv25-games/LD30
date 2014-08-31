package net.mkv25.game.models;

import flash.display.BitmapData;
import net.mkv25.base.core.CoreModel;
import net.mkv25.game.enums.PlayableCardType;

class MapUnit implements IMapThing extends CoreModel
{
	public var icon:BitmapData;
	public var depth:Int;
	public var type:PlayableCard;
	public var owner:PlayerModel;

	public var foughtThisTurn:Bool;
	public var movedThisTurn:Bool;
	
	public function new() 
	{
		super();
		
		depth = 1;
	}
	
	public function setup(owner:PlayerModel, type:PlayableCard):Void
	{
		this.owner = owner;
		this.type = type;
	}
	
	public function getIcon():BitmapData 
	{
		return this.icon;
	}
	
	public function getDepth():Int 
	{
		return this.depth;
	}
	
	public function resetFlags():Void
	{
		foughtThisTurn = false;
		movedThisTurn = false;
	}
	
}