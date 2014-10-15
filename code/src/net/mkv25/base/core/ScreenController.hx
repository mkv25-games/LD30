package net.mkv25.base.core;

import flash.display.DisplayObjectContainer;
import flash.events.KeyboardEvent;
import flash.ui.Keyboard;
import flash.display.Sprite;
import flash.display.Stage;
import flash.events.Event;
import motion.Actuate;
import net.mkv25.base.ui.TintUI;

class ScreenController 
{
	public var scale(get, null):Float;
	public var activeScreen(get, null):Screen;
	
	var stage:Stage;
	
	var backgroundTint:Sprite;
	var zoomContainer:Sprite;
	var screenLayer:Sprite;
	
	var screens:Array<Screen>;
	var currentScreen:Screen;
	var screenHistory:Array<Screen>;
	
	public function new() 
	{
		stage = null;
		zoomContainer = new Sprite();
		screenLayer = new Sprite();
		
		screens = new Array<Screen>();
		currentScreen = null;
		screenHistory = new Array<Screen>();
	}
	
	public function setup(stage:Stage):ScreenController
	{
		this.stage = stage;
		
		while (screens.length > 0)
			screens.pop();
		
		backgroundTint = TintUI.createTint(0x555555, 1.0, Screen.WIDTH, Screen.HEIGHT);
		zoomContainer.addChild(backgroundTint);
			
		zoomContainer.addChild(screenLayer);
		stage.addChild(zoomContainer);
		
		stage.addEventListener(Event.RESIZE, onStageResize);
		stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyAction);
		
		return this;
	}
	
	public function addLayer(layer:DisplayObjectContainer)
	{
		zoomContainer.addChild(layer);
	}
	
	function onKeyAction(event:KeyboardEvent)
	{
		if (activeScreen == null)
			return;
			
		activeScreen.handleKeyAction(event);
	}
	
	function onStageResize(e)
	{
		updateScreenSize();
	}
	
	public function updateScreenSize()
	{
		var expectedHeight:Int = 800;
		var actualHeight:Int = cast stage.stageHeight;
		
		var startScale = zoomContainer.scaleY;
		var idealScale:Float;
		
		// scale to fit
		zoomContainer.scaleY = stage.stageHeight / Screen.HEIGHT;
		zoomContainer.scaleX = zoomContainer.scaleY;
		
		// set ideal scaling
		idealScale = zoomContainer.scaleY;
		
		// animate scale
		if (idealScale != startScale)
		{
			zoomContainer.scaleX = zoomContainer.scaleY = startScale;
			Actuate.tween(zoomContainer, 0.5, { scaleX: idealScale, scaleY: idealScale } ).onUpdate(centerZoomContainer);
		}
		else
		{
			zoomContainer.scaleX = zoomContainer.scaleY = idealScale;
		}
		
		centerZoomContainer();
	}
	
	function centerZoomContainer()
	{
		// vertical center
		zoomContainer.x = (stage.stageWidth / 2) - (Screen.WIDTH * zoomContainer.scaleX / 2);
		zoomContainer.y = (stage.stageHeight / 2) - (Screen.HEIGHT * zoomContainer.scaleY / 2);
	}
	
	public function handleRequestNextScreen(?model):Void
	{
		showNextScreen();
	}
	
	public function handleRequestLastScreen(?model):Void
	{
		showLastScreen();
	}
	
	public function addScreen(screen:Screen):Screen
	{
		screens.push(screen);
		
		return screen;
	}
	
	public function showScreen(screen:Screen):Void
	{
		if (currentScreen == screen)
			throw "Cannot show same screen a second time";
		
		if (currentScreen != null)
		{
			currentScreen.hidden.dispatch(currentScreen);
			screenLayer.removeChild(currentScreen.artwork);
		}
			
		screenLayer.addChild(screen.artwork);
		screen.show();
		
		if (currentScreen != null)
			screenHistory.push(currentScreen);
		
		currentScreen = screen;
		
		updateScreenSize();
	}
	
	public function showNextScreen():Void
	{
		var i = Lambda.indexOf(screens, currentScreen);
		i++;
		if (i >= screens.length)
			i = 0;
			
		showScreen(screens[i]);
	}
	
	public function showLastScreen():Void
	{
		if (screenHistory.length == 0)
			throw "No screens left in the history to show.";
			
		var screen = screenHistory.pop();
		
		showScreen(screen);
		
		// remove the last screen from the history
		screenHistory.pop();
	}
	
	public function clearHistory():Void
	{
		while(screenHistory.length > 0)
			screenHistory.pop();
	}
	
	function get_scale():Float
	{
		return zoomContainer.scaleY;
	}
	
	function get_activeScreen():Screen
	{
		return currentScreen;
	}
}