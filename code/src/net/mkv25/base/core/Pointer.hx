package net.mkv25.base.core;

import haxe.ds.StringMap;

/**
 * Soft reference type : Pointer<T> - that can be easily serialized
 * For use when you need a reference to an object in a different domain, where this domain requires serialization, and the referenced object should not form part of this domain's serialization tree.
 */
class Pointer<T>
{
	/**
	 * The in memory reference table, that will be populated when objects of type T are deserialized.
	 */
	private static var table:StringMap<Dynamic>;
	
	/**
	 * Store a value, will throw an error if trying to replace an existing value.
	 * @param	id     the unique id used to store T within the domain
	 * @param	value  the item of type T to store
	 */
	public static function store(id:String, value:Dynamic):Void
	{
		if (exists(id))
		{
			throw "Item already exists at index " + id;
		}
		
		table.set(id, value);
	}
	
	/**
	 * Destroy the static table of stored values.
	 */
	public static function reset():Void
	{
		initialise();
	}
	
	/**
	 * Create the static table of stored values. 
	 */
	private static function initialise():Void
	{
		table = new StringMap<Dynamic>();
	}
	
	/**
	 * Check if an item already exs
	 * @param	id
	 * @return  true if an entry exists for the supplied value
	 */
	public static function exists(id:String):Bool
	{
		if (table == null)
		{
			initialise();
		}
		
		return table.exists(id);
	}
	
	/**
	 * The id of the current reference
	 */
	private var id:String;
	
	/**
	 * The value of the reference, will incur a table look up if the value is null.
	 */
	public var value(get, null):Null<T>;

	/**
	 * Use Pointer<T>.makeFrom to instantiate new pointers.
	 */
	public function new(id:String) 
	{
		this.id = id;
	}
	
	/**
	 * Attempt to retrieve the value, and cache it if set.
	 * @return
	 */
	function get_value():Null<T>
	{
		if (value != null)
		{
			return value;
		}
		else
		{
			value = cast table.get(id);
		}
		
		return value;
	}
	
	/**
	 * Use in conjunction with makeFrom to serialize and deserialize this pointer.
	 * @return
	 */
	public function serialize():String
	{
		return id;
	}
}