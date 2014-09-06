package net.mkv25.ld30;

import net.mkv25.ld30.dbvos.DBVOsModel;
import net.mkv25.ld30.interfaces.IDBVOsModel;
import net.mkv25.ld30.interfaces.IDBVOTable;

class AutoTests
{
	public function new()
	{
		var model:IDBVOsModel = new DBVOsModel();
		for(table in model.tableList)
		{
			trace("Table: " + table.tableName + ", Rows: " + table.rowList.length);
		}
	}		
}
