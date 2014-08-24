package net.mkv25.game.models;

import flash.display.BitmapData;

interface IMapThing
{
	public function getIcon():BitmapData;
	public function getDepth():Int;
}