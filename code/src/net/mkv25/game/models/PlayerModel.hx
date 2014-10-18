package net.mkv25.game.models;

import haxe.ds.StringMap;
import net.mkv25.base.core.Color;
import net.mkv25.base.core.CoreModel;
import net.mkv25.base.core.ISerializable;

class PlayerModel extends CoreModel implements ISerializable
{
	public var playerNumberZeroBased(default, null):Int;
	
	public var playerHand:PlayerHand;
	
	public var resources:Int;
	public var territory:Int;

	public var units:UnitList;
	public var bases:UnitList;
	public var worlds:WorldList;
	
	public var playerColour:Color;
	
	public function new(playerNumberZeroBased:Int) 
	{
		super();
		
		this.playerNumberZeroBased = playerNumberZeroBased;
		
		playerHand = new PlayerHand();
		
		resources = 6;
		territory = 0;
		
		units = new UnitList();
		bases = new UnitList();
		worlds = new WorldList();
		
		playerColour = new Color();
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
	
	public function readFrom(object:Dynamic):Void
	{
		
	}
	
	public function serialize():Dynamic
	{
		var result:Dynamic = { };
		
		// writeObject("playerHand", result, playerHand);
		write("resources", result, resources);
		write("territory", result, territory);
		
		// writeObject("units", result, units);
		// writeObject("bases", result, bases);
		// writeObject("worlds", result, worlds);
		
		// writeObject("playerColour", result, playerColour);
		
		return result;
	}
}