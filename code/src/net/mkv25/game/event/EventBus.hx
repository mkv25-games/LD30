package net.mkv25.game.event;

import net.mkv25.base.core.Signal;

class EventBus 
{
	// general screen navigation
	public static var requestNextScreen = new Signal();
	public static var requestLastScreen = new Signal();
	
	// TODO: Add your own custom signals here 
	
	public function new() 
	{
		
	}
	
}