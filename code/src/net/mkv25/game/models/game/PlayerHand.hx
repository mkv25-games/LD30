package net.mkv25.game.models.game;

import net.mkv25.base.core.CoreModel;
import net.mkv25.base.core.ISerializable;
import net.mkv25.base.core.Pointer;

class PlayerHand extends CoreModel implements ISerializable
{
	public var deck(default, null):Array<Pointer<Card>>;
	public var hand(default, null):Array<Pointer<Card>>;
	public var discards(default, null):Array<Pointer<Card>>;

	public function new() 
	{
		super();
		
		deck = new Array<Pointer<Card>>();
		hand = new Array<Pointer<Card>>();
		discards = new Array<Pointer<Card>>();
	}
	
	public function readFrom(object:Dynamic):Void
	{
		deck = readPointerArray("deck", object, Card);
		hand = readPointerArray("hand", object, Card);
		discards = readPointerArray("discards", object, Card);
	}
	
	public function serialize():Dynamic
	{
		var result:Dynamic = { };
		
		writeArray("deck", result, deck);
		writeArray("hand", result, hand);
		writeArray("discards", result, discards);
		
		return result;
	}
}