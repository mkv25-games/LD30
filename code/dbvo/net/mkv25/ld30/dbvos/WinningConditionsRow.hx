package net.mkv25.ld30.dbvos;

import net.mkv25.ld30.interfaces.*;

class WinningConditionsRow implements IDBVORow
{
	public var dbvos(get,set):IDBVOsModel;
	var _dbvos:IDBVOsModel;
		
	// code generated list of variables
	public var name:String;
	public var title:String;
	public var shortDescription:String;
	public var fullDescription:String;
	public var id(get,set):Int;
	var _id:Int;
		
	public function new(dbvos:IDBVOsModel)
	{
		_dbvos = dbvos;
	}
		
	public function init(_id:Int, _name:String, _title:String, _shortDescription:String, _fullDescription:String):WinningConditionsRow
	{
		// code generated list of params
		id = _id;
		name = _name;
		title = _title;
		shortDescription = _shortDescription;
		fullDescription = _fullDescription;
		
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
