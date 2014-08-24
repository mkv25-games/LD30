package net.mkv25.game.models;
import flash.display.Bitmap;

class HexTile
{
	public static var TQW:Float = 0.75; // three quarter width
	public static var HH:Float = Math.sqrt(3) / 4; // half height, based on a width of 1
	
	public static var NEIGHBOURS = [
	   [ 1, 0], [ 1, -1], [0, -1],
	   [-1, 0], [-1,  1], [0,  1]
	];
	
	public var q:Float;
	public var r:Float;
	
	public var bitmap:Bitmap;

	public function new() 
	{
		this.q = 0;
		this.r = 0;
	}
	
	public function x():Float {
		return q * HexTile.TQW;
	}
	
	public function y():Float {
		return (q + (2 * r)) * HexTile.HH;
	}
	
	public function key():String {
		return q + "," + r;
	}
	
	public function neighbourKey(direction:Int):String {
		var d = HexTile.NEIGHBOURS[direction];
		return (q + d[0]) + "," + (r + d[1]);
	}
}