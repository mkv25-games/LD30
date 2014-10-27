package net.mkv25.specs;

import hxpect.core.BaseSpec;
import net.mkv25.base.core.Pointer.Pointer;
import net.mkv25.base.core.StorageModel;
import net.mkv25.game.models.MapUnit;
import net.mkv25.game.models.UnitList;

class StorageSpecs extends BaseSpec
{
	override public function run()
	{
		var storage:StorageModel;
		
		beforeEach(function()
		{
			var path = "test-spec";
			storage = new StorageModel(path);
		});
		
		describe("Storage Model", function()
		{
			beforeEach(function()
			{
				
			});
			
			it("should be able to store data", function()
			{
				var expected = "data to store";
				storage.write(expected,
					function()
					{
						storage.read(
							function(actual)
							{
								expect(actual).to.be(expected);
							},
							function(unxpectedReadError)
							{
								throw unxpectedReadError;
							}
						);
					},
					function(unexpectedWriteError)
					{
						throw unexpectedWriteError;
					}
				);
			});
			
			it("should return null data if a key does not exist", function()
			{
				var nonExistentKey = "non-existent";
				var expectedError:String = "Field filedata does not exist on object.";
				
				storage = new StorageModel(nonExistentKey);
				storage.read(
					function(actualData)
					{
						expect(actualData).to.beNull();
					},
					function(unxpectedError)
					{
						throw unxpectedError;
					}
				);
			});
		});
	}
}