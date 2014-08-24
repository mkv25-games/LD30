package net.mkv25.game.models;

import haxe.ds.ArraySort;
import net.mkv25.base.core.CoreModel;
import net.mkv25.game.enums.PlayableCardType;

class PlayerHand extends CoreModel
{
	public inline static var MAX_HAND_SIZE:Int = 5;
	
	public var hand:Array<PlayableCard>;
	public var deck:Array<PlayableCard>;
	public var discards:Array<PlayableCard>;
	
	public function new() 
	{
		super();
		
		hand = new Array<PlayableCard>();
		deck = new Array<PlayableCard>();
		discards = new Array<PlayableCard>();
		
		populateStartingDeck();
	}
	
	public function populateStartingDeck():PlayerHand
	{
		discards.push(PlayableCardType.HARVESTER);
		discards.push(PlayableCardType.HARVESTER);
		discards.push(PlayableCardType.HARVESTER);
		
		discards.push(PlayableCardType.PORTAL);
		
		discards.push(PlayableCardType.SCIENTISTS);
		discards.push(PlayableCardType.SCIENTISTS);
		
		discards.push(PlayableCardType.ENGINEERS);
		discards.push(PlayableCardType.ENGINEERS);
		
		discards.push(PlayableCardType.ASSAULT_TEAM);
		discards.push(PlayableCardType.ASSAULT_TEAM);
		
		drawHand();
		
		return this;
	}
	
	public function drawHand():Void
	{
		while (hand.length < PlayerHand.MAX_HAND_SIZE)
		{
			var card = drawCardFromDeck();
			hand.push(card);
		}
	}
	
	public function drawCardFromDeck():PlayableCard
	{
		if (deck.length == 0) {
			shuffleDiscardPile();
		}
		
		if (deck.length == 0) {
			throw "No cards in deck after shuffling discard pile. ;__;";
		}
		
		return deck.pop();
	}
	
	public function shuffleDiscardPile():Void
	{
		while (discards.length > 0) {
			deck.push(discards.pop());
		}
		
		for (i in 0...100) {
			var index:Int = Math.floor(Math.random() * deck.length);
			var card = deck.pop();
			deck.insert(index, card);
		}
	}
}