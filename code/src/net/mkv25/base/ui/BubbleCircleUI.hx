package net.mkv25.base.ui;

import motion.Actuate;
import motion.actuators.GenericActuator.IGenericActuator;
import motion.easing.Elastic;
import motion.easing.Quad;

class BubbleCircleUI extends BaseUI
{
	var icon:BitmapUI;
	var lastFillColor:UInt = 0x009900;
	
	var tweenSize:Float = 1;
	var tweenAngle:Float = 0;
	var tweenRadius:Float = 1; 
	
	public function new() 
	{
		super();
		
	}
	
	public function setIcon(path:String)
	{
		if (icon == null)
		{
			icon = new BitmapUI();
		}
		
		icon.setup(path);
		artwork.addChild(icon.artwork);
	}
	
	public function draw(radius:Float, fillColor:Int = -1, borderColor:Int = 0xFFFFFF)
	{
		if (fillColor == -1)
			fillColor = lastFillColor;
		else
			lastFillColor = fillColor;
		
		var g = artwork.graphics;
		
		g.clear();
		
		// draw fill
		g.beginFill(fillColor, 0.8);
		g.drawCircle(0, 0, radius);
		g.endFill();
		
		// draw border
		g.lineStyle(2, borderColor);
		g.drawCircle(0, 0, radius);
	}
	
	public function clear()
	{
		var g = artwork.graphics;
		
		g.clear();
	}
	
	public function animateMove(x:Float, y:Float):IGenericActuator
	{
		return Actuate.tween(artwork, 0.4, { x: x, y: y } ).ease(Quad.easeOut);
	}
	
	public function animatePolar(angle:Float, radius:Float):IGenericActuator
	{
		return Actuate.tween(this, 0.5, { tweenAngle: angle, tweenRadius: radius } ).ease(Quad.easeOut).onUpdate(updatePolarCoordinate);
	}
	
	public function animateSize(size:Float, color:Int):IGenericActuator
	{
		if (size == 0)
		{
			return Actuate.tween(artwork, 0.5, { alpha: 0.0 } );
		}
		else
		{
			// give everything a pop
			tweenSize = tweenSize - 20;
			
			this.lastFillColor = color;
			Actuate.tween(artwork, 0.5, { alpha: 1.0 } );
			return Actuate.tween(this, 1.2, { tweenSize: size } ).ease(Elastic.easeOut).onUpdate(updateSize);
		}
	}
	
	function updatePolarCoordinate()
	{
		movePolar(tweenAngle, tweenRadius);
	}
	
	function updateSize()
	{
		draw(tweenSize);
	}
}