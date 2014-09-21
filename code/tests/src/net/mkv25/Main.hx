package net.mkv25;

import hxpect.core.TestRunner;
import hxpect.core.SpecRunner;

import net.mkv25.tests.*;
import net.mkv25.specs.*;

class Main 
{
	static function main() 
	{
		var specRunner = new SpecRunner();
		specRunner.registerSpecClass(UnitListSpecs);
		specRunner.run();
		
		var successful = specRunner.successful();
		
		#if (flash || html5)
			var result = (successful) ? "Success" : "Failed";
			trace("Test runner: " + result);
		#else
			Sys.exit(successful ? 0 : 1);
		#end
	}
}