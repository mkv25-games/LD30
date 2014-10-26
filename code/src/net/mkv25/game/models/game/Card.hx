package net.mkv25.game.models.game;

import net.mkv25.base.core.CoreModel;
import net.mkv25.base.core.ISerializable;

class Card extends CoreModel implements ISerializable
{
	public var cardId(default, null):String;
	public var name(default, null):String;
	public var action(default, null):String;
	
	public var movement(default, null):Int;
	public var cost(default, null):Int;
	public var pictureTile(default, null):Int;
	
	public function new() 
	{
		super();
	}
	
	public function serialize():Dynamic
	{
		var result:Dynamic = { };
		
		write("cardId", result, cardId);
		write("name", result, name);
		write("action", result, action);
		
		write("movement", result, movement);
		write("cost", result, cost);
		write("pictureTile", result, pictureTile);
		
		return result;
	}
	
	public function readFrom(object:Dynamic):Void
	{
		this.cardId = read("cardId", object, null);
		this.name = read("name", object, null);
		this.action = read("action", object, null);
		
		this.movement = readInt("movement", object, 0);
		this.cost = readInt("cost", object, 0);
		this.pictureTile = readInt("pictureTile", object, 0);
	}
	
	public static function makeFrom(object:Dynamic):Card
	{
		var instance:Card = new Card();
		
		instance.readFrom(object);
		
		return instance;
	}
}