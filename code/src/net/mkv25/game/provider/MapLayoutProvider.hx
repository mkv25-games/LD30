package net.mkv25.game.provider;
import haxe.ds.IntMap;
import net.mkv25.game.models.ActiveGame;
import net.mkv25.game.models.HexTile;
import net.mkv25.game.models.MapModel;
import openfl.Assets;

class MapLayoutProvider
{	
	static var options:IntMap<ActiveGame->Void>;
	
	public static function createWorldsFor(numberOfPlayers:Int, game:ActiveGame):Void
	{
		checkOptions();
		
		var creator:ActiveGame-> Void = options.get(numberOfPlayers);
		if (creator == null)
		{
			throw "Could not find a valid creator method for " + numberOfPlayers + " players.";
		}
		
		creator(game);
	}
	
	static private function checkOptions():Void
	{
		if (options != null)
		{
			return;
		}
		
		options = new IntMap<ActiveGame->Void>();
		options.set(1, createWorldsForSinglePlayer);
		options.set(2, createWorldsForTwoPlayers);
		options.set(3, createWorldsForThreePlayers);
		options.set(4, createWorldsForFourPlayers);
		options.set(5, createWorldsForFivePlayers);
		options.set(6, createWorldsForSixPlayers);
	}
	
	static private function createSpaceMap(game:ActiveGame, radius:Int):Void
	{
		game.space = new MapModel();
		game.space.setup("s0", Assets.getBitmapData("img/starfield-small.png"), null);
		game.space.hexes = MapModel.createCircle(radius);
		game.space.indexHexes();
	}
	
	static private function createWorldsForSinglePlayer(game:ActiveGame):Void
	{
		createWorldsForSixPlayers(game);
	}
	
	static private function createWorldsForTwoPlayers(game:ActiveGame):Void
	{
		createWorldsForSixPlayers(game);
	}
	
	static private function createWorldsForThreePlayers(game:ActiveGame):Void
	{
		MapLayoutProvider.createSpaceMap(game, 5);
		
		game.worlds = new Array<MapModel>();
		
		addWorld(game, 0,  -4, 0, "img/planet01.png");
		addWorld(game, -4, 4, 1, "img/planet02.png");
		addWorld(game, 4,  0, 2, "img/planet03.png");
		
		addWorld(game, 0, 0, 4, "img/planet05.png");
	}
	
	static private function createWorldsForFourPlayers(game:ActiveGame):Void
	{
		createWorldsForSixPlayers(game);
	}
	
	static private function createWorldsForFivePlayers(game:ActiveGame):Void
	{
		createWorldsForSixPlayers(game);
	}
	
	static private function createWorldsForSixPlayers(game:ActiveGame):Void
	{
		MapLayoutProvider.createSpaceMap(game, 5);
		
		game.worlds = new Array<MapModel>();
		
		addWorld(game, -4,  4, 0, "img/planet01.png");
		addWorld(game,  4, -4, 1, "img/planet02.png");
		addWorld(game, -4,  0, 2, "img/planet03.png");
		addWorld(game, 4,  0, 3, "img/planet04.png");
		addWorld(game, 0, -4, 5, "img/planet06.png");
		addWorld(game, 0,  4, 6, "img/planet07.png");
		
		addWorld(game, 0, 0, 4, "img/planet05.png");
	}
	
	static private function addWorld(game:ActiveGame, q:Int, r:Int, id:Int, backgroundAsset:String):Void
	{
		var world:MapModel = new MapModel();
		world.setup("w" + id, Assets.getBitmapData(backgroundAsset), IconProvider.WORLD_ICONS[id]);
		world.hexes = MapModel.createRectangle(13, 9);
		world.indexHexes();
		
		var hex:HexTile = game.space.getHexTile(q, r);
		if (hex == null)
		{
			throw "Requested hex " + q + ", " + r + " does not exist on the map.";
		}
		hex.add(world);
		world.setSpaceHex(hex);
		
		game.worlds.push(world);
	}
	
}