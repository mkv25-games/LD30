package net.mkv25.game.ui;

import flash.display.BitmapData;
import flash.display.Graphics;
import net.mkv25.base.core.Image.ImageRegion;
import net.mkv25.base.ui.BaseUI;
import net.mkv25.game.models.MapModel;
import net.mkv25.game.provider.HexProvider;

class MapUI extends BaseUI
{
	static var MAP_WIDTH:Int = 500;
	static var MAP_HEIGHT:Int = 500;
	
	private var model:MapModel;
	private var hexImage:BitmapData;
	
	public function new() 
	{
		super();
		
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
		
		graphics.beginBitmapFill(hexImage);
		graphics.drawRect(100, 100, hexImage.width, hexImage.height);
		graphics.endFill();
	}
	
	function onModelChanged(model:MapModel)
	{
		redraw();
	}
	
}