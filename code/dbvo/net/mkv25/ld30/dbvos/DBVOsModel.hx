package net.mkv25.ld30.dbvos;

import net.mkv25.ld30.interfaces.*;
import net.mkv25.ld30.tables.*;

class DBVOsModel implements IDBVOsModel
{
	/** List of all tables */
	public var tableList(get, never):Array<IDBVOTable>;
	var _tableList:Array<IDBVOTable>;
		
	/** Has the list of tables been loaded yet */
	public var loaded(get, never):Bool;
	var _loaded:Bool;

	// code generated list of all tables
	public var WINNING_CONDITIONS:WinningConditionsTable;
	
	public function new()
	{
		_tableList = new Array<IDBVOTable>();

		init();
	}

	/** Initialise the list of tables */
	public function init()
	{
		var dbvos:IDBVOsModel = this;

		// code generated list of all tables
		WINNING_CONDITIONS = cast index(new WinningConditionsTable(dbvos).init());
			
		_loaded = true;
	}

	/** Indexes a table */
	function index(table:IDBVOTable):IDBVOTable
	{
		table.dbvos = this;
		_tableList.push(table);
		return table;
	}
		
	/** List of all tables indexed by this model */
	public function get_tableList():Array<IDBVOTable>
	{
		return _tableList;
	}
		
	/** Have the tables for this model been initialised yet */
	public function get_loaded():Bool
	{
		return _loaded;
	}
		
	/** Retrieves a row from a table */
	public function retrieve(id:Int, type:String):IDBVORow
	{
		var table:IDBVOTable = selectTable(type);
		return table.getRow(id);
	}
		
	/** Retrieves a table by type */
	public function selectTable(type:String):IDBVOTable
	{
		for(table in _tableList)
		{
			if(table.rowType == type)
				return table;
		}
		return null;
	}
}
