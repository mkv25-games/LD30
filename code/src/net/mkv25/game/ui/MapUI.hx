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
import net.mkv25.base.core.Recycler;
import net.mkv25.base.ui.BaseUI;
import net.mkv25.base.ui.BitmapUI;
import net.mkv25.base.ui.IconButtonUI;
import net.mkv25.game.audio.SoundEffects;
import net.mkv25.game.event.EventBus;
import net.mkv25.game.models.HexTile;
import net.mkv25.game.models.IMapThing;
import net.mkv25.game.models.MapModel;
import net.mkv25.game.models.MapUnit;
import net.mkv25.game.models.MovementModel;
import net.mkv25.game.models.PlayableCard;
import net.mkv25.game.models.PlayerModel;
import net.mkv25.game.provider.HexProvider;
import net.mkv25.game.provider.IconProvider;
import openfl.Assets;

class MapUI extends BaseUI
{
	public static var MAP_WIDTH:Int = 500;
	public static var MAP_HEIGHT:Int = 500;
	
	public var currentModel:MapModel;
	
	var hexImage:BitmapData;
	
	var cursorHex:HexTile;
	var highlightImage:BitmapUI;
	
	var markedHex:HexTile;
	var markedImage:BitmapUI;
	
	var movementFocusHex:HexTile;
	var movementFocusUnit:MapUnit;
	var movementFocusDistance:Int;
	
	var mapImage:Bitmap;
	
	var viewLayer:Sprite;
	var planetLayer:Sprite;
	var hexLayer:Sprite;
	var movementLayer:Sprite;
	var unitLayer:Sprite;
	
	var spaceViewButton:IconButtonUI;
	var worldViewButton:IconButtonUI;
	
	var bitmapRecycler:Recycler<Bitmap>;
	var indicatorRecycler:Recycler<UnitCountIndicatorUI>;
	
	public function new() 
	{
		super();
		
		HexProvider.setup();
		hexImage = HexProvider.EMPTY_HEX;
		
		cursorHex = new HexTile();
		highlightImage = new BitmapUI();
		highlightImage.artwork.mouseEnabled = highlightImage.artwork.mouseChildren = false;
		
		markedHex = new HexTile();
		markedImage = new BitmapUI();
		markedImage.artwork.mouseEnabled = markedImage.artwork.mouseChildren = false;
		
		movementFocusHex = null;
		movementFocusUnit = null;
		movementFocusDistance = 0;
		
		mapImage = new Bitmap();
		
		viewLayer = new Sprite();
		viewLayer.mouseChildren = false;
		
		planetLayer = new Sprite();
		hexLayer = new Sprite();
		movementLayer = new Sprite();
		unitLayer = new Sprite();
		
		spaceViewButton = new IconButtonUI();
		spaceViewButton.setup("img/icon-starmap.png", switchToSpaceMap);
		spaceViewButton.move(40, 40);
		spaceViewButton.hide();
		
		worldViewButton = new IconButtonUI();
		worldViewButton.setup("img/icon-world.png", switchToWorldMap);
		worldViewButton.move(40, 40);
		worldViewButton.hide();
		
		bitmapRecycler = new Recycler<Bitmap>(Bitmap);
		indicatorRecycler = new Recycler<UnitCountIndicatorUI>(UnitCountIndicatorUI);
		
		EventBus.mapRequiresRedraw.add(handleMapRequiresRedraw);
	}
	
	public function setupMap(model:MapModel)
	{
		this.currentModel = model;
		
		mapImage.bitmapData = model.getBackground();
		
		viewLayer.addEventListener(MouseEvent.MOUSE_MOVE, moveHexCursor);
		viewLayer.addEventListener(MouseEvent.MOUSE_DOWN, markSelectedHex);
		
		(markedHex.map == currentModel) ? markedImage.show() : markedImage.hide();
		
		if (currentModel.isWorld())
		{
			spaceViewButton.show();
			worldViewButton.hide();
		}
		else
		{
			worldViewButton.show();
			spaceViewButton.hide();
			
			updateWorldViewButton();
		}
		
		redraw();
	}
	
	/// Internal Draw Methods ///
	
	function handleMapRequiresRedraw(?model):Void
	{
		redraw();
	}
	
	function hexUnderMouse(mouseEvent:MouseEvent):HexTile
	{
		if (mouseEvent.target != viewLayer)
		{
			return null;
		}
		
		var hex_x = mouseEvent.localX / hexImage.width;
		var hex_y = mouseEvent.localY /  hexImage.height;
		
		var qr = HexTile.xy2qr(hex_x, hex_y);
		
		var tile:HexTile = currentModel.getHexTile(qr[0], qr[1]);
		
		return tile;
	}
	
	function moveHexCursor(mouseEvent:MouseEvent):Void
	{
		if (mouseEvent.target != viewLayer)
		{
			return;
		}
		
		var tile:HexTile = hexUnderMouse(mouseEvent);
		if (tile != null)
		{
			cursorHex.q = tile.q;
			cursorHex.r = tile.r;
			highlightImage.setBitmapData(HexProvider.CURSOR_HEX);
			drawHex(cursorHex, highlightImage.artwork);
			highlightImage.show();
			
			var contents = tile.listContents();
		}
		else
		{
			highlightImage.hide();
		}
	}
	
	function markSelectedHex(mouseEvent:MouseEvent):Void
	{
		var tile:HexTile = hexUnderMouse(mouseEvent);
		if (tile != null)
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
		else
		{
			markedHex.r = -100;
			markedHex.q = -100;
			markedHex.map = Index.activeGame.space;
		}
		
		updateWorldViewButton();
	}
	
	function updateWorldViewButton():Void
	{
		if (markedHex == null || markedHex.map == null)
		{
			worldViewButton.disable();
			return;
		}
		
		var tile:HexTile = markedHex.map.getHexTile(markedHex.q, markedHex.r);
		if (tile != null && tile.containsWorld())
		{
			worldViewButton.enable();
		}
		else
		{
			worldViewButton.disable();
		}
	}
	
	function redraw()
	{
		var graphics:Graphics = artwork.graphics;
		graphics.clear();
		
		// recycle all graphics in use
		bitmapRecycler.recycleAll();
		indicatorRecycler.recycleAll();
		
		// draw all hexes currently in view
		var hexes = currentModel.hexes;
		for (hex in hexes) {
			drawHex(hex);
			drawThingsInHex(hex);
		}
		
		// check if movement options should be rendered
		if (movementFocusHex != null && movementFocusUnit != null && movementFocusDistance > 0)
		{
			highlightValidMovementFor(movementFocusHex, movementFocusUnit, movementFocusDistance);
		}
		
		// position view layer
		viewLayer.x = MAP_WIDTH / 2;
		viewLayer.y = MAP_HEIGHT / 2;
		
		// reset the order of the layers
		artwork.addChild(mapImage);
		artwork.addChild(viewLayer);
		viewLayer.addChild(planetLayer);
		viewLayer.addChild(hexLayer);
		viewLayer.addChild(movementLayer);
		viewLayer.addChild(unitLayer);
		viewLayer.addChild(markedImage.artwork);
		viewLayer.addChild(highlightImage.artwork);
		artwork.addChild(spaceViewButton.artwork);
		artwork.addChild(worldViewButton.artwork);
		
		updateButtons();
		
		EventBus.mapViewChanged.dispatch(this);
	}
	
	function highlightValidMovementFor(location:HexTile, unit:MapUnit, distance:Int)
	{
		if (location.map == null || unit == null)
		{
			return;
		}
		
		var hexes = MovementModel.getValidMovementDestinationsFor(location, unit, distance);
		for (hex in hexes)
		{
			if (hex.map == currentModel)
			{
				drawHex(hex, null, movementLayer, HexProvider.MOVEMENT_HEX);
			}
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
			
			var bitmap:Bitmap = bitmapRecycler.get();
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
	
	function getBitmapDataForHex(hex:HexTile):BitmapData
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
	
	function drawThingsInHex(hex:HexTile):Void
	{
		var things = hex.listContents();
		var commonOwner:PlayerModel = null;
		var unitCount:Int = 0;
		
		// recalculate position of hex
		var hex_x = hex.x();
		var hex_y = hex.y();
		var x = (hexImage.width * hex_x) - (hexImage.width / 2);
		var y = (hexImage.height * hex_y) - (hexImage.height / 2);
			
		// draw some things
		for (thing in things)
		{
			if (Std.is(thing, MapModel))
			{
				// make an image for the thing
				var bitmap = bitmapRecycler.get();
				bitmap.bitmapData = thing.getIcon();
				safeAddAt(planetLayer, bitmap, thing.getDepth());
				
				// center thing on hex
				bitmap.x = x + (hexImage.width / 2) - (bitmap.width / 2);
				bitmap.y = y + (hexImage.height / 2) - (bitmap.height / 2);
			}
			
			// record owner
			if (Std.is(thing, MapUnit))
			{
				var unit:MapUnit = cast thing;
				commonOwner = unit.owner;
				unitCount++;
			}
		}
		
		// draw highest strength unit
		var units = hex.listUnits();
		var unit = units.getHighestStrengthUnit();
		if (unit != null)
		{
			// make an image for the unit
			var bitmap = bitmapRecycler.get();
			bitmap.bitmapData = unit.getIcon();
			safeAddAt(unitLayer, bitmap, unit.getDepth());
			
			// center thing on hex
			bitmap.x = x + (hexImage.width / 2) - (bitmap.width / 2);
			bitmap.y = y + (hexImage.height / 2) - (bitmap.height / 2);
		}
		
		// draw indicator
		if (commonOwner != null && unitCount > 1)
		{
			var indicator = indicatorRecycler.get();
			indicator.setup(commonOwner, unitCount + "");
			safeAddAt(unitLayer, indicator.artwork, 20);
			
			// place indicator on top corner of hex
			indicator.move(
				x + (hexImage.width * 0.75),
				y
			);
		}
	}
	
	/// Public methods ///
	
	public function enableMovementOverlayFor(location:HexTile, unit:MapUnit, distance:Int):Void
	{
		// copy location details
		this.movementFocusHex = new HexTile();
		this.movementFocusHex.q = location.q;
		this.movementFocusHex.r = location.r;
		this.movementFocusHex.map = location.map;
		
		this.movementFocusUnit = unit;
		this.movementFocusDistance = distance;
		
		redraw();
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
		SoundEffects.playBloop();
		
		setupMap(Index.activeGame.space);
	}
	
	function switchToWorldMap(?model)
	{
		var location:HexTile = markedHex.map.getHexTile(markedHex.q, markedHex.r);
		if (location.containsWorld())
		{
			SoundEffects.playBloop();
			
			var world:MapModel = MovementModel.getWorldFrom(location);
			
			setupMap(world);
		}
	}
	
}