package net.mkv25.base.core;

interface ISerializable 
{
	public function serialize():Dynamic;
	public function readFrom(object:Dynamic):Void;
}
