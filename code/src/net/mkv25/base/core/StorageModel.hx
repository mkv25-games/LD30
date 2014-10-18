package net.mkv25.base.core;

import openfl.net.SharedObject;
import openfl.net.SharedObjectFlushStatus;

class StorageModel
{
	private static var LOCAL_PATH:String = "mkv25/games/ld30/";
	
	var path:String;
	
	public function new(path:String) 
	{
		this.path = path;
	}
	
	public function write(data:Dynamic, onComplete:Void->Void=null, onError:String->Void=null):Void
	{
		var store = getSharedObject(path);
		
		// store the data
		store.setProperty("filedata", data);
		
		// write the data
		var result = store.flush();
		
		// decide what happened
		if (result == SharedObjectFlushStatus.FLUSHED)
		{
			completeWrite(onComplete);
		}
		else if (result == SharedObjectFlushStatus.PENDING)
		{
			// listen for response to pending decision
			store.addEventListener("netStatus", function(event)
			{
				if (event.info.code ==  "SharedObject.Flush.Success")
				{
					completeWrite(onComplete);
				}
				else if (event.info.code == "SharedObject.Flush.Failed")
				{
					error(onError, "Not enough space available to save data");
				}
				else
				{
					error(onError, "Unknown error while trying to save data: " + event.info.code);
				}
			});
		}
		else
		{
			error(onError, "Unexpected error while trying to save data: " + Std.string(result));
		}
	}
	
	public function read(onComplete:Dynamic->Void, ?onError:String->Void):Void
	{
		var store = getSharedObject(path);
		
		try
		{
			var data = store.data.filedata;
			onComplete(data);
		}
		catch (exception:Dynamic)
		{
			error(onError, Std.string(exception));
		}
	}
	
	function getSharedObject(path:String):SharedObject
	{
		return SharedObject.getLocal(path, LOCAL_PATH);
	}
	
	function completeWrite(?callback:Void->Void):Void
	{
		if (callback != null)
		{
			callback();
		}
	}
	
	function error(?callback:String->Void, ?message:String):Void
	{
		if (callback != null)
		{
			callback(message);
		}
	}
	
}