package net.mkv25.specs;

import hxpect.core.BaseSpec;
import net.mkv25.game.models.ActiveGame;
import net.mkv25.game.models.TurnModel;

import net.mkv25.specs.TurnModelSpecs.TestPlayer;

class TurnModelSpecs extends BaseSpec
{

	override public function run():Void 
	{
		var model:TurnModel<TestPlayer>;
		
		beforeEach(function()
		{
			model = new TurnModel<TestPlayer>();
		});
		
		describe("Turn model", function()
		{
			var john = TestPlayer.make("John");
			var james = TestPlayer.make("James");
			var juliet = TestPlayer.make("Juliet");
			var johanna = TestPlayer.make("Johanna");
				
			beforeEach(function()
			{
				model.add(john);
				model.add(james);
				model.add(juliet);
				model.add(johanna);
			});
				
			describe("Adding players", function()
			{
				it("should set the first player and active player values", function()
				{
					expect(model.firstPlayer).to.be(john);
					expect(model.activePlayer).to.be(john);
					expect(model.nextPlayer).to.be(james);
					expect(model.finalPlayer).to.be(johanna);
				});
				
				it("should report the correct number of players", function()
				{
					expect(model.toString()).to.be("TurnModel ( John James Juliet Johanna )");
					expect(model.size()).to.be(4);
				});
			});
			
			describe("Choose next player", function()
			{
				it("should move through the turn order, looping around at the end", function()
				{
					expect(model.activePlayer).to.be(john);
					expect(model.nextPlayer).to.be(james);
					model.chooseNextPlayer();
					
					expect(model.activePlayer).to.be(james);
					expect(model.nextPlayer).to.be(juliet);
					model.chooseNextPlayer();
					
					expect(model.activePlayer).to.be(juliet);
					expect(model.nextPlayer).to.be(johanna);
					model.chooseNextPlayer();
					
					expect(model.activePlayer).to.be(johanna);
					expect(model.nextPlayer).to.be(john);
					model.chooseNextPlayer();
					
					expect(model.activePlayer).to.be(john);
					expect(model.nextPlayer).to.be(james);
				});
				
				it("should move through the turn order, skipping players who have been removed", function()
				{
					// Johanna*, James, Juliet
					model.remove(john);
					
					expect(model.activePlayer).to.be(johanna);
					expect(model.nextPlayer).to.be(james);
					model.chooseNextPlayer();
					
					expect(model.activePlayer).to.be(james);
					expect(model.nextPlayer).to.be(juliet);
					model.chooseNextPlayer();
					
					expect(model.activePlayer).to.be(juliet);
					expect(model.nextPlayer).to.be(johanna);
					model.chooseNextPlayer();
					
					expect(model.activePlayer).to.be(johanna);
					expect(model.nextPlayer).to.be(james);
					
					// James, Juliet*
					model.remove(johanna);
					
					expect(model.activePlayer).to.be(juliet);
					expect(model.nextPlayer).to.be(james);
					model.chooseNextPlayer();
					
					expect(model.activePlayer).to.be(james);
					expect(model.nextPlayer).to.be(juliet);
					model.chooseNextPlayer();
					
					expect(model.activePlayer).to.be(juliet);
					expect(model.nextPlayer).to.be(james);
					
					// Juliet*
					model.remove(james);
					
					expect(model.activePlayer).to.be(juliet);
					expect(model.nextPlayer).to.be(juliet);
					model.chooseNextPlayer();
					
					expect(model.activePlayer).to.be(juliet);
					expect(model.nextPlayer).to.be(juliet);
					
					model.remove(juliet);
					
					// No one left ;__;
					expect(model.activePlayer).to.be(null);
					expect(model.nextPlayer).to.be(null);
				});
			});
			
			describe("Removing players", function()
			{	
				it("should remove the first player, set the second player to the first, and set the active player to the last", function()
				{
					var result:Bool = model.remove(john);
					
					expect(result).to.be(true);
					
					expect(model.toString()).to.be("TurnModel ( James Juliet Johanna )");
					expect(model.size()).to.be(3);
					expect(model.activePlayer).to.be(johanna);
					expect(model.firstPlayer).to.be(james);
					expect(model.nextPlayer).to.be(james);
					expect(model.finalPlayer).to.be(johanna);
				});
				
				it("should be able to remove the second player without changing the first or activePlayer", function()
				{
					var result:Bool = model.remove(james);
					
					expect(result).to.be(true);
					
					expect(model.toString()).to.be("TurnModel ( John Juliet Johanna )");
					expect(model.size()).to.be(3);
					expect(model.activePlayer).to.be(john);
					expect(model.firstPlayer).to.be(john);
					expect(model.nextPlayer).to.be(juliet);
					expect(model.finalPlayer).to.be(johanna);
				});
				
				it("should return false if trying to remove a player that does not exit in model", function()
				{
					var result1:Bool = model.remove(juliet);
					var result2:Bool = model.remove(juliet);
					
					expect(result1).to.be(true);
					expect(result2).to.be(false);
					
					expect(model.toString()).to.be("TurnModel ( John James Johanna )");
					expect(model.size()).to.be(3);
					expect(model.activePlayer).to.be(john);
					expect(model.firstPlayer).to.be(john);
					expect(model.finalPlayer).to.be(johanna);
				});
				
				it("should return lots of null values if there are no players left in the list", function()
				{
					expect(model.firstPlayer).to.be(john);
					expect(model.finalPlayer).to.be(johanna);
					expect(model.activePlayer).to.be(john);
					expect(model.nextPlayer).to.be(james);
					
					model.remove(james);
					model.remove(john);
					model.remove(johanna);
					model.remove(juliet);
					
					expect(model.firstPlayer).to.be(null);
					expect(model.finalPlayer).to.be(null);
					expect(model.activePlayer).to.be(null);
					expect(model.nextPlayer).to.be(null);
				});
			});
		});
	}
}

class TestPlayer
{
	var name:String;
	
	private function new(name:String)
	{
		this.name = name;
	}
	
	public function toString():String
	{
		return name;
	}
	
	public static function make(name:String):TestPlayer
	{
		return new TestPlayer(name);
	}
}

