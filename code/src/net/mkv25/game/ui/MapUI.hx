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
import net.mkv25.base.ui.IconButtonUI;
import net.mkv25.game.event.EventBus;
import net.mkv25.game.models.HexTile;
import net.mkv25.game.models.IMapThing;
import net.mkv25.game.models.MapModel;
import net.mkv25.game.models.MapUnit;
import net.mkv25.game.provider.HexProvider;
import openfl.Assets;

class MapUI extends BaseUI
{
	public static var MAP_WIDTH:Int = 500;
	public static var MAP_HEIGHT:Int = 500;
	
	public var currentModel:MapModel;
	
	var hexImage:BitmapData;
	
	var highlightedHex:HexTile;
	var highlightImage:BitmapUI;
	
	var markedHex:HexTile;
	var markedImage:BitmapUI;
	
	var movementFocusHex:HexTile;
	
	var mapImage:Bitmap;
	var viewLayer:Sprite;
	var hexLayer:Sprite;
	var movementLayer:Sprite;
	var thingsLayer:Sprite;
	var spaceViewButton:IconButtonUI;
	
	var bitmapsInUse:Array<Bitmap>;
	var unusedThings:Array<Bitmap>;
	var recycler:Sprite;
	
	public function new() 
	{
		super();
		
		HexProvider.setup();
		hexImage = HexProvider.EMPTY_HEX;
		
		highlightedHex = new HexTile();
		highlightImage = new BitmapUI();
		highlightImage.artwork.mouseEnabled = highlightImage.artwork.mouseChildren = false;
		
		markedHex = new HexTile();
		markedImage = new BitmapUI();
		markedImage.artwork.mouseEnabled = markedImage.artwork.mouseChildren = false;
		
		movementFocusHex = new HexTile();
		
		mapImage = new Bitmap();
		viewLayer = new Sprite();
		hexLayer = new Sprite();
		movementLayer = new Sprite();
		thingsLayer = new Sprite();
		
		spaceViewButton = new IconButtonUI();
		spaceViewButton.setup("img/icon-back.png", switchToSpaceMap);
		spaceViewButton.move(40, 40);
		
		bitmapsInUse = new Array<Bitmap>();
		unusedThings = new Array<Bitmap>();
		recycler = new Sprite();
		
		EventBus.mapRequiresRedraw.add(handleMapRequiresRedraw);
	}
	
	public function setupMap(model:MapModel)
	{
		this.currentModel = model;
		
		mapImage.bitmapData = model.background;
		
		viewLayer.addEventListener(MouseEvent.MOUSE_MOVE, highlightHexTile, false, 0, true);
		viewLayer.addEventListener(MouseEvent.MOUSE_DOWN, markSelectedHex, false, 0, true);
		
		// reset marked hex
		markedHex.q = -9001;
		markedHex.r = -9001;
		markedHex.map = null;
		markedImage.hide();
		
		EventBus.mapMarkerRemovedFromMap.dispatch(markedHex);
		
		redraw();
	}
	
	/// Internal Draw Methods ///
	
	function handleMapRequiresRedraw(?model):Void
	{
		redraw();
	}
	
	function hexUnderMouse(mouseEvent:MouseEvent):HexTile {
		var hex_x = mouseEvent.localX / hexImage.width;
		var hex_y = mouseEvent.localY /  hexImage.height;
		
		var qr = HexTile.xy2qr(hex_x, hex_y);
		
		var tile:HexTile = currentModel.getHexTile(qr[0], qr[1]);
		
		return tile;
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
	
	function markSelectedHex(mouseEvent:MouseEvent):Void
	{
		var tile:HexTile = hexUnderMouse(mouseEvent);
		if (tile != null) {
			var contents = tile.listContents();
			
			// marking the same hex for the second time
			if (markedHex.map == tile.map && markedHex.r == tile.r && markedHex.q == tile.q)
			{
				for (thing in contents) {
					if (Std.is(thing, MapModel))
					{
						var world:MapModel = cast thing;
						setupMap(world);
					}
				}
			}
			else
			{
				// selecting a new hex
				markedHex.r = tile.r;
				markedHex.q = tile.q;
				markedHex.map = tile.map;
				markedImage.setBitmapData(HexProvider.MARKED_HEX);
				drawHex(markedHex, markedImage.artwork);
				markedImage.show();
				markedImage.zoomIn();
				
				EventBus.mapMarkerPlacedOnMap.dispatch(markedHex);
				
				highlightImage.popIn();
			}
		}
	}
	
	function redraw() {
		var graphics:Graphics = artwork.graphics;
		graphics.clear();
		
		// recycle all bitmaps in use
		while (bitmapsInUse.length > 0) {
			var thing = bitmapsInUse.pop();
			recycler.addChild(thing);
			unusedThings.push(thing);
		}
		
		// draw all hexes currently in view
		var hexes = currentModel.hexes;
		for (hex in hexes) {
			drawHex(hex);
			drawThingsInHex(hex);
		}
		
		// check if movement options should be rendered
		if (movementFocusHex != null)
		{
			highlightValidMovementFrom(movementFocusHex);
		}
		
		// position view layer
		viewLayer.x = MAP_WIDTH / 2;
		viewLayer.y = MAP_HEIGHT / 2;
		
		// reset the order of the layers
		artwork.addChild(mapImage);
		artwork.addChild(viewLayer);
		viewLayer.addChild(hexLayer);
		viewLayer.addChild(movementLayer);
		viewLayer.addChild(thingsLayer);
		viewLayer.addChild(markedImage.artwork);
		viewLayer.addChild(highlightImage.artwork);
		artwork.addChild(spaceViewButton.artwork);
		
		updateButtons();
		
		EventBus.mapViewChanged.dispatch(this);
	}
	
	function highlightValidMovementFrom(location:HexTile)
	{
		if (location.map == null)
		{
			return;
		}
		
		if (location.map == currentModel)
		{
			// Highlight tiles from the perspective of neighbouring tiles on the same map
			var hexes:Array<HexTile> = location.getNeighbours();
			for (hex in hexes)
			{
				drawHex(hex, null, movementLayer, HexProvider.MOVEMENT_HEX);
			}
		}
		else if(location.map.spaceHex != null && currentModel == Index.activeGame.space)
		{
			// Highlight tiles from the perspective of a world accessing space
			drawHex(location.map.spaceHex, null, movementLayer, HexProvider.MOVEMENT_HEX);
		}
			
		movementLayer.visible = true;
	}
	
	/// Inline Helper Methods ///
	
	inline function drawHex(hex:HexTile, ?container:DisplayObject, ?layer:Sprite, ?image:BitmapData):Void
	{
		var hex_x = hex.x();
		var hex_y = hex.y();
		var x = (hexImage.width * hex_x);
		var y = (hexImage.height * hex_y);

		if (container == null)
		{
			layer = (layer == null) ? hexLayer : layer;
			image = (image == null) ? getBitmapDataForHex(hex) : image;
			
			var bitmap:Bitmap = (unusedThings.length > 0) ? unusedThings.pop() : new Bitmap();
			bitmapsInUse.push(bitmap);
			layer.addChild(bitmap);
			
			bitmap.bitmapData = image;
			
			bitmap.x = x - (bitmap.width / 2);
			bitmap.y = y - (bitmap.height / 2);
		}
		else
		{
			container.x = x;
			container.y = y;
		}
	}
	
	inline function getBitmapDataForHex(hex:HexTile):BitmapData
	{
		var bitmap:BitmapData;
		if (hex.contested) {
			bitmap = HexProvider.CONTESTED_HEX;
		}
		else
		{
			bitmap = (hex.territoryOwner == null) ? HexProvider.EMPTY_HEX : HexProvider.PLAYER_TERRITORY_HEXES[hex.territoryOwner.playerNumberZeroBased];
		}
		
		return bitmap;
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
	
	/// Public methods ///
	
	public function enableMovementOverlayFrom(location:HexTile):Void
	{
		// copy location details
		this.movementFocusHex.q = location.q;
		this.movementFocusHex.r = location.r;
		this.movementFocusHex.map = location.map;
		
		highlightValidMovementFrom(location);
	}
	
	public function disableMovementOverlay():Void
	{
		this.movementFocusHex = null;		
		
		movementLayer.visible = false;
	}
	
	function safeAddAt(container:DisplayObjectContainer, item:DisplayObject, depth:Int):Void
	{
		var depth:Int = cast Math.min(depth, container.numChildren);
		container.addChildAt(item, depth);
	}
	
	function updateButtons(?model)
	{
		if (currentModel != Index.activeGame.space)
		{
			spaceViewButton.show();
		}
		else
		{
			spaceViewButton.hide();
		}
	}
	
	function switchToSpaceMap(?model)
	{
		var bloopSfx = Assets.getSound("sounds/bloop.wav");
		bloopSfx.play();
		
		setupMap(Index.activeGame.space);
	}
	
}