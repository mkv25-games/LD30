package net.mkv25.game.enums;

import haxe.ds.StringMap;
import net.mkv25.game.models.PlayableCard;

class PlayableCardType
{
	public static var SCIENTISTS:PlayableCard;
	public static var ENGINEERS:PlayableCard;
	public static var PORTAL:PlayableCard;
	public static var HARVESTER:PlayableCard;
	public static var EXCAVATER:PlayableCard;
	public static var PLASMA_FURNACE:PlayableCard;
	
	public static var STANDARD_BASE:PlayableCard;
	public static var ADVANCED_BASE:PlayableCard;
	public static var OUTPOST:PlayableCard;
	public static var METROPLEX:PlayableCard;
	
	public static var ASSAULT_TEAM:PlayableCard;
	public static var ARMOURED_CORE:PlayableCard;
	public static var TITAN_FORCE:PlayableCard;
	public static var CAPITAL_ARMY:PlayableCard;
	
	public static function identifyCards(allCards:StringMap<PlayableCard>):Void
	{
		PlayableCardType.SCIENTISTS = findCard(allCards, "Scientists");
		PlayableCardType.ENGINEERS = findCard(allCards, "Engineers");
		PlayableCardType.PORTAL = findCard(allCards, "Portal");
		PlayableCardType.HARVESTER = findCard(allCards, "Harvester");
		PlayableCardType.EXCAVATER = findCard(allCards, "Excavater");
		PlayableCardType.PLASMA_FURNACE = findCard(allCards, "Plasma Furnace");
		
		PlayableCardType.STANDARD_BASE = findCard(allCards, "Standard Base");
		PlayableCardType.ADVANCED_BASE = findCard(allCards, "Advanced Base");
		PlayableCardType.OUTPOST = findCard(allCards, "Outpost");
		PlayableCardType.METROPLEX = findCard(allCards, "Metroplex");
		
		PlayableCardType.ASSAULT_TEAM = findCard(allCards, "Assault Team");
		PlayableCardType.ARMOURED_CORE = findCard(allCards, "Armoured Core");
		PlayableCardType.TITAN_FORCE = findCard(allCards, "Titan Force");
		PlayableCardType.CAPITAL_ARMY = findCard(allCards, "Capital Army");
	}
	
	private static function findCard(allCards:StringMap<PlayableCard>, name:String):PlayableCard
	{
		var card = allCards.get(name);
		if (card == null) {
			throw "Could not find a playable card with the name: " + name;
		}
		return card;
	}
}