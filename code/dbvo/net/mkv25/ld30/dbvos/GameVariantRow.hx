package net.mkv25.ld30.dbvos;

import net.mkv25.ld30.interfaces.*;

class GameVariantRow implements IDBVORow
{
	public var dbvos(get,set):IDBVOsModel;
	var _dbvos:IDBVOsModel;
		
	// code generated list of variables
	public var name:String;
	public var units:String;
	public var cards:String;
	public var id(get,set):Int;
	var _id:Int;
		
	public function new(dbvos:IDBVOsModel)
	{
		_dbvos = dbvos;
	}
		
	public function init(_id:Int, _name:String, _units:String, _cards:String):GameVariantRow
	{
		// code generated list of params
		id = _id;
		name = _name;
		units = _units;
		cards = _cards;
		
		return this;
	}
		
	public function get_dbvos():IDBVOsModel
	{
		return _dbvos;
	}
		
	public function set_dbvos(value:IDBVOsModel):IDBVOsModel
	{
		return _dbvos = value;
	}
		
	public function get_id():Int
	{
		return _id;
	}
		
	public function set_id(value:Int):Int
	{
		return _id = value;
	}

	// code generated list of properties
}
