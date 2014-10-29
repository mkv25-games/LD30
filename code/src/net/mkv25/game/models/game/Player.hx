package net.mkv25.game.models.game;

import net.mkv25.base.core.CoreModel;
import net.mkv25.base.core.ISerializable;

class Player extends CoreModel implements ISerializable
{
	public var playerId(default, null):String;
	public var cards:PlayerHand;
	public var resources:Int;
	
	public function new() 
	{
		super();
	}
	
	public function readFrom(object:Dynamic):Void
	{
		playerId = read("playerId", object, null);
		cards = readObject("cards", object, PlayerHand);
		resources = readInt("resources", object, 0);
	}
	
	public function serialize():Dynamic
	{
		var result:Dynamic = { };
		
		write("playerId", result, playerId);
		writeObject("cards", result, cards);
		write("resources", result, resources);
		
		return result;
	}
	
}