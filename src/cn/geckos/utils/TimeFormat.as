package cn.geckos.utils 
{	
/**
 * ...
 * 
 * 毫秒转换工具
 * @author Kanon
 */
public class  TimeFormat
{
	public function TimeFormat()
	{
		
		
	}
	/**
	 * 将秒数转换成00符号00形式或者00符号00符号00
	 * @param	time 秒数
	 * @param	partition 符号
	 * @return  00符号00形式或者00符号00符号00
	 */
	public static function secondToTime(time:Number = 0, partition:String = ":"):String
	{
		if (time == 0)
		{
			return  00 + partition + 00;
		}
		var hours:int = time / 3600;//格式化输出格式
		
		var minutes:int = time % 3600 / 60;
		
		var seconds:int = time % 3600 % 60;
		
		trace(hours, minutes, seconds);
		
		var h:String = String(hours);
		var m:String = String(minutes);
		var s:String = String(seconds);
		
		if (hours < 10)  h = "0" + h;
		
		if (minutes < 10) m = "0" + m;
		
		if (seconds < 10) s = "0" + s;
		
		if (hours == 0)
			return  m + partition + s;
		else
			return  h + partition + m + partition + s;
	}
	/**
	 * 00符号00或者00符号00符号00形式转换成毫秒数
	 * @param	time  00符号00或者00符号00符号00形式
	 * @param	partition  符号
	 * @return  毫秒数显示的字符串
	 * 
	 * 用法1 trace(TimeFormat.timeToMillisecond("00:60:00")) 
	 * 输出   216000 
	 * 
	 * 
	 * 用法2 trace(TimeFormat.timeToMillisecond("00.60.00",".")) 
	 * 输出   216000 
	 */
	public static function timeToMillisecond(time:String, partition:String = ":"):String
	{
		var ary:Array = time.split(partition);
		if (ary.length <= 1) return "error:partition参数与输入不符";
		if (ary.length <= 2) ary.unshift(0);
		
		var timeStr:int
		var index:uint = ary.length - 1;
		for (var i:uint = 0; i < ary.length; i++)
		{
			if (i > 0 && ary[i] > 60)
			{
				return "error:time形式错误";
			}
			timeStr += ary[i] * 1000 * Math.pow(60, index);
			index--;
		}
		//trace(timeStr);
		return String(timeStr);
	}
	
	
}
}