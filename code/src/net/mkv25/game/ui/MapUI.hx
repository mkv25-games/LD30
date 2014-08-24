package net.mkv25.game.ui;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Graphics;
import flash.events.MouseEvent;
import flash.geom.Matrix;
import net.mkv25.base.core.Image.ImageRegion;
import net.mkv25.base.ui.BaseUI;
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
	
	public function new() 
	{
		super();
		
		hexes = new Array<Bitmap>();
		highlightedHex = new HexTile();
		highlightedHex.bitmap = new Bitmap();
		
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
		
		artwork.addEventListener(MouseEvent.MOUSE_MOVE, checkHexTile, false, 0, true);
	}
	
	function checkHexTile(mouseEvent:MouseEvent):Void
	{
		var view_x = MAP_WIDTH / 2;
		var view_y = MAP_HEIGHT / 2;
		
		var hex_x = (mouseEvent.localX - view_x) / hexImage.width;
		var hex_y = (mouseEvent.localY - view_y) /  hexImage.height;
		
		var qr = HexTile.xy2qr(hex_x, hex_y);
		
		var tile:HexTile = model.getHexTile(qr[0], qr[1]);
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
	
	function redraw() {
		var graphics:Graphics = artwork.graphics;
		graphics.clear();
		
		while (hexes.length > 0) {
			var bmp = hexes.pop();
			if (bmp.parent == artwork) {
				artwork.removeChild(bmp);
			}
		}
		
		var hexes = model.hexes;
		for (hex in hexes) {
			drawHex(hex);
		}
		
		hexes.get("0,0").bitmap.bitmapData = HexProvider.FILLED_HEX;
		
		artwork.addChild(highlightedHex.bitmap);
	}
	
	inline function drawHex(hex:HexTile):Void
	{
		var view_x = MAP_WIDTH / 2;
		var view_y = MAP_HEIGHT / 2;
		
		var hex_x = hex.x();
		var hex_y = hex.y();
		var x = view_x + (hexImage.width * hex_x) - (hexImage.width / 2);
		var y = view_y + (hexImage.height * hex_y) - (hexImage.height / 2);

		if (hex.bitmap == null)
		{
			var bmp = new Bitmap(hexImage);
			hex.bitmap = bmp;
		}
		
		hex.bitmap.x = x;
		hex.bitmap.y = y;
		artwork.addChild(hex.bitmap);
	}
	
	function onModelChanged(model:MapModel)
	{
		redraw();
	}
	
}