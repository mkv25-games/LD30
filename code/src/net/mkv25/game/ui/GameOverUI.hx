package net.mkv25.game.ui;

import flash.display.Graphics;
import flash.display.Sprite;
import net.mkv25.base.core.Screen;
import net.mkv25.base.ui.BaseUI;
import net.mkv25.base.ui.ButtonUI;
import net.mkv25.base.ui.IconButtonUI;
import net.mkv25.base.ui.TextUI;
import net.mkv25.game.event.EventBus;
import net.mkv25.game.models.ActiveGame;

class GameOverUI extends BaseUI
{
	private static inline var SIZE:Int = 500;
	private static inline var TOP_OFFSET:Int = 50;
	
	var backgroundCover:Sprite;
	var backgroundTint:Sprite;
	var titleText:TextUI;
	var winningConditionText:TextUI;
	var gameStatsText:TextUI;
	
	var playAgainButton:ButtonUI;
	
	public function new() 
	{
		super();
		
		init();
	}
	
	function init()
	{
		var hs = GameOverUI.SIZE / 2;
		
		createBackgroundCover();
		createBackgroundTint();
		
		titleText = cast TextUI.makeFor("Player Name Goes Here".toUpperCase(), 0xFFFFFF).fontSize(32).size(GameOverUI.SIZE, 40).move(0, 100);
		winningConditionText = cast TextUI.makeFor("Winning Condition\nand explanation".toUpperCase(), 0x999999).fontSize(26).size(GameOverUI.SIZE, 70).move(0, 150);
		gameStatsText = cast TextUI.makeFor("Game\nStats\nGo\nHere".toUpperCase(), 0x999999).fontSize(20).size(GameOverUI.SIZE, 200).move(0, 350);
		
		playAgainButton = new ButtonUI();
		playAgainButton.setup("PLAY AGAIN", playAgainSelected);
		playAgainButton.move(hs, hs + 50);
		
		artwork.addChild(playAgainButton.artwork);
		artwork.addChild(titleText.artwork);
		artwork.addChild(winningConditionText.artwork);
		artwork.addChild(gameStatsText.artwork);
	}
	
	public function setup(title:String, winningCondition:String, game:ActiveGame):Void
	{
		titleText.setText(title.toUpperCase());
		winningConditionText.setText(winningCondition.toUpperCase());
		
		var stats:String = "Thank you for playing".toUpperCase();
		gameStatsText.setText(stats);
	}
	
	function createBackgroundCover()
	{
		backgroundCover = new Sprite();
		
		var g:Graphics = backgroundCover.graphics;
		g.beginFill(0x000000, 0.1);
		g.drawRect(0, 0, GameOverUI.SIZE, GameOverUI.SIZE);
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
		g.drawRect(0, 0, Screen.WIDTH, Screen.HEIGHT - GameOverUI.TOP_OFFSET);
		g.endFill();
		
		backgroundTint.x = 0;
		backgroundTint.y = GameOverUI.TOP_OFFSET;
		artwork.addChild(backgroundTint);
	}
	
	function playAgainSelected(?model):Void
	{
		EventBus.restartGame.dispatch(this);
		hide();
	}
}