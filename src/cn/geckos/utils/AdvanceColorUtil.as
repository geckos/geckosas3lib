////////////////////////////////////////////////////////////////
//  
//  用于处理一般的色彩操作, 目前的问题是缺少设置色相, 饱和度, 对比度
//  
////////////////////////////////////////////////////////////////

package cn.geckos.utils
{

import flash.geom.ColorTransform;
import flash.filters.ColorMatrixFilter;
import cn.geckos.utils.MathUtil;


public final class AdvanceColorUtil
{
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
	 * 设置反相效果
	 * @param	pic
	 * @return  返回一个ColorTransform对象
	 */
	public static function setReverseTransform():ColorTransform
	{
		return new ColorTransform( -1, -1, -1, 1, 0xFF, 0xFF, 0xFF, 0);
	}
	
	/**
	 * 根据给定的范围设置反相效果
	 * @param	num   范围 0 - 100
	 * @return  
	 * 此方法采用了flash设计面板中的高级色彩应用
     * 取值范围 0 - 100
	 */
	public static function setNegativeTransform(num:int):ColorTransform
	{
		num = getGoodValue(0, 100, num);
		var offset:Number = Math.round(num * (0xFF / 100));
		return new ColorTransform( -1, -1, -1, 1, offset, offset, offset, 0);
	}
	
	/**
	 * 
	 * @param	transform
	 * @return
	 * 返回设置过的反相效果的效果值(0 - 100)
	 */
	public static function getNegativeCount(transform:ColorTransform):int
	{
		return transform.redOffset * (100 / 0xFF);
	}
	

	/**
	 * 设置透明度
	 * @param	alpha   范围 0 - 100
	 * @return  设置透明度的ColorTransform对象
	 * 此方法实现了flash设计面板中的Alpha功能
     * 取值范围 0 - 100
	 */
	public static function setAlphaTransform(alpha:int):ColorTransform
	{
<<<<<<< .mine
		if (alpha < 0) alpha = 0;
		else if (alpha > 100) alpha = 100;
		
		var alphaOffset:Number = MathUtil.round(255 / 100 * alpha);
=======
		alpha = getGoodValue(0, 100, alpha);
		var alphaOffset:Number = MathUtil.round(255 / 100 * alpha);
>>>>>>> .r148
		return new ColorTransform(1, 1, 1, 0, 0, 0, 0, alphaOffset);
	}
	
	
   /**
	 * 设置色彩
	 * @param	hex
	 * @param	count  范围 0 - 100
	 * @return  设置给定色彩值容量的ColorTransform对象
	 * 此方法实现了flash设计面板中的设置色彩(tint)的功能
     * 取值范围 0 - 100
	 */
	public static function setTintTransform(hex:uint, count:int):ColorTransform
	{
		var tintform:ColorTransform;
		
		var r:uint = ColorUtil.getRed(hex);
		var g:uint = ColorUtil.getGreen(hex);
		var b:uint = ColorUtil.getBlue(hex);
		
		count = getGoodValue(0, 100, count);
		
		var multiPlier:Number = 1 - (count / 100);
		
		var redOffset:Number = Math.round(r * (count / 100));
		var greenOffset:Number = Math.round(g * (count / 100));
		var blueOffset:Number = Math.round(b * (count / 100));
		
		tintform = new ColorTransform(multiPlier, multiPlier, multiPlier,  1, 
										redOffset, greenOffset, blueOffset, 0);
		return tintform;
	}
	
	/**
	 * 
	 * @param	hex
	 * @param	count  范围 0 - 100
	 * @return  获得指定色彩的色彩量的色彩值
     * 取值范围 0 - 100
	 */
	public static function getTint(hex:uint, count:int):uint
	{
		count = getGoodValue(0, 100, count);
		
		var r:uint = Math.round(ColorUtil.getRed(hex) * (count / 100));
		var g:uint = Math.round(ColorUtil.getGreen(hex) * (count / 100));
		var b:uint = Math.round(ColorUtil.getBlue(hex) * (count / 100));
		return ColorUtil.get24Hex(r, g, b);
	}
	
	
	/**
	 * 设置亮度(ColorTransform)
	 * @param	bright   范围 -100 - 100
	 * @return  返回一个ColorTransform对象
	 * 此方法实现了flash设计面板中的设置亮度(lightness)的功能
     * 取值范围-100 - 100
 	 */
	public static function setLightnessTransform(bright:int = 100):ColorTransform
	{
		var cTransForm:ColorTransform;
		var multiPlier:Number = bright / 100;
		
        multiPlier = getGoodValue(-1, 1, multiPlier);
		
		var multiPlierPercent:Number = 1 - MathUtil.getAbsolute(multiPlier);
	
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
	 * 
	 * @param	transform
	 * @return  返回当前的亮度值(-100 - 100)
	 * 注意1 - .2 = .8
	 * 而1 - .8 = 0.19999999999999996, 所以需要使用Math修正(舍入误差)
	 */
	public static function getLightCount(transform:ColorTransform):int
	{
		var light:int = Math.round((1 - transform.redMultiplier) * 100);
		return transform.redOffset == 0 ? -light : light;
	}
	

	/**
	 * 根据给定的r, g, b生成一个ColorTransform对象 范围 0 - 100
	 * @param	r
	 * @param	g
	 * @param	b
	 * @return  返回一个ColorTransform对象
	 * 此方法实现了flash设计面板中的设置色彩(tint)的功能, 给出r, g, b
	 * count数值范围为0 - 100
	 */
	public static function setRGBMixTransform(r:int, g:int, b:int, count:uint):ColorTransform
	{
		count = getGoodValue(0, 100, count);

		var offsetMultiphy:Number = count / 100;
		var multiplier:Number = 1 - offsetMultiphy;
		
		var redOffset:Number = Math.max(Math.min(r, 0xFF), 0) * offsetMultiphy;
		var greenOffset:Number = Math.max(Math.min(g, 0xFF), 0) * offsetMultiphy;
		var blueOffset:Number = Math.max(Math.min(b, 0xFF), 0) * offsetMultiphy;
		var alphaOffset:Number = 0;
		
		return new ColorTransform(multiplier, multiplier, multiplier, 1, 
								  redOffset, greenOffset, blueOffset, alphaOffset);
	}
	
	
	/**
	 * 返回一个图像的初始状态
	 * @return 返回ColorTransform对象的初始状态
	 * 此方法实现了flash设计面板中的none, 回归原始状态的功能
	 */
	public static function setColorInitialize():ColorTransform
	{
		return new ColorTransform(1, 1, 1, 1, 0, 0, 0, 0);
	}
	
    /**
    * 提供取值范围
    *
    */
	private static function getGoodValue(min:int, max:int,value:int):int
	{
		return Math.min(max, Math.max(value, min));
	}
	
	////////////////////////////////////////////////////////////////////////
	//
	// 使用ColorMatrixFilter对象实现色相, 饱和度, 对比度
	//
	////////////////////////////////////////////////////////////////////////

	/**
	 * 去除饱和色(来自Mario Klingemann的ColorMatrix Class v1.2), "灰度"图像
	 * 
	 * @return 返回一个ColorMatrixFilter类对象
	 * 
	 * 产生灰色的图像
	 */
	public static function setDesaturateFilter():ColorMatrixFilter
	{
		var matrix:Array = [RED_LUMINANCE, GREEN_LUMINANCE, BLUE_LUMINANCE, 0, 0,
		                    RED_LUMINANCE, GREEN_LUMINANCE, BLUE_LUMINANCE, 0, 0,
							RED_LUMINANCE, GREEN_LUMINANCE, BLUE_LUMINANCE, 0, 0,
							0,             0,               0,              1, 0];
							
		return new ColorMatrixFilter(matrix);
	}
	

	/**
	 * 设置亮度值(ColorMatrixFilter)
	 * @param	value 范围 -100 - 100
	 * @return  返回设置亮度后的ColorMatrixFilter对象
	 * 
	 * 设置亮度 (模拟flash设计面板中的滤镜中的调整颜色中的亮度)
     * 取值范围-100 - 100
	 */
	public static function setBrightnessFilter(value:int = 100):ColorMatrixFilter
	{
		value = getGoodValue(-100, 100, value);
		var matrix:Array = [1, 0, 0, 0, value,
		                    0, 1, 0, 0, value,
							0, 0, 1, 0, value,
							0, 0, 0, 1, 0];
		return new ColorMatrixFilter(matrix);
	}

	/**
	 * 
	 * @param	value 范围 0 - 100
	 * @return  
	 * 通过ColorMatrixFilter来设置透明度
     * 取值范围0 - 100
	 */
	public static function setAlphaFilter(value:int):ColorMatrixFilter
	{
		value = getGoodValue(0, 100, value);
		var alpha:Number = value / 100;
		var matrix:Array = [1, 0, 0, 0, 0,
							0, 1, 0, 0, 0,
							0, 0, 1, 0, 0,
							0, 0, 0, matrix, 0];
		return new ColorMatrixFilter(matrix);
	}
	
	
}
}