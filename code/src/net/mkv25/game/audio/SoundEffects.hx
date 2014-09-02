package net.mkv25.game.audio;
import openfl.Assets;

class SoundEffects
{
	public static function playPop():Void
	{
		playSoundBasedOnPlatform("pop");
	}
	
	public static function playBloop():Void
	{
		playSoundBasedOnPlatform("bloop");
	}
	
	private static function playSoundBasedOnPlatform(name:String):Void
	{
		var platform:String;
		var extension:String;
		
		#if (flash || mobile)
			platform = "wave";
			extension = ".wav";
		#else
			platform = "ogg";
			extension = ".ogg";
		#end
		
		var asset = "sounds/" + platform + "/" + name + extension;
		var sfx = Assets.getSound(asset);
		if (sfx != null)
		{
			sfx.play();
		}
	}
	
}