////////////////////////////////////////////////////////////////
//  
//  用于处理一般的色彩操作, 目前的问题是缺少设置色相, 饱和度, 对比度
//  
////////////////////////////////////////////////////////////////

package cn.geckos.utils
{

//import flash.geom.ColorTransform;
//import flash.filters.ColorMatrixFilter;
//import cn.geckos.utils.NumberUtil;

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
	 * 获取hex的反相值
	 * @param	hex
	 * @return  返回色彩反相后的色彩值
	 */
	public static function reverseColor(hex:uint = 0xFFFF0000):uint
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
	 * 
	 * 设置亮度偏移量(Bright offset)
	 */
	public static function setColorBrightness(hex:uint, bright:int/*-100 - 100*/):uint
	{
		bright = Math.round(255 / 100 * bright);//此数值需要修正(255)
		var r:uint = Math.max(Math.min(getRed(hex) + bright, 255), 0);
		var g:uint = Math.max(Math.min(getGreen(hex) + bright, 255), 0);
		var b:uint = Math.max(Math.min(getBlue(hex) + bright, 255), 0);
		return get24Hex(r, g, b);
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
	 * 打印出单色的十六进制色彩值
	 * @param	hex
	 * @return  返回色彩值的字符串形式
	 */
	public static function dumpColorHexStr(hex:uint):String
	{
		var hexStr:String = hex.toString(16);
		while ((6 - hexStr.length) > 0)
		{
			hexStr = "0" + hexStr;
		}
		return "0x" + hexStr.toUpperCase();
	}
	
	/**
	 * 返回色彩字符串的16进制的数值形式
	 * @param	hexStr
	 * @return
	 */
	public static function getColorHexFromStr(hexStr:String):uint
	{
	    return uint(parseInt(hexStr, 16));
	}
	
	
	
	/**
	 * 去除24位色ColorHex的红色部分, 并入insertRed的指定值
	 * @param	colorHex
	 * @param	insertRed
	 * @return  替换24位红色通道值
	 * 
	 * @default is 128
	 */
	public static function setRed24(colorHex:uint, insertRed:uint = 128):uint
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
	public static function setBlue24(colorHex:uint, insertBlue:uint = 128):uint
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
	public static function setGreen24(colorHex:uint, insertGreen:uint = 128):uint
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
	public static function setAlpha32(colorHex:uint, insertAlpha:uint = 128):uint
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
	public static function setRed32(colorHex:uint, insertRed:uint = 128):uint
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
	public static function setGreen32(colorHex:uint, insertGreen:uint = 128):uint
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
	public static function setBlue32(colorHex:uint, insertBlue:uint = 128):uint
	{
		return (colorHex & 0xFFFFFF00) | (insertBlue);
	}
}
}