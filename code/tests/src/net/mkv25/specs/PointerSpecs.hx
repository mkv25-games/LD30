package net.mkv25.specs;

import hxpect.core.BaseSpec;
import net.mkv25.base.core.Pointer;

class PointerSpecs extends BaseSpec
{
	override public function run()
	{
		describe("Pointers", function()
		{
			var expectedArray1 = [1, 2, 3, 4, 5];
			var expectedArray2 = [6, 7, 8, 9, 10];
			
			beforeEach(function()
			{
				Pointer.reset();
				
				Pointer.store(String, "abc", "hello world");
				Pointer.store(String, "xyz", "hello sea");
				
				Pointer.store(Array, "abc", expectedArray1);
				Pointer.store(Array, "xyz", expectedArray2);
			});
			
			it("should be able to retrieve strings by id", function()
			{
				var pointer1 = new Pointer<String>("abc", String);
				expect(Pointer.exists(String, "abc")).to.be(true);
				expect(pointer1.value).to.be("hello world");
				
				var pointer2 = new Pointer<String>("xyz", String);
				expect(Pointer.exists(String, "xyz")).to.be(true);
				expect(pointer2.value).to.be("hello sea");
			});
			
			it("should be able to retrieve arrays by id", function()
			{
				var pointer1 = new Pointer<Array<Int>>("abc", Array);
				expect(Pointer.exists(Array, "abc")).to.be(true);
				expect(pointer1.value).to.be(expectedArray1);
				
				var pointer2 = new Pointer<Array<Int>>("xyz", Array);
				expect(Pointer.exists(Array, "xyz")).to.be(true);
				expect(pointer2.value).to.be(expectedArray2);
			});
			
			it("should throw an exception if a value is stored under an existing index", function()
			{
				expect(Pointer.exists(String, "abc")).to.be(true);
				expect(function() {
					Pointer.store(String, "abc", "crash test");
				}).to.throwException("Item type 'String' already exists for id 'abc'.");
				
				expect(Pointer.exists(Array, "xyz")).to.be(true);
				expect(function() {
					Pointer.store(Array, "xyz", [2,2,2,3,1]);
				}).to.throwException("Item type 'Array' already exists for id 'xyz'.");
			});
		});
	}
}