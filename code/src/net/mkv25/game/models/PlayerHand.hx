package net.mkv25.game.models;

import haxe.ds.ArraySort;
import net.mkv25.base.core.CoreModel;
import net.mkv25.base.core.ISerializable;
import net.mkv25.game.enums.PlayableCardType;

class PlayerHand extends CoreModel implements ISerializable
{
	public inline static var MAX_HAND_SIZE:Int = 5;
	
	private var hand:Array<PlayableCard>;
	private var deck:Array<PlayableCard>;
	private var discards:Array<PlayableCard>;
	
	public function new() 
	{
		super();
		
		hand = new Array<PlayableCard>();
		deck = new Array<PlayableCard>();
		discards = new Array<PlayableCard>();
	}
	
	public function getHand():Array<PlayableCard>
	{
		return hand;
	}
	
	public function getDeck():Array<PlayableCard>
	{
		return deck;
	}
	
	public function getDiscards():Array<PlayableCard>
	{
		return discards;
	}
	
	public function numberOfCardsInHand():Int
	{
		return hand.length;
	}
	
	public function populateStartingDeck(startingCards:Array<PlayableCard>):PlayerHand
	{
		for (card in startingCards)
		{
			discards.push(card);
		}
		
		drawHand();
		
		return this;
	}
	
	public function drawHand():Void
	{
		while (hand.length < PlayerHand.MAX_HAND_SIZE && cardsExistToDraw())
		{
			var card = drawCardFromDeck();
			hand.push(card);
		}
	}
	
	public function cardsExistToDraw():Bool
	{
		return (discards.length > 0 || deck.length > 0);
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
	
	public function addCardToDiscards(card:PlayableCard):Void
	{
		discards.push(card);
	}
	
	public function removeCardFromHand(card:PlayableCard):Void
	{
		hand.remove(card);
		discards.push(card);
	}
	
	public function trashCardFromHand(card:PlayableCard):Void
	{
		hand.remove(card);
	}
	
	
	public function readFrom(object:Dynamic)
	{
		
	}
	
	public function serialize():Dynamic
	{
		var result:Dynamic = { };
		
		return result;
	}
	
}