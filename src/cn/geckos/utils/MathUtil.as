package cn.geckos.utils
{
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
		return slope
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
	

}
}