package net.mkv25.game.ui;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Graphics;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.geom.Matrix;
import net.mkv25.base.core.Image.ImageRegion;
import net.mkv25.base.ui.BaseUI;
import net.mkv25.game.event.EventBus;
import net.mkv25.game.models.HexTile;
import net.mkv25.game.models.MapModel;
import net.mkv25.game.provider.HexProvider;

class MapUI extends BaseUI
{
	static var MAP_WIDTH:Int = 500;
	static var MAP_HEIGHT:Int = 500;
	
	private var model:MapModel;
	private var hexImage:BitmapData;
	
	var hexes:Array<Bitmap>;
	var highlightedHex:HexTile;
	
	var hexLayer:Sprite;
	var thingsLayer:Sprite;
	
	var thingBitmaps:Array<Bitmap>;
	var unusedThings:Array<Bitmap>;
	var recycler:Sprite;
	
	public function new() 
	{
		super();
		
		hexes = new Array<Bitmap>();
		highlightedHex = new HexTile();
		highlightedHex.bitmap = new Bitmap();
		
		hexLayer = new Sprite();
		thingsLayer = new Sprite();
		
		thingBitmaps = new Array<Bitmap>();
		unusedThings = new Array<Bitmap>();
		recycler = new Sprite();
		
		HexProvider.setup();
		hexImage = HexProvider.EMPTY_HEX;
	}
	
	public function setup(model:MapModel)
	{
		if (this.model != null) {
			this.model.changed.remove(onModelChanged);
		}
		this.model = model;
		model.changed.add(onModelChanged);
		
		artwork.addEventListener(MouseEvent.MOUSE_MOVE, highlightHexTile, false, 0, true);
		artwork.addEventListener(MouseEvent.MOUSE_DOWN, checkHexTile, false, 0, true);
	}
	
	function highlightHexTile(mouseEvent:MouseEvent):Void
	{
		var tile:HexTile = hexUnderMouse(mouseEvent);
		if (tile != null)
		{
			highlightedHex.q = tile.q;
			highlightedHex.r = tile.r;
			highlightedHex.bitmap.bitmapData = HexProvider.FILLED_HEX;
			drawHex(highlightedHex);
		}
		else
		{
			highlightedHex.bitmap.bitmapData = null;
		}
	}
	
	function hexUnderMouse(mouseEvent:MouseEvent):HexTile {
		var hex_x = mouseEvent.localX / hexImage.width;
		var hex_y = mouseEvent.localY /  hexImage.height;
		
		var qr = HexTile.xy2qr(hex_x, hex_y);
		
		var tile:HexTile = model.getHexTile(qr[0], qr[1]);
		
		return tile;
	}
	
	function checkHexTile(mouseEvent:MouseEvent):Void
	{
		var tile:HexTile = hexUnderMouse(mouseEvent);
		if (tile != null) {
			EventBus.displayNewStatusMessage.dispatch("Selected hex: " + tile.key() + ", contains: " + tile.listContents().length + " things.");
		}
	}
	
	function redraw() {
		var graphics:Graphics = artwork.graphics;
		graphics.clear();
		
		while (thingBitmaps.length > 0) {
			var thing = thingBitmaps.pop();
			recycler.addChild(thing);
			unusedThings.push(thing);
		}
		
		while (hexes.length > 0) {
			var bmp = hexes.pop();
			if (bmp.parent == artwork) {
				artwork.removeChild(bmp);
			}
		}
		
		var hexes = model.hexes;
		for (hex in hexes) {
			drawHex(hex);
			drawThingsInHex(hex);
		}
		
		hexes.get("0,0").bitmap.bitmapData = HexProvider.FILLED_HEX;
		
		var view_x = MAP_WIDTH / 2;
		var view_y = MAP_HEIGHT / 2;
		
		hexLayer.x = view_x;
		hexLayer.y = view_y;
		
		thingsLayer.x = view_x;
		thingsLayer.y = view_y;
		
		artwork.addChild(hexLayer);
		artwork.addChild(highlightedHex.bitmap);
		artwork.addChild(thingsLayer);
	}
	
	inline function drawHex(hex:HexTile):Void
	{
		var hex_x = hex.x();
		var hex_y = hex.y();
		var x = (hexImage.width * hex_x) - (hexImage.width / 2);
		var y = (hexImage.height * hex_y) - (hexImage.height / 2);

		if (hex.bitmap == null)
		{
			var bmp = new Bitmap(hexImage);
			hex.bitmap = bmp;
		}
		
		hex.bitmap.x = x;
		hex.bitmap.y = y;
		hexLayer.addChild(hex.bitmap);
	}
	
	inline function drawThingsInHex(hex:HexTile):Void
	{
		var things = hex.listContents();
		for (thing in things)
		{
			// make an image for the thing
			var bitmap = (unusedThings.length > 0) ? unusedThings.pop() : new Bitmap();
			bitmap.bitmapData = thing.getIcon();
			thingsLayer.addChildAt(bitmap, thing.getDepth());
			thingBitmaps.push(bitmap);
			
			// recalculate position of hex
			var hex_x = hex.x();
			var hex_y = hex.y();
			var x = (hexImage.width * hex_x) - (hexImage.width / 2);
			var y = (hexImage.height * hex_y) - (hexImage.height / 2);
			
			// center thing on hex
			bitmap.x = x + (hex.bitmap.width / 2) - (bitmap.width / 2);
			bitmap.y = y + (hex.bitmap.height / 2) - (bitmap.height / 2);

		}
	}
	
	function onModelChanged(model:MapModel)
	{
		redraw();
	}
	
}