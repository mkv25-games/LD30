package net.mkv25.game.provider;

import flash.display.Bitmap;
import flash.display.BitmapData;
import net.mkv25.base.core.Image.ImageRegion;
import net.mkv25.game.models.PlayableCard;
import net.mkv25.game.models.PlayerModel;

class IconProvider
{
	public static var ICON_COLS:Int = 10;
	public static var ICON_SIZE:Int = 40;
	
	public static var ICON_STATUS_UNITS:BitmapData;
	public static var ICON_STATUS_TERRITORY:BitmapData;
	public static var ICON_STATUS_RESOURCES:BitmapData;
	
	public static var ICON_SHORT_GAME:BitmapData;
	public static var ICON_MEDIUM_GAME:BitmapData;
	public static var ICON_LONG_GAME:BitmapData;

	public static var WORLD_ICONS:Array<BitmapData>;
	
	private static var alreadySetup:Bool = false;
	public static function setup():Void
	{
		if (alreadySetup) {
			return;
		}
		alreadySetup = true;
		
		ICON_STATUS_UNITS = getIcon(3);
		ICON_STATUS_RESOURCES = getIcon(2);
		ICON_STATUS_TERRITORY = getIcon(1);
		
		ICON_SHORT_GAME = getIcon(21);
		ICON_MEDIUM_GAME = getIcon(32);
		ICON_LONG_GAME = getIcon(43);
		
		WORLD_ICONS = new Array<BitmapData>();
		WORLD_ICONS.push(getIcon(10));
		WORLD_ICONS.push(getIcon(11));
		WORLD_ICONS.push(getIcon(12));
		WORLD_ICONS.push(getIcon(13));
		WORLD_ICONS.push(getIcon(14));
		WORLD_ICONS.push(getIcon(15));
		WORLD_ICONS.push(getIcon(16));
	}
	
	private static function getIcon(index:Int = 1):BitmapData
	{
		var x = index % ICON_COLS;
		var y = Math.floor(index / ICON_COLS);
		
		var iconImage = ImageRegion.getImageRegion("img/icons.png", x * ICON_SIZE, y * ICON_SIZE, ICON_SIZE, ICON_SIZE);
		return iconImage;
	}
	
	public static function getUnitIconFor(player:PlayerModel, type:PlayableCard):BitmapData
	{
		return IconProvider.getPlayerIconFor(player, type.iconOffset);
	}
	
	public static function getPlayerIconFor(player:PlayerModel, iconOffset:Int=0):BitmapData
	{
		var unitOffset = iconOffset;
		var rowOffset = (2 + player.playerNumberZeroBased) * ICON_COLS;
		var index = rowOffset + unitOffset;
		
		return IconProvider.getIcon(index);
	}
	
}