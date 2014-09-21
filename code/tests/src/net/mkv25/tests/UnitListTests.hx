package net.mkv25.tests;

import hxpect.core.BaseTest;
import net.mkv25.game.models.MapUnit;
import net.mkv25.game.models.UnitList;

class UnitListTests extends BaseTest
{
	var unitList:UnitList;
	
	public function beforeEach():Void
	{
		unitList = new UnitList();
	}
	
	public function test_unitList_should_storeUnits():Void
	{
		var mapUnit:MapUnit = new MapUnit();
		
		expect(unitList.contains(mapUnit)).to.be(false);
		
		unitList.addUnit(mapUnit);
		
		expect(unitList.contains(mapUnit)).to.be(true);
	}
}