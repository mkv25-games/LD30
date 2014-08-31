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
	
	public function getLowestStrengthUnit():Null<MapUnit>
	{
		if (units.length > 0)
		{
			units.sort(sortByUnitStrength);
			return units[0];
		}
		
		return null;
	}
	
	public function getHighestStrengthUnit():Null<MapUnit>
	{
		if (units.length > 0)
		{
			units.sort(sortByUnitStrength);
			units.reverse();
			return units[0];
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