package net.mkv25;

import hxpect.core.TestRunner;

import net.mkv25.tests.UnitListTests;

class Main 
{
	static function main() 
	{
		var testRunner = new TestRunner();
		testRunner.registerTestClass(UnitListTests);
		testRunner.run();
		
		var successful = (testRunner.failiures() == 0);
		
		#if (flash || html5)
			var result = (successful) ? "Success" : "Failed";
			trace("Test runner: " + result);
		#else
			Sys.exit(successful ? 0 : 1);
		#end
	}
}