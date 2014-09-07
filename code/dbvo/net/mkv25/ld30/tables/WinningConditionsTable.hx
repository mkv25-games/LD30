package net.mkv25.ld30.tables;

import net.mkv25.ld30.interfaces.*;
import net.mkv25.ld30.dbvos.WinningConditionsRow;

class WinningConditionsTable implements IDBVOTable
{
	public var dbvos(get, set):IDBVOsModel;
	var _dbvos:IDBVOsModel;

	public var rowList(get, never):Array<IDBVORow>;
	var _rowList:Array<WinningConditionsRow>;
	
	public var rowType(get, never):String;
	public var tableName(get, never):String;

	public function new(dbvos:IDBVOsModel)
	{
		_dbvos = dbvos;
	}

	public function init():WinningConditionsTable
	{
		_rowList = new Array<WinningConditionsRow>();

		// code generated list of all rows
		var row0:WinningConditionsRow = cast index(new WinningConditionsRow(dbvos).init(0, "None", "", "", ""));
		var row1:WinningConditionsRow = cast index(new WinningConditionsRow(dbvos).init(1, "Short Game", "Master of Expansion", "Most territory on three worlds", "Capture three planets, and have the most territory at the end of a round."));
		var row3:WinningConditionsRow = cast index(new WinningConditionsRow(dbvos).init(3, "Medium Game", "All your base are belong to us", "Captured all enemy bases", "Capture all bases of all your enemies at the end of a round."));
		var row4:WinningConditionsRow = cast index(new WinningConditionsRow(dbvos).init(4, "Long Game", "War, War Never Changes, War Never Ends", "Destroyed all enemy units", "Destroy or capture every single last enemy unit and base."));
			
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
		return "Winning Conditions";
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
		return "WinningConditionsRow";
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
		
	public function getRowCast(id:Int):WinningConditionsRow
	{
		return cast getRow(id);
	}
}
