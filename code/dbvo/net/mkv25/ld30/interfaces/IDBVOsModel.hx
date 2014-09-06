package net.mkv25.ld30.interfaces;

interface IDBVOsModel
{
	var tableList(get,never):Array<IDBVOTable>;
	var loaded(get,never):Bool;
	function retrieve(id:Int, type:String):IDBVORow;
}