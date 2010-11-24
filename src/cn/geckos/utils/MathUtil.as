package cn.geckos.utils
{
	import flash.geom.Point;
public class MathUtil
{

    /**
     * 弧度转换成角度  radians -> degrees
     *  
     * @param radians 弧度
     * @return 相应的角度
     */ 
    public static function rds2dgs(radians:Number):Number
    {
        return fixAngle(radians * 180/Math.PI);
    }

    /**
     * 角度转换成弧度 degrees -> radians
     *  
     * @param degrees 角度
     * @return 相应的弧度
     */ 
    public static function dgs2rds(degrees:Number):Number
    {
        return degrees * Math.PI/180;
    }
    
    /**
     * 标准化角度值，将传入的角度值返回成一个确保落在 0 ~ 360 之间的数字。
     * 
     * <pre>
     * MathUtil.fixAngle(380); // 返回 20
     * MathUtil.fixAngle(-340); // 返回 20
     * </pre>
     * 
     * 该方法详情可查看 《Flash MX 编程与创意实现》的第69页。
     */ 
    public static function fixAngle(angle:Number):Number
    {
        angle %= 360;
        
        if (angle < 0)
        {
            return angle + 360;
        }
        
        return angle;
    }
	
	/**
     *
     */ 
    public static function fixHalfAngle(angle:Number):Number
    {
        angle %= 180;
        
        if (angle < 0)
        {
            return angle + 180;
        }
        
        return angle;
    }
	
	/**
    * 求取阶乘
    */
    public static function getFactorial(num:uint):uint
    {
        if(num == 0) return 1;
        return num * getFactorial(num - 1);
    }
	
	/**
	 * 求乘方
	 * @param	num  
	 * @param	pow  乘方的次数
	 * @return  
	 */
    public static function power(num:Number, pow:Number):Number
    {
        if(pow == 0)  return 1;
        return num * power(num, pow - 1);
    }
	
	/**
     * 对一个数保留指定的小数位数, 然后四舍五入
     * @param	num
     * @param	interval 保留小数点后几位
     * @return  返回一个指定保留小数位的数(四舍五入)
     */
    public static function round(num:Number, interval:Number = .1):Number
    {
        return Math.round(num / interval) * interval;
    }
	
	/**
     * 对一个数保留指定的小数位数, 然后向下取整
     * @param	num
     * @param	interval 保留小数点后几位
     * @return  返回一个指定保留小数位的数(向下取整)
     */
    public static function floor(num:Number, interval:Number = .1):Number
    {
        return Math.floor(num / interval) * interval;
    }
	
	/**
     * 对一个数保留指定的小数位数, 然后向上取整
     * @param	num
     * @param	interval 保留小数点后几位
     * @return  返回一个指定保留小数位的数(向上取整)
     */
    public static function ceil(num:Number, interval:Number = .1):Number
    {
        return Math.ceil(num / interval) * interval;
    }
	
	/**
    * 返回num的绝对值
    * @param	num
    * @return  返回参数num的绝对值
    */
    public static function getAbsolute(num:Number):Number
    {
        return num < 0 ? -num : num;
    }
	
	 /**
     * 返回参数mainNum除以divided的余数
     * @param	mainNum
     * @param	divided
     * @return  返回参数mainNum除以divided的余数
     */
    public static function getRemainedNum(mainNum:Number, divided:Number):Number
    {
        return mainNum - ((mainNum / divided) >> 0) * divided;
    }
	
	/**
	 * 判断参数num是否是偶数
	 * @param	num
	 * @return  判断参数num是否是偶数
	 */
	public static function isEven(num:Number):Boolean
	{
		return Boolean(isEvenByDivided(num, 2));
	}
	
	/**
	 * 
	 * @param	num
	 * @param	divided
	 * @return  得到num除以divided后得到的余数
	 */
	public static function isEvenByDivided(num:Number, divided:Number):Number
	{
		return num & (divided - 1);
	}
	
	/**
	 * 斜率公式
	 * @param	x1 坐标点
	 * @param	y1 
	 * @param	x2
	 * @param	y2
	 * @return  相应的斜率
	 */
	public static function getSlope(x1:Number, y1:Number, x2:Number, y2:Number):Number
	{
		var slope:Number = (y1 - y2) / (x1 - x2);
		return slope;
	}
	
	/**
	 * 已知3边求出某边对应的角的角度
	 * CosC=(a^2+b^2-c^2)/2ab
	 * CosB=(a^2+c^2-b^2)/2ac
	 * CosA=(c^2+b^2-a^2)/2bc 
	 * 
	 * @param	a 边
	 * @param	b 边
	 * @param	c 边
	 * @return  一个对象包含三个对应的角度
	 */
	public static function threeSidesMathAngle(a:Number,b:Number,c:Number):Object
	{
		var cosA:Number = (c * c + b * b - a * a) / (2 * b * c);
		var A:Number = Math.round(MathUtil.rds2dgs(Math.acos(cosA)));
		
		var cosB:Number = (a * a + c * c - b * b) / (2 * a * c);
		var B:Number = Math.round(MathUtil.rds2dgs(Math.acos(cosB)));
		
		var cosC:Number = (a * a + b * b - c * c) / (2 * a * b);
		var C:Number = Math.round(MathUtil.rds2dgs(Math.acos(cosC)));
		
		return { "A":A, "B":B, "C":C };
	}
	
	/**
	 * 旋转公式
	 * @param	dx 旋转物体的x-中心点的x
	 * @param	dy 旋转物体的y-中心点的y
	 * @param	sin 根据角度求出sin
	 * @param	cos 根据角度求出cos
	 * @param	reverse 顺时针 逆时针
	 * @return  新的坐标
	 */
	public static function rotate(dx:Number, dy:Number, sin:Number, cos:Number, reverse:Boolean):Point
	{
		var point:Point = new Point();
		if (reverse) 
		{
			point.x = dx * cos + dy * sin;
			point.y = dy * cos - dx * sin;
		}
		else 
		{
			point.x = dx * cos - dy * sin;
			point.y = dy * cos + dx * sin;
		}
		return point;
	}

}
}