package net.mkv25.base.ui;

import flash.display.DisplayObject;
import flash.display.Sprite;
import motion.Actuate;
import motion.actuators.GenericActuator.IGenericActuator;
import motion.easing.Elastic;
import motion.easing.Quad;

class BaseUI 
{
	public var artwork:Sprite;
	var enabled:Bool;
	
	public var scale(get, set):Float;
	public var visible(get, set):Bool;

	public function new() 
	{
		artwork = new Sprite();
	}
	
	// public methods
	public function move(x:Float, y:Float):BaseUI
	{
		artwork.x = x;
		artwork.y = y;
		
		return this;
	}
	
	function movePolar(angle:Float, radius:Float):BaseUI
	{
		var theta = angle / 180 * Math.PI;
		var x = radius * Math.cos(theta);
		var y = radius * Math.sin(theta);
		
		artwork.x = x;
		artwork.y = y;
		
		return this;
	}
	
	public function size(width:Float, height:Float):BaseUI
	{
		artwork.width = width;
		artwork.height = height;
		
		return this;
	}
	
	public function center(image:DisplayObject, offsetX:Int=0, offsetY:Int=0):Void
	{
		image.x = - Math.round(image.width / 2) + offsetX;
		image.y = - Math.round(image.height / 2) + offsetY;
	}
	
	
	public function enable()
	{
		enabled = true;
		artwork.mouseEnabled = true;
		artwork.mouseChildren = true;
		artwork.alpha = 1.0;
	}
	
	public function disable()
	{
		enabled = false;
		artwork.mouseEnabled = false;
		artwork.mouseChildren = false;
		artwork.alpha = 0.4;
	}
	
	public function show()
	{
		visible = true;
	}
	
	public function hide()
	{
		visible = false;
	}
	
	// animations
	public function zoomOut():IGenericActuator
	{
		Actuate.apply(artwork, { alpha: 1.0, scaleX: 1.0, scaleY: 1.0 } ).ease(Quad.easeOut);
		return Actuate.tween(artwork, 0.6, { alpha: 0.0, scaleX: 2.0, scaleY: 2.0 } ).onComplete(hide);
	}
	
	public function zoomIn():IGenericActuator
	{
		Actuate.apply(artwork, { alpha: 0.0, scaleX: 2.0, scaleY: 2.0 } ).ease(Quad.easeIn);
		return Actuate.tween(artwork, 0.6, { alpha: 1.0, scaleX: 1.0, scaleY: 1.0 } );
	}
	
	public function popIn():IGenericActuator
	{
		Actuate.apply(artwork, { alpha: 0.0, scaleX: 0.5, scaleY: 0.5 } ).ease(Elastic.easeIn);
		return Actuate.tween(artwork, 0.6, { alpha: 1.0, scaleX: 1.0, scaleY: 1.0 } );
	}
	
	public function popOut():IGenericActuator
	{
		Actuate.apply(artwork, { alpha: 1.0, scaleX: 1.0, scaleY: 1.0 } ).ease(Elastic.easeOut);
		return Actuate.tween(artwork, 0.6, { alpha: 0.0, scaleX: 0.5, scaleY: 0.5 } );
	}
	
	// properties
	public function get_scale():Float
	{
		return artwork.scaleX;
	}
	
	public function set_scale(value:Float):Float
	{
		return artwork.scaleX = artwork.scaleY = value;
	}
	
	public function get_visible():Bool
	{
		return artwork.visible;
	}
	
	public function set_visible(value:Bool):Bool
	{
		return artwork.visible = value;
	}
}