package net.mkv25.game.provider;

import net.mkv25.game.models.MapUnit;
import net.mkv25.game.models.PlayableCard;
import net.mkv25.game.models.PlayerModel;


class UnitProvider
{
	public static function getUnit(player:PlayerModel, type:PlayableCard):MapUnit
	{
		var unit = new MapUnit();
		
		unit.setup(player, type);
		unit.icon = IconProvider.getUnitIconFor(player, type);
		
		return unit;
	}
	
	public static function changeOwner(unit:MapUnit, newOwner:PlayerModel):Void
	{
		unit.owner = newOwner;
		unit.icon = IconProvider.getUnitIconFor(newOwner, unit.type);
	}
	
}