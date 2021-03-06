package net.mkv25.game.models;

import net.mkv25.base.core.ISerializable;

class UnitList implements ISerializable
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
			units.sort(sortStrongestUnitsFirst);
			
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
	
	public function getCandidateForMovement(requiredOwner:PlayerModel, currentlySelectedUnit:MapUnit):Null<MapUnit>
	{
		if (units.length > 0)
		{
			// if set, offset from the starting unit, i.e. skip that unit until last
			var offset:Int = Lambda.indexOf(units, currentlySelectedUnit);
			
			return units[(units.length + offset + 1) % units.length];
		}
		
		return null;
	}
	
	function sortStrongestUnitsFirst(a:MapUnit, b:MapUnit):Int
	{
		// sort by strength, but sort units before bases
		if (a.type.strength < b.type.strength)
		{
			return 1;
		}
		else if (a.type.strength > b.type.strength)
		{
			return -1;
		}
		else
		{
			if (a.type.base && !b.type.base)
			{
				return 1;
			}
			else if (!a.type.base && b.type.base)
			{
				return -1;
			}
			else
			{
				return 0;
			}
		}
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