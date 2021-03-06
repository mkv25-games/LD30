package net.mkv25.game.models.startVariants;

import net.mkv25.game.enums.PlayableCardType;
import net.mkv25.game.models.MapModel;
import net.mkv25.game.models.PlayerModel;
import net.mkv25.game.models.PlayableCard;
import net.mkv25.game.provider.UnitProvider;

class SmallHandStartVariant implements IStartVariant
{
	public function new()
	{
		
	}
	
	public function startingCards():Array<PlayableCard> 
	{
		// starting cards: 3 harvester, 1 engineer, 1 scientist
		var cards:Array<PlayableCard> = [
			PlayableCardType.HARVESTER, PlayableCardType.HARVESTER, PlayableCardType.HARVESTER,
			PlayableCardType.ENGINEERS,
			PlayableCardType.SCIENTISTS
		];
		
		return cards;
	}
	
	public function startingUnitPlacement(player:PlayerModel, startingWorld:MapModel):Void 
	{
		var startingBase = UnitProvider.getUnit(player, PlayableCardType.STANDARD_BASE);
		startingWorld.getHexTile(0, 0).add(startingBase);
		
		var startingUnit1 = UnitProvider.getUnit(player, PlayableCardType.ASSAULT_TEAM);
		startingWorld.getHexTile(-1, 1).add(startingUnit1);
		
		var startingUnit2 = UnitProvider.getUnit(player, PlayableCardType.ASSAULT_TEAM);
		startingWorld.getHexTile(1, 0).add(startingUnit2);
		
		var startingUnit3 = UnitProvider.getUnit(player, PlayableCardType.ASSAULT_TEAM);
		startingWorld.getHexTile(0, -1).add(startingUnit3);
	}
	
	public function startingResources():Int
	{
		return 0;
	}
	
}