package net.mkv25.game.models;

class UnitList
{
	private var units:Array<MapUnit>;

	public function new() 
	{
		this.units = new Array<MapUnit>();
	}
	
	public function length():Int
	{
		return units.length;
	}
	
	public function list():Array<MapUnit>
	{
		return units;
	}
	
	public function addUnit(unit:MapUnit):Void
	{
		if (Lambda.indexOf(this.units, unit) == -1)
		{
			this.units.push(unit);
		}
		else
		{
			throw "Specified unit already exists in the list.";
		}
	}
	
	public function removeUnit(unit:MapUnit):Bool
	{
		return this.units.remove(unit);
	}
	
	public function removeAll():Void
	{
		while (this.units.length > 0)
		{
			this.units.pop();
		}
	}
	
	public function contains(unit:MapUnit):Bool
	{
		if (unit == null)
		{
			return false;
		}
		
		return (Lambda.indexOf(this.units, unit) != -1);
	}
	
	public function getHighestStrengthUnit(?owner:PlayerModel):Null<MapUnit>
	{
		if (units.length > 0)
		{
			units.sort(sortByUnitStrength);
			units.reverse();
			
			for (unit in units)
			{
				if (owner != null)
				{
					if (unit.owner == owner)
					{
						return unit;
					}
				}
				else
				{
					return unit;
				}
			}
		}
		
		return null;
	}
	
	public function getCandidateForMovement(owner:PlayerModel):Null<MapUnit>
	{
		if (units.length > 0)
		{
			// order by strongest unit first
			units.sort(sortByUnitStrength);
			units.reverse();
			
			// on the first pass, skip units that have already moved or have been in combat
			for (unit in units)
			{
				if (unit.movedThisTurn || unit.engagedInCombatThisTurn)
				{
					continue;
				}
				
				if (unit.owner == owner)
				{
					return unit;
				}
			}
			
			// on the second pass, consider player owned units that have already moved or been in combat
			for (unit in units)
			{
				if (unit.owner == owner)
				{
					return unit;
				}
			}
		}
		
		return null;
	}
	
	function sortByUnitStrength(a:MapUnit, b:MapUnit):Int
	{
		// sort by strength, but sort units before bases
		if (a.type.strength < b.type.strength)
		{
			return -1;
		}
		else if (a.type.strength > b.type.strength)
		{
			return 1;
		}
		else
		{
			if (a.type.base && !b.type.base)
			{
				return -1;
			}
			else if (!a.type.base && b.type.base)
			{
				return 1;
			}
			else
			{
				return 0;
			}
		}
	}
	
}