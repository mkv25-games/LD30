package net.mkv25.game.provider;

import flash.display.BitmapData;
import haxe.ds.StringMap;
import net.mkv25.base.core.Image.ImageRegion;
import net.mkv25.game.enums.PlayableCardType;
import net.mkv25.game.models.PlayableCard;
import net.mkv25.game.resources.ActionCards;
import net.mkv25.game.resources.UnitCards;

class CardProvider
{
	public var unitCards:Array<PlayableCard>;
	public var actionCards:Array<PlayableCard>;
	public var allCards:StringMap<PlayableCard>;
	
	public function new() {
		
	}
	
	public function setup():Void
	{
		unitCards = new Array<PlayableCard>();
		actionCards = new Array<PlayableCard>();
		allCards = new StringMap<PlayableCard>();
		
		populateActionCardsFrom(ActionCards.DATA);
		populateUnitCardsFrom(UnitCards.DATA);
		
		PlayableCardType.identifyCards(allCards);
	}
	
	private function populateActionCardsFrom(json:Dynamic):Void
	{
		for (key in Reflect.fields(json))
		{
			var cardJson = Reflect.getProperty(json, key);
			var card = PlayableCard.createActionCardFrom(cardJson).setName(key);
			
			var picture:BitmapData = CardPictureProvider.getPicture(card.pictureTile);
			card.setPicture(picture);
			
			actionCards.push(card);
			allCards.set(card.name, card);
		}
		
		unitCards.sort(sortActionCardsByCost);
	}
	
	function sortActionCardsByCost(a:PlayableCard, b:PlayableCard):Int
	{
		if (a.cost > b.cost)
			return 1;
		if (a.cost < b.cost)
			return -1;
		return 0;
	}
	
	private function populateUnitCardsFrom(json:Dynamic):Void
	{
		for (key in Reflect.fields(json))
		{
			var cardJson = Reflect.getProperty(json, key);
			var card = PlayableCard.createUnitCardFrom(cardJson).setName(key);
			
			var picture:BitmapData = CardPictureProvider.getPicture(card.pictureTile);
			card.setPicture(picture);
			
			unitCards.push(card);
			allCards.set(card.name, card);
		}
		
		actionCards.sort(sortUnitCardsByCost);
	}
	
	function sortUnitCardsByCost(a:PlayableCard, b:PlayableCard):Int
	{
		// units before hoes
		if (a.base && !b.base)
			return -1;
		if (!a.base && b.base)
			return 1;
			
		if (a.cost > b.cost)
			return 1;
		if (a.cost < b.cost)
			return -1;
		return 0;
	}
}