package net.mkv25.ld30.tables;

import net.mkv25.ld30.interfaces.*;
import net.mkv25.ld30.dbvos.GameVariantRow;

class GameVariantTable implements IDBVOTable
{
	public var dbvos(get, set):IDBVOsModel;
	var _dbvos:IDBVOsModel;

	public var rowList(get, never):Array<IDBVORow>;
	var _rowList:Array<GameVariantRow>;
	
	public var rowType(get, never):String;
	public var tableName(get, never):String;

	public function new(dbvos:IDBVOsModel)
	{
		_dbvos = dbvos;
	}

	public function init():GameVariantTable
	{
		_rowList = new Array<GameVariantRow>();

		// code generated list of all rows
		var row0:GameVariantRow = cast index(new GameVariantRow(dbvos).init(0, "None", "No units", "No cards"));
		var row1:GameVariantRow = cast index(new GameVariantRow(dbvos).init(1, "Classic", "1 standard base", "3 harvester, 2 assault team, 2 engineer, 2 scientist, 1 portal"));
		var row3:GameVariantRow = cast index(new GameVariantRow(dbvos).init(3, "Small Hand", "1 standard base, 2 assault teams", "3 harvester, 1 engineer, 1 scientist"));
			
		return this;
	}

	public function index(row:IDBVORow):IDBVORow
	{
		row.dbvos = dbvos;
		_rowList.push(cast row);
		return row;
	}
		
	public function get_dbvos():IDBVOsModel
	{
		return _dbvos;
	}
		
	public function set_dbvos(value:IDBVOsModel):IDBVOsModel
	{
		return _dbvos = value;
	}
		
	public function get_tableName():String
	{
		return "Game Variant";
	}
		
	public function get_rowList():Array<IDBVORow>
	{
		var _typedList = new Array<IDBVORow>();
		for(item in _rowList)
		{
			_typedList.push(item);
		}
		return _typedList;
	}

	public function get_rowType():String
	{
		return "GameVariantRow";
	}
		
	public function getRow(id:Int):IDBVORow
	{
		for(row in rowList)
		{
			if(row.id == id)
				return row;
		}
		return null;
	}
		
	public function getRowCast(id:Int):GameVariantRow
	{
		return cast getRow(id);
	}
}
