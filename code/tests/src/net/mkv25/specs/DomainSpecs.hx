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
			
			it("should be initialised with the correct properties", function()
			{
				expect(domain.cards).to.not.beNull();
				expect(domain.map).to.not.beNull();
				expect(domain.players).to.not.beNull();
				expect(domain.turnModel).to.not.beNull();
				expect(domain.units).to.not.beNull();
			});
		});
	}
}