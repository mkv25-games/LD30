package net.mkv25.specs;

import hxpect.core.BaseSpec;
import net.mkv25.game.models.MapUnit;
import net.mkv25.game.models.UnitList;

class UnitListSpecs extends BaseSpec
{
	override public function run()
	{
		var unitList:UnitList;
		
		beforeEach(function()
		{
			unitList = new UnitList();
		});
		
		describe("Unit List", function()
		{
			var mapUnit:MapUnit;
			
			beforeEach(function()
			{
				mapUnit = new MapUnit();
			});
			
			it("should be able to store units", function()
			{
				expect(unitList.contains(mapUnit)).to.be(false);
				
				unitList.addUnit(mapUnit);
				
				expect(unitList.contains(mapUnit)).to.be(true);
			});
		});
		
		describe("A failing test", function()
		{
			it("should fail", function()
			{
				expect(false).to.be(true);
			});
		});
	}
}