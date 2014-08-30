package net.mkv25.game.models;
import net.mkv25.game.event.EventBus;

class CombatModel
{
	public static function moveUnit(unit:MapUnit, from:HexTile, to:HexTile):Void
	{
		// TODO: Process movement, handle combat, and raise appropriate events
		from.remove(unit);
		to.add(unit);
		
		from.map.recalculateTerritory();
		to.map.recalculateTerritory();
		
		EventBus.mapRequiresRedraw.dispatch(to.map);
	}
}