package net.mkv25.game.models;
import motion.Actuate;
import net.mkv25.base.core.StorageModel;
import net.mkv25.game.event.EventBus;

class LastSavedGameModel
{
	public var savedGame(default, null):ActiveGame;

	public function new() 
	{
		Actuate.timer(0.5).onComplete(init);
	}
	
	function init()
	{
		var model = new StorageModel("lastSavedGame");
		
		model.read(onComplete, onError);
	}
	
	function onComplete(data:Dynamic)
	{
		try
		{
			if (data != null)
			{
				savedGame = ActiveGame.makeFrom(data);
			
				EventBus.lastSavedGameAvailable.dispatch(savedGame);
			}
			else
			{
				// No last saved game available
			}
		}
		catch (exception:Dynamic)
		{
			EventBus.errorLoadingSavedGame.dispatch(exception);
		}
	}
	
	function onError(error)
	{
		savedGame = null;
		
		EventBus.errorLoadingSavedGame.dispatch(error);
	}
	
}