package net.mkv25.base.core;

import haxe.ds.StringMap;

/**
 * Soft reference type : Pointer<T> - that can be easily serialized
 * For use when you need a reference to an object in a different domain, where this domain requires serialization, and the referenced object should not form part of this domain's serialization tree.
 */
class Pointer<T> implements ISerializable
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
	public static function store(type:Class<Dynamic>, id:String, value:Dynamic):Void
	{
		if (exists(type, id))
		{
			throw "Item type '" + Type.getClassName(type) + "' already exists for id '" + id + "'.";
		}
		
		var key = Pointer.generateStorageKey(type, id);
		table.set(key, value);
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
	public static function exists(type:Class<Dynamic>, id:String):Bool
	{
		if (table == null)
		{
			initialise();
		}
		
		var key = Pointer.generateStorageKey(type, id);
		return table.exists(key);
	}
	
	/**
	 * The id of the current reference
	 */
	private var id:String;
	
	/**
	 * The type of data being pointed to.
	 */
	private var type:Class<T>;
	
	/**
	 * The value of the reference, will incur a table look up if the value is null.
	 */
	public var value(get, null):Null<T>;

	/**
	 * Use Pointer<T>.makeFrom to instantiate new pointers.
	 */
	public function new(id:String, type:Class<T>) 
	{
		this.id = id;
		this.type = type;
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
			var key = Pointer.generateStorageKey(type, id);
			value = cast table.get(key);
		}
		
		return value;
	}
	
	/**
	 * Generate a storage key based on type and id.
	 * @return
	 */
	private static function generateStorageKey(type:Class<Dynamic>, id:String):String
	{
		return Type.getClassName(type) + "_" + id;
	}
	
	public function readFrom(object:Dynamic):Void
	{
		
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