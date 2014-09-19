package net.mkv25.base.ui;

import net.mkv25.base.core.Recycler;
import net.mkv25.base.core.TimeProfile;
import openfl.display.Sprite;
import openfl.events.Event;

class TimeProfileUI extends BaseUI
{
	var recycler:Recycler<TimeProfileRowUI>;
	
	var padding:Int = 5;
	var rows:Sprite;
	var box:Sprite;
	
	public function new() 
	{
		super();
		
		recycler = new Recycler<TimeProfileRowUI>(TimeProfileRowUI);
		
		rows = new Sprite();
		box = new Sprite();
		
		artwork.addChild(box);
		artwork.addChild(rows);
		
		artwork.mouseChildren = artwork.mouseEnabled = false;
	}
	
	public function start():Void
	{
		artwork.addEventListener(Event.ENTER_FRAME, handle_onEnterFrame);
		
		draw();
	}
	
	public function stop():Void
	{
		artwork.removeEventListener(Event.ENTER_FRAME, handle_onEnterFrame);
	}
	
	function handle_onEnterFrame(?model):Void
	{
		draw();
	}
	
	public function draw()
	{
		recycler.recycleAll();
		
		var records = TimeProfile.records;
		var n:Int = 0;
		for (record in records)
		{
			var recordRow:TimeProfileRowUI = cast recycler.get();
			recordRow.setup(record);
			recordRow.move(0, n * (recordRow.artwork.height + 2));
			rows.addChild(recordRow.artwork);
			
			n++;
		}
		
		rows.x = padding;
		rows.y = padding;
		
		var graphics = box.graphics;
		graphics.clear();
		graphics.beginFill(0x000000, 0.4);
		graphics.drawRect(0, 0, rows.width + padding * 2, rows.height + padding * 2);
		graphics.endFill();
		
		artwork.alpha = 0.5;
	}
	
}

class TimeProfileRowUI extends BaseUI
{
	var label:TextUI;
	var values:TextUI;
	var graph:Sprite;
	
	public function new()
	{
		super();
		
		label = cast TextUI.makeFor("Profile: ", 0xFFFFFF).fontSize(14).alignLeft().size(200, 20).addTo(artwork);
		values = cast TextUI.makeFor("0", 0xFFFFFF).fontSize(14).alignLeft().size(200, 20).move(200, 0).addTo(artwork);
		graph = new Sprite();
		graph.x = label.artwork.width;
		
		artwork.addChild(graph);
	}
	
	public function setup(record:TimeProfileRecord):Void
	{
		label.setText(record.key);
		values.setText(record.lastCount + " Δ " + record.lastFive() + " Σ " + record.total);
	}
}