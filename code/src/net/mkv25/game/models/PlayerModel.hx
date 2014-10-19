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
		
		init();
	}
	
	function init()
	{
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
		init();
		
		playerNumberZeroBased = readInt("playerNumberZeroBased", object, -1);
		
		playerHand.readFrom(read("playerHand", object, { }));
		resources = readInt("resources", object, 0);
		territory = readInt("territory", object, 0);
		
		playerColour.readFrom(read("playerColour", object, { }));
	}
	
	public function serialize():Dynamic
	{
		var result:Dynamic = { };
		
		write("playerNumberZeroBased", result, playerNumberZeroBased);
		
		writeObject("playerHand", result, playerHand);
		write("resources", result, resources);
		write("territory", result, territory);
		
		writeObject("playerColour", result, playerColour);
		
		return result;
	}
}