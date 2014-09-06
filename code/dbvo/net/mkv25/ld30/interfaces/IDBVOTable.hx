package net.mkv25.ld30.interfaces;

interface IDBVOTable
{
	var dbvos(get,set):IDBVOsModel;
	var tableName(get, never):String;
	var rowList(get, never):Array<IDBVORow>;
	var rowType(get, never):String;
	function getRow(id:Int):IDBVORow;
}