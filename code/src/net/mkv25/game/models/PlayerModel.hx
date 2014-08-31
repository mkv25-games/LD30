package net.mkv25.game.models;

import net.mkv25.base.core.CoreModel;

class PlayerModel extends CoreModel
{
	public var playerNumberZeroBased:Int;
	public var playerHand:PlayerHand;
	
	public var resources:Int;
	public var territory:Int;
	public var unitCount:Int;
	public var baseCount:Int;

	public function new(playerNumberZeroBased:Int) 
	{
		super();
		
		this.playerNumberZeroBased = playerNumberZeroBased;
		this.playerHand = new PlayerHand();
		
		resources = 6;
		territory = 0;
		unitCount = 0;
		baseCount = 0;
	}
	
	public function name():String
	{
		return "Player " + (playerNumberZeroBased + 1);
	}
	
}