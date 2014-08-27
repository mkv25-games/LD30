package net.mkv25.game.ui;

import flash.display.Graphics;
import flash.display.Sprite;
import net.mkv25.base.core.Screen;
import net.mkv25.base.ui.BaseUI;
import net.mkv25.base.ui.ButtonUI;
import net.mkv25.base.ui.IconButtonUI;
import net.mkv25.base.ui.TextUI;
import net.mkv25.game.event.EventBus;

class InGameMenuUI extends BaseUI
{
	private static inline var SIZE:Int = 500;
	var backgroundCover:Sprite;
	var backgroundTint:Sprite;
	var cardNameText:TextUI;
	
	var option1:ButtonUI;
	var option2:ButtonUI;
	var cancelButton:IconButtonUI;
	var discardButton:IconButtonUI;
	
	var option1action:Dynamic->Void;
	var option1model:Dynamic;
	
	var option2action:Dynamic->Void;
	var option2model:Dynamic;
	
	public function new() 
	{
		super();
		
		init();
	}
	
	function init()
	{
		var hs = InGameMenuUI.SIZE / 2;
		
		createBackgroundCover();
		createBackgroundTint();
		
		cardNameText = cast TextUI.makeFor("Card Name Goes Here", 0xFFFFFF).fontSize(32).size(InGameMenuUI.SIZE, 40).move(0, 100);
		
		option1 = new ButtonUI();
		option1.setup("OPTION ONE", selectOption1);
		option1.move(hs, hs - 50);
		
		option2 = new ButtonUI();
		option2.setup("OPTION TWO", selectOption2);
		option2.move(hs, hs + 50);
		
		cancelButton = new IconButtonUI();
		cancelButton.setup("img/icon-back.png", cancelAction);
		cancelButton.move(hs - 50, hs + 150);
		
		discardButton = new IconButtonUI();
		discardButton.setup("img/icon-discard.png", discardAction);
		discardButton.move(hs + 50, hs + 150);
		
		artwork.addChild(option1.artwork);
		artwork.addChild(option2.artwork);
		artwork.addChild(cancelButton.artwork);
		artwork.addChild(discardButton.artwork);
		artwork.addChild(cardNameText.artwork);
	}
	
	function createBackgroundCover()
	{
		backgroundCover = new Sprite();
		
		var g:Graphics = backgroundCover.graphics;
		g.beginFill(0x000000, 0.1);
		g.drawRect(0, 0, InGameMenuUI.SIZE, InGameMenuUI.SIZE);
		g.endFill();
		
		backgroundCover.x = 0;
		backgroundCover.y = 0;
		artwork.addChild(backgroundCover);
	}
	
	function createBackgroundTint()
	{
		backgroundTint = new Sprite();
		
		var g:Graphics = backgroundTint.graphics;
		g.beginFill(0x000000, 0.4);
		g.drawRect(0, 0, Screen.WIDTH, Screen.HEIGHT);
		g.endFill();
		
		backgroundTint.x = 0;
		backgroundTint.y = 50;
		artwork.addChild(backgroundTint);
	}
	
	public function setCardName(text:String):Void
	{
		this.cardNameText.setText(text.toUpperCase());
	}
	
	public function setOption1(text:String, ?action:Dynamic->Void, ?model:Dynamic):Void
	{
		var option = this.option1;
		
		(action == null) ? option.disable() : option.enable();
		
		option.setup(text, selectOption1);
		
		this.option1action = action;
		this.option1model = model;
	}
	
	public function setOption2(text:String, ?action:Dynamic->Void, ?model:Dynamic):Void
	{
		var option = this.option2;
		
		(action == null) ? option.disable() : option.enable();
		
		option.setup(text, selectOption2);
		
		this.option2action = action;
		this.option2model = model;
	}
	
	function selectOption1(?model):Void
	{
		if(this.option1action != null) {
			this.option1action(this.option1model);
		}
		hide();
	}
	
	function selectOption2(?model):Void
	{
		if(this.option2action != null) {
			this.option2action(this.option2model);
		}
		hide();
	}
	
	function cancelAction(?model):Void
	{
		EventBus.playerWantsTo_cancelTheCurrentAction.dispatch(this);
		hide();
	}
	
	function discardAction(?model):Void
	{
		EventBus.playerWantsTo_discardTheCurrentCard.dispatch(this);
		hide();
	}
}