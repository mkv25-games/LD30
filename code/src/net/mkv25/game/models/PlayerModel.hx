package net.mkv25.game.models;

import net.mkv25.base.core.CoreModel;

class PlayerModel extends CoreModel
{
	public var playerNumberZeroBased:Int;
	public var playerHand:PlayerHand;
	
	public var resources:Int;
	public var territory:Int;

	public var units:UnitList;
	public var bases:UnitList;
	
	public function new(playerNumberZeroBased:Int) 
	{
		super();
		
		this.playerNumberZeroBased = playerNumberZeroBased;
		this.playerHand = new PlayerHand();
		
		resources = 6;
		territory = 0;
		
		units = new UnitList();
		bases = new UnitList();
	}
	
	public function name():String
	{
		return "Player " + (playerNumberZeroBased + 1);
	}
	
	public function unitCount():Int
	{
		return units.length();
	}
	
	public function baseCount():Int
	{
		return bases.length();
	}
	
}