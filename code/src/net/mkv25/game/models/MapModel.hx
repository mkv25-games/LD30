package net.mkv25.game.models;

import flash.display.BitmapData;
import haxe.ds.HashMap;
import haxe.ds.StringMap;
import net.mkv25.base.core.CoreModel;
import net.mkv25.base.core.ISerializable;

class MapModel extends CoreModel implements IMapThing
{
	// serialized properties
	public var hexes:HexMap;
	
	private var id:String;
	private var spaceHex:HexTile;
	public var contested:Bool;
	
	// display properties
	public var owner:Null<PlayerModel>;
	private var background:BitmapData;
	private var mapIcon:BitmapData;
	private var mapDepth:Int;
	
	public function new() 
	{
		super();
		
		init();
	}
	
	function init()
	{
		hexes = new HexMap();
		
		contested = false;
		owner = null;
		
		background = null;
		mapIcon = null;
		mapDepth = 0;
	}
	
	public function setup(id:String, background:BitmapData, mapIcon:BitmapData):Void
	{
		this.id = id;
		this.background = background;
		this.mapIcon = mapIcon;
	}
	
	public function key():String
	{
		return id;
	}
	
	public function getBackground():BitmapData
	{
		return background;
	}

	public function getIcon():BitmapData 
	{
		return this.mapIcon;
	}
	
	public function getDepth():Int 
	{
		return this.mapDepth;
	}
	
	public function getSpaceHex():Null<HexTile>
	{
		return spaceHex;
	}
	
	public function setSpaceHex(value:HexTile):Void
	{
		this.spaceHex = value;
	}
	
	public function getHexTile(q:Int, r:Int):Null<HexTile>
	{
		return hexes.get(q, r);
	}
	
	public function indexHexes():Void
	{
		for (hex in hexes.list)
		{
			hex.map = this;
		}
	}
	
	public function recalculateTerritory():Void
	{
		// reset all tiles
		this.owner = null;
		this.contested = false;
		for (hex in hexes.list)
		{
			hex.resetOwnership();
		}
		
		// recalcuate all tiles
		for (hex in hexes.list)
		{
			hex.updateTerritory();
			if (hex.contested)
			{
				owner = null;
				this.contested = true;
			}
			else if (!contested && hex.territoryOwner != null)
			{
				owner = hex.territoryOwner;
			}
		}
	}
	
	public function isWorld():Bool
	{
		return (this.spaceHex != null);
	}
	
	public static function createCircle(radius:Int, hexes:StringMap<HexTile>):Void
	{
		for (i in -radius...radius + 1)
		{
			for (j in -radius...radius + 1)
			{
				if (validCircleCoordinate(i, j, radius))
				{
					safeAdd(hexes, i, j);
				}
			}
		}
	}
	
	public static function createRectangle(width:Int, height:Int, hexes:StringMap<HexTile>):Void
	{
		var offset_x = -Math.floor(width / 2);
		var offset_y = -Math.floor(height / 2);
		
		for (j in 0...width)
		{
			for (i in 0...height)
			{
				var q = j + offset_x;
				var r = i + offset_y;
				safeAdd(hexes, q,  r - Math.floor(q / 2));
			}
		}
	}
	
	public static function safeAdd(hexes:StringMap<HexTile>, q:Int, r:Int):Void
	{
		if (!hexes.exists(q + "," + r))
		{
			var hex = new HexTile();
			hex.q = q;
			hex.r = r;
			hexes.set(hex.key(), hex);
		}
	}
	
	private static inline function validCircleCoordinate(q:Int, r:Int, radius:Int):Bool
	{
		return insideRadius(q, r, radius) && !isCorner(q, r, radius);
	}
	
	private static inline function insideRadius(q:Int, r:Int, radius:Int):Bool
	{
		return (Math.abs(q + r) <= radius);
	}
	
	private static inline function isCorner(q:Int, r:Int, radius:Int):Bool
	{
		return (Math.abs(q) == radius && r == 0) || (Math.abs(r) == radius && q == 0) || (Math.abs(q) == radius && Math.abs(r) == radius);
	}
}