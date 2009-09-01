/**
 * ...
 * 
 * 毫秒转换工具
 * @author Kanon
 */
package cn.geckos.utils 
{	
public final class TimeFormat
{
	/**
	 *
	 * @param	time 秒数    
	 * @param	partition 分隔符
	 * @return  返回一个以分隔符分割的时, 分, 秒
	 * 
	 * 比如: time = 4351; secondToTime(time)返回字符串01:12:31;
	 */
	public static function secondToTime(time:Number = 0, partition:String = ":"):String
	{
		var hours:int = time / 3600;
		var minutes:int = time % 3600 / 60;
		var seconds:int = time % 3600 % 60;
		
<<<<<<< .mine
		//trace(hours, minutes, seconds);
		
=======
>>>>>>> .r135
		var h:String = String(hours);
		var m:String = String(minutes);
		var s:String = String(seconds);
		
		if (hours < 10)  h = "0" + h;
		if (minutes < 10) m = "0" + m;
		if (seconds < 10) s = "0" + s;
		
		var timeStr:String = h + partition + m + partition + s;
		return  timeStr;
	}
	
	/**
	 *
	 * @param	time  以指定分隔符分割的时间字符串
	 * @param	partition  分隔符
	 * @return  毫秒数显示的字符串
	 * 
	 * 用法1 trace(MillisecondTransform.timeToMillisecond("00:60:00")) 
	 * 输出   3600000 
	 * 
	 * 
	 * 用法2 trace(MillisecondTransform.timeToMillisecond("00.60.00",".")) 
	 * 输出   3600000 
	 */
	public static function timeToMillisecond(time:String, partition:String = ":"):String
	{
		var _ary:Array = time.split(partition);
		var timeNum:int = 0;
		var len:uint = _ary.length;
		for (var i:uint = 0; i < len; i++)
		{
			timeNum += _ary[i] * Math.pow(60, (len - 1 - i));
		}
		timeNum *= 1000;
		return String(timeNum);
	}
}
}