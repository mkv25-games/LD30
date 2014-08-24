package net.mkv25.game.ui;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Graphics;
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
	
	public function new() 
	{
		super();
		
		hexes = new Array<Bitmap>();
		
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
			drawHex(graphics, hex);
		}
		
		hexes.get("0,0").bitmap.bitmapData = HexProvider.FILLED_HEX;
	}
	
	inline function drawHex(graphics:Graphics, hex:HexTile):Void
	{
		var view_x = MAP_WIDTH / 2;
		var view_y = MAP_HEIGHT / 2;
		
		var hex_x = hex.x();
		var hex_y = hex.y();
		var x = view_x + hexImage.width * hex_x;
		var y = view_y + hexImage.height * hex_y;
		
		/*
		var matrix:Matrix = new Matrix(0, 0, 0, 0, -x, -y);
		graphics.beginBitmapFill(hexImage, matrix, true, false);
		graphics.drawRect(x, y, hexImage.width, hexImage.height);
		graphics.endFill();
		*/
		
		var bmp = new Bitmap(hexImage);
		bmp.x = x;
		bmp.y = y;
		hex.bitmap = bmp;
		artwork.addChild(bmp);
	}
	
	function onModelChanged(model:MapModel)
	{
		redraw();
	}
	
}