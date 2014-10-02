package net.mkv25.game.models;
import net.mkv25.game.event.EventBus;

class SelectedUnitModel
{
	var _value:MapUnit;
	
	public var value(get, set):Null<MapUnit>;

	public function new() 
	{
		this._value = null;
	}
	
	function get_value():Null<MapUnit>
	{
		return _value;
	}
	
	function set_value(newValue:Null<MapUnit>):Null<MapUnit>
	{
		if (this._value != newValue)
		{
			this._value = newValue;
			
			EventBus.unitSelectionChanged.dispatch(this._value);
		}
		
		return this._value;
	}
}