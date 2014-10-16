package net.mkv25.base.ui;

import flash.display.DisplayObject;
import flash.display.Sprite;
import motion.Actuate;
import motion.actuators.GenericActuator.IGenericActuator;
import motion.easing.Elastic;
import motion.easing.Quad;
import net.mkv25.game.Index;
import openfl.display.DisplayObjectContainer;
import openfl.geom.Point;

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
	
	public function moveToMouse():BaseUI
	{
		if (artwork.parent != null)
		{
			move(artwork.parent.mouseX, artwork.parent.mouseY);
		}
		
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
	
	public function addTo(container:DisplayObjectContainer):BaseUI
	{
		container.addChild(this.artwork);
		
		return this;
	}
	
	public function center(image:DisplayObject, offsetX:Float=0, offsetY:Float=0):Void
	{
		image.x = - Math.round(image.width / 2) + offsetX;
		image.y = - Math.round(image.height / 2) + offsetY;
	}
	
	public function enable()
	{
		enabled = true;
		artwork.mouseEnabled = true;
		artwork.mouseChildren = true;
	}
	
	public function disable()
	{
		enabled = false;
		artwork.mouseEnabled = false;
		artwork.mouseChildren = false;
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
		Actuate.apply(artwork, { alpha: 1.0, scaleX: 1.0, scaleY: 1.0 } );
		return Actuate.tween(artwork, 0.6, { alpha: 0.0, scaleX: 2.0, scaleY: 2.0 } ).onComplete(hide);
	}
	
	public function zoomIn():IGenericActuator
	{
		Actuate.apply(artwork, { alpha: 0.0, scaleX: 2.0, scaleY: 2.0 } );
		return Actuate.tween(artwork, 0.6, { alpha: 1.0, scaleX: 1.0, scaleY: 1.0 } );
	}
	
	public function popIn():IGenericActuator
	{
		Actuate.apply(artwork, { alpha: 0.0, scaleX: 0.5, scaleY: 0.5 } );
		return Actuate.tween(artwork, 0.6, { alpha: 1.0, scaleX: 1.0, scaleY: 1.0 } );
	}
	
	public function popOut():IGenericActuator
	{
		Actuate.apply(artwork, { alpha: 1.0, scaleX: 1.0, scaleY: 1.0 } );
		return Actuate.tween(artwork, 0.6, { alpha: 0.0, scaleX: 0.5, scaleY: 0.5 } );
	}
	
	private static var p1 = new Point();
	private static var p2 = new Point();
	public function moveBetween(source:BaseUI, target:BaseUI, animationLength:Float=0.8, delayTime:Float=0.0):IGenericActuator
	{
		if (artwork.stage == null)
		{
			return null;
		}
		
		var scale:Float = Index.screenController.scale;
		
		p1.x = 0;
		p1.y = 0;
		p1 = source.artwork.localToGlobal(p1);
		p1.setTo(p1.x / scale, p1.y / scale);
		
		p2.x = 0;
		p2.y = 0;
		p2 = target.artwork.localToGlobal(p2);
		p2.setTo(p2.x / scale, p2.y / scale);
		
		move(p1.x, p1.y);
		
		var targetx = artwork.x + (p2.x - p1.x);
		var targety = artwork.y + (p2.y - p1.y);
		
		Actuate.tween(artwork, animationLength, { x: targetx } ).ease(Quad.easeIn).delay(delayTime);
		return Actuate.tween(artwork, animationLength, { y: targety }, false ).ease(Quad.easeOut).delay(delayTime);
	}
	
	public function moveRelativeTo(target:DisplayObject, offsetX:Float, offsetY:Float):Void
	{
		if (artwork.stage == null)
		{
			return null;
		}
		
		var scale:Float = Index.screenController.scale;
		
		p1.x = 0;
		p1.y = 0;
		p1 = artwork.localToGlobal(p1);
		p1.setTo(p1.x / scale, p1.y / scale);
		
		p2.x = 0;
		p2.y = 0;
		p2 = target.localToGlobal(p2);
		p2.setTo(p2.x / scale, p2.y / scale);
		
		var targetx = artwork.x + (p2.x - p1.x);
		var targety = artwork.y + (p2.y - p1.y);
		
		move(targetx + offsetX, targety + offsetY);
	}
	
	// properties
	function get_scale():Float
	{
		return artwork.scaleX;
	}
	
	function set_scale(value:Float):Float
	{
		return artwork.scaleX = artwork.scaleY = value;
	}
	
	function get_visible():Bool
	{
		return artwork.visible;
	}
	
	function set_visible(value:Bool):Bool
	{
		return artwork.visible = value;
	}
}