package net.mkv25.specs;

import hxpect.core.BaseSpec;
import net.mkv25.game.models.game.Game;

class DomainSpecs extends BaseSpec
{
	override public function run()
	{
		var domain:Game;
		
		beforeEach(function()
		{
			domain = new Game();
		});
		
		describe("Creating the domain", function()
		{
			beforeEach(function()
			{
				
			});
			
			it("should be able to store information about units", function()
			{
				
			});
			
			it("should be able to store information about the game map", function()
			{
				
			});
			
			it("should be able to store information about players", function()
			{
				
			});
			
			it("should be able to store information about active players, and who the current player is", function()
			{
				
			});
			
			it("should be able to store information about card types", function()
			{
				
			});
		});
	}
}