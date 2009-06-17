package cn.geckos.utils 
{
	
/**
 * ...
 * 
 * 毫秒转换工具
 * @author Kanon
 */
public class  MillisecondTransform
{

	public function MillisecondTransform()
	{
		
		
	}
	
	/**
	 * 将秒数转换成00:00形式或者00:00:00
	 * @param	time 秒数
	 * @return
	 */
	public static function millisecondToTime(time:Number = 0):String
	{
		if (time == 0)
		{
			return  00 + ":" + 00;
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
			return  m + ":" + s;
		else
			return  h + ":" + m + ":" + s;
	}
	
	private function toString(s:Number):String
	{
		return "";
	}
}
	
}