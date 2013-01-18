package cn.geckos.utils 
{
import flash.utils.getTimer;
/**
 * ...调试工具
 * @author Kanon
 */
public class DebugUtil 
{
	/**
	 * 方法运行的时间
	 * example  DebugUtil.functionTiming(Math.floor, 10000, [99.9])
	 * @param   fun 被测函数
	 * @param   forTime 重复次数
	 * @param   params 函数参数
	 * @param   thisArg 函数指向的对象
	 * @return 	总用时(ms)
	 */
	public static function functionTiming(fun:Function, forTime:int = 1, params:Array = null, thisArg:*= null):int
	{
		var time:int = getTimer();
		while(forTime)
		{
			fun.apply(thisArg, params);
			forTime--;
		}
		return getTimer() - time;
	}
}
}