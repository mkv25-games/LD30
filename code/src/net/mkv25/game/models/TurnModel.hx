package net.mkv25.game.models;

class TurnModel<T>
{
	public var firstPlayer(get, null):T;
	public var activePlayer(get, null):T;
	public var nextPlayer(get, null):T;
	public var finalPlayer(get, null):T;
	
	var first:LinkedListEntry<T>;
	var active:LinkedListEntry<T>;
	
	public function new() 
	{
		
	}
	
	public function add(player:T):Void
	{
		var entry = new LinkedListEntry<T>(player);
		
		if (first == null)
		{
			first = entry;
			active = entry;
			
			// create a loop of 1 entry
			first.previous = first;
			first.next = first;
		}
		else
		{
			// break the loop and insert the new entry
			var final = first.previous;
			
			entry.next = first;
			entry.previous = final;
			
			final.next = entry;
			first.previous = entry;
		}
	}
	
	public function size():Int
	{
		if (first == null)
		{
			return 0;
		}
		
		var entry = first;
		var count:Int = 0;
		do
		{
			entry = entry.next;
			count++;
		}
		while (entry != first);
		
		return count;
	}
	
	public function chooseNextPlayer():Void
	{
		if (active == null)
		{
			return null;
		}
		
		active = active.next;
	}
	
	public function remove(player:T):Bool
	{
		if (first == null)
		{
			return false;
		}
		
		var entry = first;
		do
		{
			if (entry.value == player)
			{
				if (entry.next == entry)
				{
					first = null;
					active = null;
				}
				else
				{
					entry.previous.next = entry.next;
					entry.next.previous = entry.previous;
					
					if (entry == first)
					{
						first = entry.next;
					}
					
					if (entry == active)
					{
						active = entry.previous;
					}
				}
				
				return true;
			}
			entry = entry.next;
		} while (entry != first);
		
		return false;
	}
	
	function get_firstPlayer():Null<T>
	{
		if (first == null)
		{
			return null;
		}
		
		return first.value;
	}
	
	function get_activePlayer():Null<T>
	{
		if (active == null)
		{
			return null;
		}
		
		return active.value;
	}
	
	function get_nextPlayer():Null<T>
	{
		if (active == null)
		{
			return null;
		}
		
		return active.next.value;
	}
	
	
	function get_finalPlayer():Null<T>
	{
		if (first == null)
		{
			return null;
		}
		
		return first.previous.value;
	}
	
	public function toString():String
	{
		var output:String = "TurnModel ( ";
		
		if (first != null)
		{
			var entry = first;
			do 
			{
				output += entry.value + " ";
				entry = entry.next;
				
			} while (entry != first);
		}
		output += ")";
		
		return output;
	}
}

private class LinkedListEntry<T>
{
	public var value(default, null):T;
	
	public function new(value:T)
	{
		this.value = value;
	}
	
	public var next:LinkedListEntry<T>;
	public var previous:LinkedListEntry<T>;
}