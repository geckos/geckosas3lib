////////////////////////////////////////////////////////////////
//  
//  用于处理一般的色彩操作, 目前的问题是缺少设置色相, 饱和度, 对比度
//  
////////////////////////////////////////////////////////////////

package cn.geckos.utils
{
import flash.geom.ColorTransform;
import flash.filters.ColorMatrixFilter;
import cn.geckos.utils.NumberUtil;

public final class ColorUtil
{
	//---------------------------------
	//
	// 常用色彩值
	//
	//---------------------------------
	
	/**
	 * 纯红
	 */
	public static const LIGHT_RED:uint      = 0xFF0000;
	
	/**
	 * 黄色
	 */
	public static const YELLOW:uint         = 0xFFFF00;
	
	/**
	 * 纯绿
	 */
	public static const LIGHT_GREEN:uint    = 0x00FF00;
	
	/**
	 * 青色
	 */
	public static const LIGHT_CYAN:uint     = 0x00FFFF;
	
	/**
	 * 纯蓝
	 */
	public static const LIGHT_BLUE:uint     = 0x0000FF;
	
	/**
	 * 粉色
	 */
	public static const LIGHT_MEGENTA:uint  = 0xFF00FF;

	
	//---------------------------------
	//
	// 设置colorMatrixFilter的矩阵的常量值
	//
	//---------------------------------
	
	/**
	*  用于设置colorMatrixFilter的矩阵中的红色乘值
	*/
	public static const RED_LUMINANCE:Number = .3086;
	
	/**
	 * 用于设置colorMatrixFilter的矩阵中的绿色乘值
	 */
	public static const GREEN_LUMINANCE:Number = .6094;
	
	/**
	 * 用于设置colorMatrixFilter的矩阵中的蓝色乘值
	 */
	public static const BLUE_LUMINANCE:Number = .0820;

	
	/**
	 * 根据给出的r, g, b值返回一个24位的十六进制色彩值
	 * @param	r
	 * @param	g
	 * @param	b
	 * @return  获取24位色
	 */
	public static function get24Hex(r:uint, g:uint, b:uint):uint
	{
		return r << 16 | g << 8 | b;
	}
	
	/**
	 * 根据给出的a, r, g, b值返回一个32位的十六进制色彩值
	 * @param	a
	 * @param	r
	 * @param	g
	 * @param	b
	 * @return  获取32位色
	 */
	public static function  get32Hex(a:uint, r:uint, g:uint, b:uint):uint
	{
		return a << 24 | r << 16 | g << 8 | b;
	}
	
	/**
	 * 去除饱和色(来自Mario Klingemann的ColorMatrix Class v1.2), "灰度"图像
	 * 
	 * @return 返回一个ColorMatrixFilter类对象
	 */
	public static function getDesaturateFilter():ColorMatrixFilter
	{
		var matrix:Array = [RED_LUMINANCE, GREEN_LUMINANCE, BLUE_LUMINANCE, 0, 0,
		                    RED_LUMINANCE, GREEN_LUMINANCE, BLUE_LUMINANCE, 0, 0,
							RED_LUMINANCE, GREEN_LUMINANCE, BLUE_LUMINANCE, 0, 0,
							0,             0,               0,              1, 0];
							
		return new ColorMatrixFilter(matrix);
	}
	
	/**
	 * 设置亮度值(ColorMatrixFilter)
	 * @param	value
	 * @return  返回设置亮度后的ColorMatrixFilter对象
	 */
	public static function getBrightnessFilter(value:int = 100/*-100 - 100*/):ColorMatrixFilter
	{
		var value:int = Math.max(Math.min(100, value), -100);
		var matrix:Array = [];
		matrix = matrix.concat([1, 0, 0, 0, value]);
		matrix = matrix.concat([0, 1, 0, 0, value]);
		matrix = matrix.concat([0, 0, 1, 0, value]);
		matrix = matrix.concat([0, 0, 0, 1, 0]);
		return new ColorMatrixFilter(matrix);
	}

	/**
	 * 设置反相效果
	 * @param	pic
	 * @return  返回一个ColorTransform对象
	 */
	public static function getNegativeTransform():ColorTransform
	{
		var netaiveTransform:ColorTransform;
		netaiveTransform = new ColorTransform( -1, -1, -1, 1, 255, 255, 255, 0);
		return netaiveTransform;
	}
	
	
	/**
	 * 设置色彩
	 * @param	hex
	 * @param	count
	 * @return  返回给定色彩值容量的ColorTransform对象
	 */
	public static function getTintTransform(hex:uint, count:int/*0 - 100*/):ColorTransform
	{
		var tintform:ColorTransform;
		
		var r:uint = getRed(hex);
		var g:uint = getGreen(hex);
		var b:uint = getBlue(hex);
		
		if (count < 0) count = 0;
		else if (count > 100) count = 100;
		
		var multiPlier:Number = 1 - (count / 100);
		
		var redOffset:Number = Math.round(r * (count / 100));
		var greenOffset:Number = Math.round(g * (count / 100));
		var blueOffset:Number = Math.round(b * (count / 100));
		
		tintform = new ColorTransform(multiPlier, 
									  multiPlier, 
									  multiPlier, 
									  1, redOffset, greenOffset, blueOffset, 0);
		
		return tintform;
	}
	
	/**
	 * 设置亮度(ColorTransform)
	 * @param	bright
	 * @return  返回一个ColorTransform对象
 	 */
	public static function getLightnessTransform(bright:int = 100/*-100 - 100*/):ColorTransform
	{
		var cTransForm:ColorTransform;
		var multiPlier:Number = bright / 100;
		
		if (multiPlier > 1) multiPlier = 1;
		else if (multiPlier < -1) multiPlier = -1;
		
		var multiPlierPercent:Number = 1 - NumberUtil.getAbsolute(multiPlier);
	
		var offset:Number = 0;
		
		if (multiPlier > 0)
		{
			offset = multiPlier * 0xFF;
		}
		
		cTransForm = new ColorTransform(multiPlierPercent, 
										multiPlierPercent, 
										multiPlierPercent,
										1,
										offset, offset, offset, 0);
		return cTransForm;
	}
	
	/**
	 * 设置透明度
	 * @param	alpha
	 * @return  返回设置透明度的ColorTransform对象
	 */
	public static function getAlphaTransform(alpha:int/*0 - 100*/):ColorTransform
	{
		if (alpha < 0) alpha = 0;
		else if (alpha > 100) alpha = 100;
		
		var alphaOffset:Number = NumberUtil.round(255 / 100 * alpha);
		return new ColorTransform(1, 1, 1, 0, 0, 0, 0, alphaOffset);
	}
	
	/**
	 * 根据给定的r, g, b生成一个ColorTransform对象
	 * @param	r
	 * @param	g
	 * @param	b
	 * @return  返回一个ColorTransform对象
	 */
	public static function getRGBMixTransform(r:int, g:int, b:int, a:int = 0,
											  					  rm:int = 1, 
											  					  gm:int = 1, 
											  					  bm:int = 1, 
											  					  am:int = 1):ColorTransform
	{
		var redOffset:Number = Math.max(Math.min(r, 0xFF), 0);
		var greenOffset:Number = Math.max(Math.min(g, 0xFF), 0);
		var blueOffset:Number = Math.max(Math.min(b, 0xFF), 0);
		var alphaOffset:Number = Math.max(Math.min(a, 0xFF), 0);
		return new ColorTransform(rm, gm, bm, am, redOffset, greenOffset, blueOffset, alphaOffset);
	}
	
	
	/**
	 * 获取hex的反相值
	 * @param	hex
	 * @return  返回色彩反相后的色彩值
	 */
	public static function setNegativeColor(hex:uint = 0xFFFF0000):uint
	{
		var alpha:uint = getAlpha(hex);
		var red:uint = getRed(hex); 
		var green:uint = getGreen(hex);
		var blue:uint = getBlue(hex);
		return get32Hex(alpha, (0xFF - red), (0xFF - green), (0xFF - blue));
	}
	
	
	/**
	 * 设置hex的亮度值
	 * @param	hex
	 * @param	bright
	 * @return  设置色彩的亮度值(24位色)
	 */
	public static function setColorBrightness(hex:uint, bright:int/*-100 - 100*/):uint
	{
		bright = Math.round(255 / 100 * bright);//此数值需要修正(255)
		var r:uint = Math.max(Math.min((hex >> 16 & 0xFF) + bright, 255), 0);
		var g:uint = Math.max(Math.min((hex >> 8 & 0xFF) + bright, 255), 0);
		var b:uint = Math.max(Math.min((hex & 0xFF) + bright, 255), 0);
		return get24Hex(r, g, b);
	}
	
	/**
	 * 返回一个图像的初始状态
	 * @return 返回ColorTransform对象的初始状态
	 */
	public static function setColorInitialize():ColorTransform
	{
		return new ColorTransform(1, 1, 1, 1, 0, 0, 0, 0);
	}

	/**
	 * 获取hex的透明度
	 * @param	hex
	 * @return  获取透明度值
	 */
	public static function getAlpha(hex:uint):uint
	{
		return hex >> 24 & 0xFF;
	}
	
	/**
	 * 获取hex的红色通道值
	 * @param	hex
	 * @return  获取红色通道值
	 */
	public static function getRed(hex:uint):uint
	{
		return hex >> 16 & 0xFF;
	}
	
	/**
	 * 获取hex的绿色通道值
	 * @param	hex
	 * @return  获取绿色通道值
	 */
	public static function getGreen(hex:uint):uint
	{
		return hex >> 8 & 0xFF;
	}
	
	/**
	 * 获取hex的蓝色通道值
	 * @param	hex
	 * @return  获取蓝色通道
	 */
	public static function getBlue(hex:uint):uint
	{
		return hex & 0xFF;
	}
	
	/**
	 * 打印hex的ARGB各通道值
	 * @param	hex
	 * @return  返回ARGB色彩信息
	 */
	public static function dumpRGBInfo(hex:uint):String
	{
		return   "AA:" + getAlpha(hex) + " " 
			   + "RR:" + getRed(hex)   + " " 
			   + "GG:" + getGreen(hex) + " " 
			   + "BB:" + getBlue(hex);
	}
	
	/**
	 * 去除24位色ColorHex的红色部分, 并入insertRed的指定值
	 * @param	colorHex
	 * @param	insertRed
	 * @return  替换24位红色通道值
	 * 
	 * @default is 128
	 */
	public static function replace24RedChannel(colorHex:uint, insertRed:uint = 128):uint
	{
		return (colorHex & 0x00FFFF) | (insertRed << 16);
	}
	
	/**
	 * 去除24位色ColorHex的蓝色部分, 并入insertBlue的指定值
	 * @param	colorHex
	 * @param	insertBlue
	 * @return  替换24位蓝色通道值
	 * 
	 * @default is 128
	 */
	public static function replace24BlueChannel(colorHex:uint, insertBlue:uint = 128):uint
	{
		return (colorHex & 0xFFFF00) | (insertBlue);
	}
	
	/**
	 * 去除24位色ColorHex的绿色部分, 并入insertGreen的指定值
	 * @param	colorHex
	 * @param	insertGreen
	 * @return  替换24位绿色通道值
	 * 
	 * @default is 128
	 */
	public static function replace24GreenChannel(colorHex:uint, insertGreen:uint = 128):uint
	{
		return (colorHex & 0xFF00FF) | (insertGreen << 8);
	}
	
	/**
	 * 去除32位色ColorHex的透明部分, 并入insertAlpha的指定值
	 * @param	colorHex
	 * @param	insertGreen
	 * @return  替换32位透明度通道值
	 * 
	 * @default is 128
	 */
	public static function replace32AlphaChannel(colorHex:uint, insertAlpha:uint = 128):uint
	{
		return (colorHex & 0x00FFFFFF) | (insertAlpha << 24);
	}
	
	/**
	 * 去除32位色ColorHex的红色部分, 并入insertRed的指定值
	 * @param	colorHex
	 * @param	insertRed
	 * @return  替换32位红色通道值
	 * 
	 * @default is 128
	 */
	public static function replace32RedChannel(colorHex:uint, insertRed:uint = 128):uint
	{
		return (colorHex & 0xFF00FFFF) | (insertRed << 16);
	}
	
	/**
	 * 去除32位色ColorHex的绿色部分, 并入insertGreen的指定值
	 * @param	colorHex
	 * @param	insertGreen
	 * @return  替换32位绿色通道值
	 * 
	 * @default is 128
	 */
	public static function replace32GreenChannel(colorHex:uint, insertGreen:uint = 128):uint
	{
		return (colorHex & 0xFFFF00FF) | (insertGreen << 8);
	}
	
	/**
	 * 去除32位色ColorHex的蓝色部分, 并入insertBlue的指定值
	 * @param	colorHex
	 * @param	insertGreen
	 * @return  替换32位蓝色通道值
	 * 
	 * @default is 128
	 */
	public static function replace32BlueChannel(colorHex:uint, insertBlue:uint = 128):uint
	{
		return (colorHex & 0xFFFFFF00) | (insertBlue);
	}
}
}