/////////////////////////////////////////////////////////
//  
//  用于处理常用的数值的操作(阶乘, 求余数, 多次方等)
//  
////////////////////////////////////////////////////////

package cn.geckos.utils
{
public final class NumberUtil
{
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
	 * 将十进制数打印为需要的进制数
	 * 
	 * @param	num
	 * @param	convert
	 * @return  把一个十进制数转换成一个指定进制的数
	 */
    public static function printConversionNum(num:uint, convert:uint):String
    {
         if(convert == NumberType.NUMBER_DECIMAL) return num.toString(10);
		 
         var value:Number = num;
         var resultAry:Array = new Array();
         var index:Number = 0;  
         while(value != 0)
         {
                var remainNum:Number = value % convert;
                value = ((num /= convert) >> 0);
                resultAry[index++] = remainNum;
         }
         var str:String = "";
         for(var i:uint = resultAry.length - 1; i >= 0; i--)
         {
                var tempStr:String = String(resultAry);
                str += tempStr.length > 1 ?    String.fromCharCode(Number(tempStr) + 87) : tempStr;                                            
         }
         return str.toUpperCase();
    }
}
}