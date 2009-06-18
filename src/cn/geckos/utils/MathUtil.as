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
	

}
}