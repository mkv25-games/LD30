package net.mkv25.game.models;

class CombatLogModel
{
	public var location:HexTile;
	public var events:Array<String>;

	public function new() 
	{
		this.location = null;
		this.events = new Array<String>();
	}
	
	public function logEvent(message:String):Void
	{
		this.events.push(message);
	}
	
	public function combatStarted(location:HexTile):Void
	{
		this.location = location;
		this.logEvent("Combat started at " + location.key() + ".");
	}
	
	public function allUnitsDestroyed():Void
	{
		this.logEvent("All units destroyed at location.");
	}
	
	public function unitVictory(winner:MapUnit):Void
	{
		this.logEvent(
			"Player " + winner.owner.name() + "'s "
			+ winner.type.name
			+ " has won the combat."
		);
	}
	
	public function mutualDestruction(firstUnit:MapUnit, secondUnit:MapUnit):Void
	{
		this.logEvent(
			"Mutual destruction of "
			+ "Player " + firstUnit.owner.name() + "'s " + firstUnit.type.name
			+ " and "
			+ "Player " + secondUnit.owner.name() + "'s " + secondUnit.type.name
			+ "."
		);
	}
	
	public function baseCaptured(unit:MapUnit, base:MapUnit):Void
	{
		this.logEvent(
			"Player " + unit.owner.name() + "'s " + unit.type.name
			+ " has captured "
			+ "Player " + base.owner.name() + "'s " + base.type.name
			+ "."
		);
	}
	
	public function unitDestroyed(firstUnit:MapUnit, secondUnit:MapUnit):Void
	{
		this.logEvent(
			"Player " + firstUnit.owner.name() + "'s " + firstUnit.type.name
			+ " has destroyed "
			+ "Player " + secondUnit.owner.name() + "'s " + secondUnit.type.name
			+ "."
		);
	}
	
	public function printReport():Void
	{
		#if debug
			var i:Int = 0;
			trace("Combat Report");
			trace("-------------");
			for (entry in events)
			{
				i++;
				trace(i + ".\t" + entry);
			}
			trace("");
		#end
	}
	
}