package net.mkv25.game.models;
import haxe.ds.IntMap;
import net.mkv25.game.event.EventBus;
import net.mkv25.game.provider.UnitProvider;

class CombatModel
{
	public static function moveUnit(unit:MapUnit, fromLocation:HexTile, targetLocation:HexTile):Void
	{
		fromLocation.remove(unit);
		targetLocation.add(unit);
		
		if (CombatModel.enemyCombatantsExistIn(targetLocation))
		{
			var log:CombatLogModel = CombatModel.processCombatFor(targetLocation);
			log.printReport();
		}
		
		fromLocation.map.recalculateTerritory();
		targetLocation.map.recalculateTerritory();
		
		EventBus.mapRequiresRedraw.dispatch(targetLocation.map);
	}
	
	public static function processCombatFor(location:HexTile):CombatLogModel
	{
		var combatLog:CombatLogModel = new CombatLogModel();
		combatLog.combatStarted(location);
		
		// Rule: Units from opposing sides can not exist in the same tile an the end of a turn.
		
		while (CombatModel.enemyCombatantsExistIn(location))
		{
			var playerUnits:IntMap<UnitList> = sortUnitsByPlayerIn(location);
			
			// Rule: When there are multiple units in a tile, the highest strength unit on each side fights first.
			var unitList:UnitList = getTheHighestStrengthUnitFromEachPlayer(playerUnits);
	
			// Pick the highest strength unit (which may be equal strength) and compare against other player units
			var firstUnit:MapUnit = unitList.getHighestStrengthUnit();
			
			// Rule: Multiple units attack in individual waves against a stacked defense.
			// Rule: If multiple players end up in the same tile at the end of a turn, the lowest strength unit of each player is considered in each wave
			for (secondUnit in unitList.list())
			{
				// Rule: Combat is calculated between only two units.
				if (secondUnit != firstUnit)
				{
					// Rule: Equal strength fights result in a loss of both units.
					// Rule: Bases can be destroyed if the attacking force has a stength equal to the base strength.
					if (secondUnit.type.strength == firstUnit.type.strength)
					{
						location.remove(firstUnit);
						location.remove(secondUnit);
						combatLog.mutualDestruction(firstUnit, secondUnit);
					}
					else if (secondUnit.type.strength < firstUnit.type.strength)
					{
						if (!firstUnit.type.base && secondUnit.type.base)
						{
							// Rule: Ownership of a base will change if a higher strength enemy exists on the tile at the end of a turn's combat.
							combatLog.baseCaptured(firstUnit, secondUnit);
							UnitProvider.changeOwner(secondUnit, firstUnit.owner);
							EventBus.combat_baseCapturedAtLocation.dispatch(location);
						}
						else
						{
							// Rule: Unequal strength fights result in the loss of the lower strenth unit, no damage is incurred on the higher strength unit, and it will fight again in the next wave.
							location.remove(secondUnit);
							combatLog.unitDestroyed(firstUnit, secondUnit);
							EventBus.combat_unitDestroyedAtLocation.dispatch(location);
						}
					}
					else
					{
						throw "Unexpected situation; first unit was weaker then second unit in wave.";
					}
				}
			}
		}
		
		// Perform final checks for reporting purposes
		var playerUnits:IntMap<UnitList> = sortUnitsByPlayerIn(location);
		var units:UnitList = getTheHighestStrengthUnitFromEachPlayer(playerUnits);
		
		if (units.length() == 0)
		{
			combatLog.allUnitsDestroyed();
			EventBus.combat_allUnitsDestroyedAtLocation.dispatch(location);
		}
		else if (units.length() == 1)
		{
			var winner:MapUnit = units.getHighestStrengthUnit();
			combatLog.unitVictory(winner);
			EventBus.combat_playerHasWonCombatAtLocation.dispatch(location);
		}
		
		return combatLog;
	}
	
	public static function getTheHighestStrengthUnitFromEachPlayer(playerUnits:IntMap<UnitList>):UnitList
	{
		var units:UnitList = new UnitList();
		
		for (unitList in playerUnits)
		{
			var nextUnit:MapUnit = unitList.getHighestStrengthUnit();
			if (nextUnit != null)
			{
				units.addUnit(nextUnit);
			}
		}
		
		return units;
	}
	
	public static function sortUnitsByPlayerIn(location:HexTile):IntMap<UnitList>
	{
		var playerUnits:IntMap<UnitList> = new IntMap<UnitList>();
		
		var contents = location.listContents();
		
		for (thing in contents)
		{
			if (Std.is(thing, MapUnit))
			{
				var unit:MapUnit = cast thing;
				var owner:PlayerModel = unit.owner;
				var unitList:UnitList = playerUnits.get(owner.playerNumberZeroBased);
				
				// populate list as new players are found
				if (unitList == null)
				{
					unitList = new UnitList();
					playerUnits.set(owner.playerNumberZeroBased, unitList);
				}
				
				// add the unit to the list
				unitList.addUnit(unit);
			}
		}
		
		return playerUnits;
	}
	
	public static function enemyCombatantsExistIn(location:HexTile):Bool
	{
		var owner:PlayerModel = null;
		
		var contents = location.listContents();
		for (thing in contents)
		{
			if (Std.is(thing, MapUnit))
			{
				var unit:MapUnit = cast thing;
				if (owner == null)
				{
					// first owner found
					owner = unit.owner;
				}
				else if(owner != unit.owner)
				{
					// owners of different units exist
					// ergo enemy combatants exist
					return true;
				}
			}
		}
		
		return false;
	}
}