package net.mkv25.game.ui;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Graphics;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.geom.Matrix;
import net.mkv25.base.core.Image.ImageRegion;
import net.mkv25.base.ui.BaseUI;
import net.mkv25.base.ui.BitmapUI;
import net.mkv25.game.event.EventBus;
import net.mkv25.game.models.HexTile;
import net.mkv25.game.models.MapModel;
import net.mkv25.game.provider.HexProvider;

class MapUI extends BaseUI
{
	static var MAP_WIDTH:Int = 500;
	static var MAP_HEIGHT:Int = 500;
	
	public var currentModel:MapModel;
	
	var hexes:Array<Bitmap>;
	var hexImage:BitmapData;
	var highlightedHex:HexTile;
	var highlightImage:BitmapUI;
	
	var mapImage:Bitmap;
	var viewLayer:Sprite;
	var hexLayer:Sprite;
	var thingsLayer:Sprite;
	
	var bitmapsInUse:Array<Bitmap>;
	var unusedThings:Array<Bitmap>;
	var recycler:Sprite;
	
	public function new() 
	{
		super();
		
		hexes = new Array<Bitmap>();
		highlightedHex = new HexTile();
		highlightImage = new BitmapUI();
		highlightImage.artwork.mouseEnabled = highlightImage.artwork.mouseChildren = false;
		
		mapImage = new Bitmap();
		viewLayer = new Sprite();
		hexLayer = new Sprite();
		thingsLayer = new Sprite();
		
		bitmapsInUse = new Array<Bitmap>();
		unusedThings = new Array<Bitmap>();
		recycler = new Sprite();
		
		HexProvider.setup();
		hexImage = HexProvider.EMPTY_HEX;
		
		EventBus.mapRequiresRedraw.add(handleMapRequiresRedraw);
	}
	
	public function setupMap(model:MapModel)
	{
		this.currentModel = model;
		
		mapImage.bitmapData = model.background;
		
		viewLayer.addEventListener(MouseEvent.MOUSE_MOVE, highlightHexTile, false, 0, true);
		viewLayer.addEventListener(MouseEvent.MOUSE_DOWN, checkHexTile, false, 0, true);
		
		redraw();
	}
	
	function handleMapRequiresRedraw(?model):Void
	{
		redraw();
	}
	
	function highlightHexTile(mouseEvent:MouseEvent):Void
	{
		var tile:HexTile = hexUnderMouse(mouseEvent);
		if (tile != null)
		{
			highlightedHex.q = tile.q;
			highlightedHex.r = tile.r;
			highlightImage.setBitmapData(HexProvider.HIGHLIGHTED_HEX);
			drawHex(highlightedHex, highlightImage.artwork);
			highlightImage.show();
			
			var contents = tile.listContents();
			// EventBus.displayNewStatusMessage.dispatch("Selected hex: " + tile.key() + ", contains: " + contents.length + " things.");
		}
		else
		{
			highlightImage.hide();
		}
	}
	
	function hexUnderMouse(mouseEvent:MouseEvent):HexTile {
		var hex_x = mouseEvent.localX / hexImage.width;
		var hex_y = mouseEvent.localY /  hexImage.height;
		
		var qr = HexTile.xy2qr(hex_x, hex_y);
		
		var tile:HexTile = currentModel.getHexTile(qr[0], qr[1]);
		
		return tile;
	}
	
	function checkHexTile(mouseEvent:MouseEvent):Void
	{
		var tile:HexTile = hexUnderMouse(mouseEvent);
		if (tile != null) {
			var contents = tile.listContents();
			
			for (thing in contents) {
				if (Std.is(thing, MapModel))
				{
					var world:MapModel = cast thing;
					setupMap(world);
				}
			}
			
			highlightImage.popIn();
		}
	}
	
	function redraw() {
		var graphics:Graphics = artwork.graphics;
		graphics.clear();
		
		while (bitmapsInUse.length > 0) {
			var thing = bitmapsInUse.pop();
			recycler.addChild(thing);
			unusedThings.push(thing);
		}
		
		while (hexes.length > 0) {
			var bmp = hexes.pop();
			if (bmp.parent == artwork) {
				artwork.removeChild(bmp);
			}
		}
		
		var hexes = currentModel.hexes;
		for (hex in hexes) {
			drawHex(hex);
			drawThingsInHex(hex);
		}
		
		viewLayer.x = MAP_WIDTH / 2;
		viewLayer.y = MAP_HEIGHT / 2;
		
		artwork.addChild(mapImage);
		artwork.addChild(viewLayer);
		viewLayer.addChild(hexLayer);
		viewLayer.addChild(thingsLayer);
		viewLayer.addChild(highlightImage.artwork);
		
		EventBus.mapViewChanged.dispatch(this);
	}
	
	inline function drawHex(hex:HexTile, ?container:DisplayObject):Void
	{
		var hex_x = hex.x();
		var hex_y = hex.y();
		var x = (hexImage.width * hex_x);
		var y = (hexImage.height * hex_y);

		if (container == null) {
			var bitmap:Bitmap = (unusedThings.length > 0) ? unusedThings.pop() : new Bitmap();
			bitmap.bitmapData = hexImage;
			hexLayer.addChild(bitmap);
			bitmapsInUse.push(bitmap);
			
			bitmap.x = x - (bitmap.width / 2);
			bitmap.y = y - (bitmap.height / 2);
		}
		else
		{
			container.x = x;
			container.y = y;
		}
	}
	
	inline function drawThingsInHex(hex:HexTile):Void
	{
		var things = hex.listContents();
		for (thing in things)
		{
			// make an image for the thing
			var bitmap = (unusedThings.length > 0) ? unusedThings.pop() : new Bitmap();
			bitmap.bitmapData = thing.getIcon();
			safeAddAt(thingsLayer, bitmap, thing.getDepth());
			bitmapsInUse.push(bitmap);
			
			// recalculate position of hex
			var hex_x = hex.x();
			var hex_y = hex.y();
			var x = (hexImage.width * hex_x) - (hexImage.width / 2);
			var y = (hexImage.height * hex_y) - (hexImage.height / 2);
			
			// center thing on hex
			bitmap.x = x + (hexImage.width / 2) - (bitmap.width / 2);
			bitmap.y = y + (hexImage.height / 2) - (bitmap.height / 2);
		}
	}
	
	function safeAddAt(container:DisplayObjectContainer, item:DisplayObject, depth:Int):Void
	{
		var depth:Int = cast Math.min(depth, container.numChildren);
		container.addChildAt(item, depth);
	}
	
}