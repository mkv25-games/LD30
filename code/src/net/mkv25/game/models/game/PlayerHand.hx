package net.mkv25.game.models.game;

import net.mkv25.base.core.CoreModel;
import net.mkv25.base.core.Pointer;

class PlayerHand extends CoreModel
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
}