// ColorMatrix Class v1.2
//
// Author: Mario Klingemann
// http://www.quasimondo.com

// Ported to Haxe by John Beech
// http://mkv25.net/

// Changes in v1.1:
// Changed the RGB to luminance constants
// Added colorize() method

// Changes in v1.2:
// Added clone() 
// Added randomize() 
// Added blend() 
// Added "filter" property

package net.mkv25.base.core;

import flash.filters.ColorMatrixFilter;

class ColorMatrix
{
	// RGB to Luminance conversion constants as found on
	// Charles A. Poynton's colorspace-faq:
	// http://www.faqs.org/faqs/graphics/colorspace-faq/
	
	private static var r_lum:Float = 0.212671;
	private static var g_lum:Float = 0.715160;
	private static var b_lum:Float = 0.072169;
	
	/*
	
	// There seem  different standards for converting RGB
	// values to Luminance. This is the one by Paul Haeberli:
	
	private static var r_lum:Float = 0.3086;
	private static var g_lum:Float = 0.6094;
	private static var b_lum:Float = 0.0820;
	
	*/
	
	private static var IDENTITY:Array<Float> = [1,0,0,0,0,
											  0,1,0,0,0,
											  0,0,1,0,0,
											  0,0,0,1,0];
	
	public var matrix:Array<Float>;
	
	public var filter(get, null):ColorMatrixFilter;
	
	/**
	Function: ColorMatrix

	Constructor

	Parameters:

		mat - if omitted matrix gets initialized with an
			identity matrix. Alternatively it can be 
			initialized with another ColorMatrix or 
			an array (there is currently no check 
			if the array is valid. A correct array 
			contains 20 elements.)	
	*/
	public function new(?mat:Dynamic)
	{
		if (Std.is(mat, ColorMatrix))
		{
			matrix = mat.matrix.concat();
		}
		else if (Std.is(mat, Array))
		{
			matrix = mat.concat();
		}
		else 
		{
			reset();
		}
	}
	
	/**
	Function: reset
		resets the matrix to the neutral identity matrix. Applying this
		matrix to an image will not make any changes to it.

	Parameters:
		none

	Returns:
		nothing
	*/
	public function reset():Void
	{
		matrix = IDENTITY.concat([]);
	}
	
	public function clone():ColorMatrix
	{
		return new ColorMatrix(matrix);
	}
	
	/**
	Function: adjustSaturation
		changes the saturation

	Parameters:
		s - typical values come in the range 0.0 ... 2.0 where
			0.0 means 0% Saturation
			0.5 means 50% Saturation
			1.0 is 100% Saturation (aka no change)
			2.0 is 200% Saturation

		Other values outside of this range are possible
		-1.0 will invert the hue but keep the luminance
	
	Returns:
		nothing	
	*/
	public function adjustSaturation (s:Float):Void
	{
		var is:Float=1-s;
		
	    var irlum:Float = is * r_lum;
		var iglum:Float = is * g_lum;
		var iblum:Float = is * b_lum;
		
		var mat:Array<Float> =  [irlum + s, iglum   , iblum    , 0, 0,
					  			irlum    , iglum + s, iblum    , 0, 0,
					    		irlum    , iglum    , iblum + s, 0, 0,
					    		0        , 0        , 0        , 1, 0 ];
	
		concat(mat);
	}
	
	public function adjustContrast (r:Float, ?g:Float, ?b:Float):Void
	{
		if (g == null) g = r;
		if (b == null) b = r;
		
		r+=1;
		g+=1;
		b+=1;
		
		var mat:Array<Float> = [r,0,0,0,128*(1-r),
					 		    0,g,0,0,128*(1-g),
					 		    0,0,b,0,128*(1-b),
							    0,0,0,1,0];
	
		concat(mat);
	}
	
	public function adjustBrightness (r:Float, ?g:Float, ?b:Float):Void
	{
		if (g == null) g = r;
		if (b == null) b = r;
		
		var mat:Array<Float> = [1,0,0,0,r,
					 		    0,1,0,0,g,
					 		    0,0,1,0,b,
							    0,0,0,1,0];
 	
		concat(mat);
	}
	
	public function adjustHue(angle:Float):Void
	{
		angle *= Math.PI/180;
		
		var c:Float = Math.cos( angle );
		var s:Float = Math.sin( angle );
		
		var f1:Float = 0.213;
		var f2:Float = 0.715;
		var f3:Float = 0.072;
		
		var mat:Array<Float> = [(f1 + (c * (1 - f1))) + (s * (-f1)), (f2 + (c * (-f2))) + (s * (-f2)), (f3 + (c * (-f3))) + (s * (1 - f3)), 0, 0, (f1 + (c * (-f1))) + (s * 0.143), (f2 + (c * (1 - f2))) + (s * 0.14), (f3 + (c * (-f3))) + (s * -0.283), 0, 0, (f1 + (c * (-f1))) + (s * (-(1 - f1))), (f2 + (c * (-f2))) + (s * f2), (f3 + (c * (1 - f3))) + (s * f3), 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1];
		
		concat(mat);
	}
	
	public function colorize ( rgb:Int, ?amount:Float):Void
	{
		
		var r:Float = ( ( rgb >> 16 ) & 0xff ) / 255;
		var g:Float = ( ( rgb >> 8  ) & 0xff ) / 255;
		var b:Float = (   rgb         & 0xff ) / 255;
		
		if (amount == null) amount = 1;
		var inv_amount:Float = 1 - amount;
		
		var mat:Array<Float> = [ inv_amount + amount*r*r_lum, amount*r*g_lum,  amount*r*b_lum, 0, 0,
					  			 amount*g*r_lum, inv_amount + amount*g*g_lum, amount*g*b_lum, 0, 0,
					   			 amount*b*r_lum,amount*b*g_lum, inv_amount + amount*b*b_lum, 0, 0,
					    		 0 , 0 , 0 , 1, 0 ];
		
		concat(mat);
	}
	
	public function setAlpha( alpha:Float ):Void
	{
		var mat:Array<Float> = [ 1, 0, 0, 0, 0,
					  			 0, 1, 0, 0, 0,
					   			 0, 0, 1, 0, 0,
					    		 0, 0, 0, alpha, 0 ];
		
		concat(mat);
	}
	
	public function desaturate():Void
	{
		var mat:Array<Float> = [ r_lum, g_lum, b_lum, 0, 0,
					  			 r_lum, g_lum, b_lum, 0, 0,
					   			 r_lum, g_lum, b_lum, 0, 0,
					    		 0,     0,     0,     1, 0 ];
		
		concat(mat);
	}
	
	public function invert():Void
	{
		var mat:Array<Float> = [ -1,  0,  0, 0, 255,
					  			  0, -1,  0, 0, 255,
								  0,  0, -1, 0, 255,
								  0,  0,  0, 1,   0 ];
		
		concat(mat);
	}
	
	public function threshold(t:Float):Void
	{
		var mat:Array<Float> = [	r_lum*256, g_lum*256, b_lum*256, 0,  -256*t, 
									r_lum*256 ,g_lum*256, b_lum*256, 0,  -256*t, 
									r_lum*256, g_lum*256, b_lum*256, 0,  -256*t, 
									0, 0, 0, 1, 0 ]; 
		concat(mat);
	}
	
	public function randomize(?amount:Float):Void
	{
		if (amount == null) amount = 1;
		
		var inv_amount:Float = 1 - amount;
		
		var r1:Float = inv_amount +  amount * ( Math.random() - Math.random() );
		var g1:Float = amount     * ( Math.random() - Math.random() );
		var b1:Float = amount     * ( Math.random() - Math.random() );
		
		var o1:Float = amount * 255 * (Math.random() - Math.random());
		
		var r2:Float = amount     * ( Math.random() - Math.random() );
		var g2:Float = inv_amount +  amount * ( Math.random() - Math.random() );
		var b2:Float = amount     * ( Math.random() - Math.random() );
		
		var o2:Float = amount * 255 * (Math.random() - Math.random());
		
		
		var r3:Float = amount     * ( Math.random() - Math.random() );
		var g3:Float = amount     * ( Math.random() - Math.random() );
		var b3:Float = inv_amount +  amount * ( Math.random() - Math.random() );
		
		var o3:Float = amount * 255 * (Math.random() - Math.random());
		
		var mat:Array<Float> = [ r1, g1, b1, 0, o1, 
								 r2 ,g2, b2, 0, o2, 
								 r3, g3, b3, 0, o3, 
								 0 ,  0,  0, 1, 0 ]; 
		
		concat(mat);
	}
	
	
	public function setChannels (r:Int, g:Int, b:Int, a:Int ):Void
	{
		var rf:Float =((r & 1) == 1 ? 1:0) + ((r & 2) == 2 ? 1:0) + ((r & 4) == 4 ? 1:0) + ((r & 8) == 8 ? 1:0); 
		if (rf>0) rf=1/rf;
		var gf:Float =((g & 1) == 1 ? 1:0) + ((g & 2) == 2 ? 1:0) + ((g & 4) == 4 ? 1:0) + ((g & 8) == 8 ? 1:0); 
		if (gf>0) gf=1/gf;
		var bf:Float =((b & 1) == 1 ? 1:0) + ((b & 2) == 2 ? 1:0) + ((b & 4) == 4 ? 1:0) + ((b & 8) == 8 ? 1:0); 
		if (bf>0) bf=1/bf;
		var af:Float =((a & 1) == 1 ? 1:0) + ((a & 2) == 2 ? 1:0) + ((a & 4) == 4 ? 1:0) + ((a & 8) == 8 ? 1:0); 
		if (af>0) af=1/af;
		
		var mat:Array<Float> = [(r & 1) == 1 ? rf:0,(r & 2) == 2 ? rf:0,(r & 4) == 4 ? rf:0,(r & 8) == 8 ? rf:0,0,
					 		   (g & 1) == 1 ? gf:0,(g & 2) == 2 ? gf:0,(g & 4) == 4 ? gf:0,(g & 8) == 8 ? gf:0,0,
					 		   (b & 1) == 1 ? bf:0,(b & 2) == 2 ? bf:0,(b & 4) == 4 ? bf:0,(b & 8) == 8 ? bf:0,0,
							   (a & 1) == 1 ? af:0,(a & 2) == 2 ? af:0,(a & 4) == 4 ? af:0,(a & 8) == 8 ? af:0,0];
		
		concat(mat);
		
	}
	
	public function blend( m:ColorMatrix, amount:Float ):Void
	{
		var inv_amount:Float = 1 - amount;
		
		for (i in 0...20)
		{
			matrix[i] = inv_amount * matrix[i] + amount * m.matrix[i];
		}
	}
	
	public function concat(mat:Array<Float>):Void
	{
		var temp:Array<Float> = [];
		var i:Int = 0;
		
		for (y in 0...4)
		{
			for (x in 0...5)
			{
				temp[i + x] = mat[i] * matrix[x] + 
					   mat[i+1] * matrix[x +  5] + 
					   mat[i+2] * matrix[x + 10] + 
					   mat[i+3] * matrix[x + 15] +
					   (x == 4 ? mat[i+4] : 0);
			}
			i+=5;
		}
		
		matrix = temp;
		
	}
	
	function get_filter():ColorMatrixFilter
	{
		return new ColorMatrixFilter(matrix);
	}
}
