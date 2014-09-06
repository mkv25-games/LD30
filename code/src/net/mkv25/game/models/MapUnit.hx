package net.mkv25.game.models;

import flash.display.BitmapData;
import net.mkv25.base.core.CoreModel;
import net.mkv25.game.enums.PlayableCardType;

class MapUnit implements IMapThing extends CoreModel
{
	public var icon:BitmapData;
	public var type:PlayableCard;
	public var owner:PlayerModel;

	public var engagedInCombatThisTurn:Bool;
	public var movedThisTurn:Bool;
	
	public var lastKnownLocation:HexTile;
	
	private var connections:UnitList;
	
	public function new() 
	{
		super();
		
		icon = null;
		type = null;
		owner = null;
		
		engagedInCombatThisTurn = false;
		movedThisTurn = false;
		
		lastKnownLocation = null;
		
		connections = null;
	}
	
	public function setup(owner:PlayerModel, type:PlayableCard):Void
	{
		this.owner = owner;
		this.type = type;
	}
	
	public function getIcon():BitmapData 
	{
		return this.icon;
	}
	
	public function getDepth():Int 
	{
		return type.iconOffset;
	}
	
	public function resetFlags():Void
	{
		engagedInCombatThisTurn = false;
		movedThisTurn = false;
	}
	
	public function hasConnections():Bool
	{
		return (connections != null && connections.length() > 0);
	}
	
	public function isConnectedTo(unit:MapUnit):Bool
	{
		if (unit == null || connections == null)
		{
			return false;
		}
		
		return (connections.contains(unit));
	}
	
	public function connectTo(base:MapUnit):Void
	{
		checkConnections();
		
		connections.addUnit(base);
	}
	
	public function disconnectFrom(base:MapUnit):Void
	{
		if (connections != null)
		{
			connections.removeUnit(base);
		}
	}
	
	public function breakConnection(base:MapUnit):Bool
	{
		if (base == null || connections == null)
		{
			return false;
		}
		
		return connections.removeUnit(base);
	}
	
	public function breakAllConnections():Void
	{
		for (connection in connections.list())
		{
			connection.breakConnection(this);
		}
		connections = null;
	}
	
	public function listConnections():Null<UnitList>
	{
		return connections;
	}
	
	inline function checkConnections():Void
	{
		if (this.connections == null)
		{
			this.connections = new UnitList();
		}
	}
}