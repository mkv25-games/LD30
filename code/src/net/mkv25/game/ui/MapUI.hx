package net.mkv25.game.ui;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Graphics;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.geom.Matrix;
import haxe.ds.StringMap;
import haxe.Timer;
import net.mkv25.base.core.Image.ImageRegion;
import net.mkv25.base.core.Recycler;
import net.mkv25.base.core.TimeProfile;
import net.mkv25.base.ui.AnimationUI;
import net.mkv25.base.ui.BaseUI;
import net.mkv25.base.ui.BitmapUI;
import net.mkv25.base.ui.IconButtonUI;
import net.mkv25.base.ui.TextUI;
import net.mkv25.game.audio.SoundEffects;
import net.mkv25.game.event.EventBus;
import net.mkv25.game.models.CombatModel;
import net.mkv25.game.models.HexTile;
import net.mkv25.game.models.IMapThing;
import net.mkv25.game.models.MapModel;
import net.mkv25.game.models.MapUnit;
import net.mkv25.game.models.MovementModel;
import net.mkv25.game.models.PlayableCard;
import net.mkv25.game.models.PlayerModel;
import net.mkv25.game.models.UnitList;
import net.mkv25.game.provider.HexProvider;
import net.mkv25.game.provider.IconProvider;
import openfl.Assets;
import openfl.geom.Point;
import openfl.text.TextFormatAlign;

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
	
	var movementFocusHexes:StringMap<HexTile>;
	var movementFocusUnit:MapUnit;
	
	var mapImage:Bitmap;
	
	var viewLayer:Sprite;
	var planetLayer:Sprite;
	var hexLayer:Sprite;
	var movementLayer:Sprite;
	var lineLayer:Sprite;
	var unitLayer:Sprite;
	var explosion:ExplosionAnimationUI;
	
	var spaceViewButton:IconButtonUI;
	var worldViewButton:IconButtonUI;
	
	var bitmapRecycler:Recycler<Bitmap>;
	var indicatorRecycler:Recycler<UnitCountIndicatorUI>;
	
	var hexInfoText:TextUI;
	
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
		
		movementFocusHexes = null;
		movementFocusUnit = null;
		
		mapImage = new Bitmap();
		
		viewLayer = new Sprite();
		viewLayer.mouseChildren = false;
		
		planetLayer = new Sprite();
		hexLayer = new Sprite();
		movementLayer = new Sprite();
		lineLayer = new Sprite();
		unitLayer = new Sprite();
		
		explosion = new ExplosionAnimationUI();
		explosion.complete.add(function(?model) { explosion.hide(); } );
		
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
		
		hexInfoText = cast TextUI.makeFor("0, 0", 0xFFFFFF).fontSize(16).align(TextFormatAlign.RIGHT).size(200, 40).move(MapUI.MAP_WIDTH - 205, 5);
		hexInfoText.artwork.mouseEnabled = hexInfoText.artwork.mouseChildren = false; 
		
		#if !debug
			hexInfoText.hide();
		#end
		
		artwork.addChild(mapImage);
		artwork.addChild(viewLayer);
		viewLayer.addChild(planetLayer);
		viewLayer.addChild(hexLayer);
		viewLayer.addChild(movementLayer);
		viewLayer.addChild(lineLayer);
		viewLayer.addChild(unitLayer);
		viewLayer.addChild(markedImage.artwork);
		viewLayer.addChild(highlightImage.artwork);
		viewLayer.addChild(explosion.artwork);
		artwork.addChild(spaceViewButton.artwork);
		artwork.addChild(worldViewButton.artwork);
		artwork.addChild(hexInfoText.artwork);
		
		EventBus.mapRequiresRedraw.add(handleMapRequiresRedraw);
		EventBus.combat_occuredAtLocation.add(displayExplosionAtHex);
	}
	
	public function setupMap(model:MapModel)
	{
		this.currentModel = model;
		
		mapImage.bitmapData = model.getBackground();
		
		#if !mobile
			viewLayer.addEventListener(MouseEvent.MOUSE_MOVE, moveHexCursor);
		#end
		
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
		TimeProfile.logEvent("MapUI:handleMapRequiresRedraw");
		
		redraw();
	}
	
	function hexUnderMouse(mouseEvent:MouseEvent):HexTile
	{
		TimeProfile.logEvent("MapUI:hexUnderMouse");
		
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
		
		#if mobile
			markSelectedHex(mouseEvent);
		#end
	}
	
	function markSelectedHex(mouseEvent:MouseEvent):Void
	{
		TimeProfile.logEvent("MapUI:markSelectedHex");
		
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
			hexInfoText.setText(tile.q + ", " + tile.r);
		}
		else
		{
			markedHex.r = -100;
			markedHex.q = -100;
			markedHex.map = Index.activeGame.space;
			hexInfoText.setText("No hex");
		}
		
		updateWorldViewButton();
	}
	
	function displayExplosionAtHex(hex:HexTile):Void
	{
		explosion.drawFirst();
		
		var hex_x = hex.x();
		var hex_y = hex.y();
		var x = (hexImage.width * hex_x);
		var y = (hexImage.height * hex_y);
		
		displayExplosionAt(x, y);
	}
	
	function displayExplosionAt(x:Float, y:Float):Void
	{
		explosion.artwork.x = x - (explosion.artwork.width / 2);
		explosion.artwork.y = y - (explosion.artwork.height / 2);
		
		explosion.show();
		explosion.playOnce();
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
		TimeProfile.logEvent("MapUI:redraw");
		
		// reset all vector lines
		lineLayer.graphics.clear();
		
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
		if (movementFocusHexes != null && movementFocusUnit != null)
		{
			highlightValidMovementFor(movementFocusHexes, movementFocusUnit);
		}
		
		// position view layer
		viewLayer.x = MAP_WIDTH / 2;
		viewLayer.y = MAP_HEIGHT / 2;
		
		updateButtons();
		
		EventBus.mapViewChanged.dispatch(this);
	}
	
	function highlightValidMovementFor(hexes:StringMap<HexTile>, unit:MapUnit)
	{
		TimeProfile.logEvent("MapUI:highlightValidMovementFor");
		
		if (hexes == null || unit == null)
		{
			return;
		}
		
		for (hex in hexes)
		{
			if (hex.map == currentModel)
			{
				var image:BitmapData = (CombatModel.containsEnemyCombatants(Index.activeGame.activePlayer, hex)) ? HexProvider.CONTESTED_HEX : HexProvider.MOVEMENT_HEX;
				drawHex(hex, null, movementLayer, image);
			}
		}
			
		movementLayer.visible = true;
	}
	
	/// Inline Helper Methods ///
	
	inline function drawHex(hex:HexTile, ?container:DisplayObject, ?layer:Sprite, ?image:BitmapData):Void
	{
		TimeProfile.logEvent("MapUI:drawHex");
		
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
		TimeProfile.logEvent("MapUI:drawThingsInHex");
		
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
			// draw planets on space map
			if (Std.is(thing, MapModel))
			{
				var map:MapModel = cast thing;
				
				// make an image for the thing
				var bitmap = bitmapRecycler.get();
				bitmap.bitmapData = thing.getIcon();
				safeAddAt(planetLayer, bitmap, thing.getDepth());
				
				// center thing on hex
				bitmap.x = x + (hexImage.width / 2) - (bitmap.width / 2);
				bitmap.y = y + (hexImage.height / 2) - (bitmap.height / 2);
				
				// draw planet owner marker
				if (map.owner != null)
				{
					var marker = bitmapRecycler.get();
					marker.bitmapData = IconProvider.getPlayerIconFor(map.owner, 9);
					safeAddAt(unitLayer, marker, 1);
					
					// place marker at top left of hex
					marker.x = x + (hexImage.width * 0.25) - (marker.width / 2);
					marker.y = y + (hexImage.height * 0.0) - (marker.height / 2);
				}
			}
			
			// record owner
			if (Std.is(thing, MapUnit))
			{
				var unit:MapUnit = cast thing;
				commonOwner = unit.owner;
				unitCount++;
				
				drawConnectionsFor(unit);
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
				y + 1
			);
		}
	}
	
	var p1:Point = new Point();
	var p2:Point = new Point();
	function drawConnectionsFor(unit:MapUnit):Void
	{
		TimeProfile.logEvent("MapUI:drawConnectionsFor");
		
		if (!unit.hasConnections())
		{
			return;
		}
		
		var graphics:Graphics = lineLayer.graphics;
		
		var connections:Array<MapUnit> = unit.listConnections().list();
		for (connection in connections)
		{
			var start:HexTile = unit.lastKnownLocation;
			var end:HexTile = connection.lastKnownLocation;
			if (start == null || end == null)
			{
				// do nothing
			}
			else if (end.map == currentModel)
			{
				// work out p1 and p2
				p1.x = (hexImage.width * start.x());
				p1.y = (hexImage.height * start.y());
				
				p2.x = (hexImage.width * end.x());
				p2.y = (hexImage.height * end.y());
				
				// draw line to target
				graphics.lineStyle(6, 0xFFFFFF, 0.3);
				graphics.moveTo(p1.x, p1.y);
				graphics.lineTo(p2.x, p2.y);
				
			}
			else if(start.map == Index.activeGame.space)
			{
				// draw line to planet in space view
				
				// work out p1 and p2
				p1.x = (hexImage.width * start.x());
				p1.y = (hexImage.height * start.y());
				
				p2.x = (hexImage.width * end.map.getSpaceHex().x());
				p2.y = (hexImage.height * end.map.getSpaceHex().y());
				
				// draw line to target
				graphics.lineStyle(6, 0xFFFFFF, 0.3);
				graphics.moveTo(p1.x, p1.y);
				graphics.lineTo(p2.x, p2.y);
				
			}
			else if (start.map.isWorld())
			{
				// draw line to dot?
				
				// work out p1 and p2
				p1.x = (hexImage.width * start.x());
				p1.y = (hexImage.height * start.y());
				
				p2.x = (hexImage.width * start.x());
				p2.y = (hexImage.height * start.y()) - (hexImage.height / 2);
				
				// draw line to target
				graphics.lineStyle(6, 0xFFFFFF, 0.3);
				graphics.moveTo(p1.x, p1.y);
				graphics.lineTo(p2.x, p2.y);
			}
		}
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
	
	/// Public methods ///
	
	public function enableMovementOverlayFor(hexes:StringMap<HexTile>, unit:MapUnit):Void
	{
		this.movementFocusUnit = unit;
		this.movementFocusHexes = hexes;
		
		redraw();
	}
	
	public function disableMovementOverlay():Void
	{
		this.movementFocusHexes = null;
		this.movementFocusUnit = null;
		
		movementLayer.visible = false;
	}
	
}