package cn.geckos.utils 
{
/**
 * 毫秒转换工具
 * @author Kanon
 */
public final class TimeFormat
{
    /**
     * 秒数转换为时间形式。
     * @param	time 秒数    
     * @param	partition 分隔符
     * @param	showHour  是否显示小时
     * @return  返回一个以分隔符分割的时, 分, 秒
     * 
     * 比如: time = 4351; secondToTime(time)返回字符串01:12:31;
     */
    public static function secondToTime(time:Number = 0, partition:String = ":", showHour:Boolean = true):String
    {
        var hours:int = time / 3600;
        var minutes:int = time % 3600 / 60;
        var seconds:int = time % 3600 % 60;
        
        var h:String = String(hours);
        var m:String = String(minutes);
        var s:String = String(seconds);
        
        if (hours < 10)  h = "0" + h;
        if (minutes < 10) m = "0" + m;
        if (seconds < 10) s = "0" + s;
		
		var timeStr:String;
		if (showHour)
			timeStr = h + partition + m + partition + s;
		else
			timeStr = m + partition + s;
		
        return  timeStr;
    }
    
    /**
     * 时间形式转换为秒数。
     * @param   time  以指定分隔符分割的时间字符串
     * @param   partition  分隔符
     * @param   strict  严谨模式（默认开启），如果给定时间格式不符合规范将抛出异常
     * @return  毫秒数显示的字符串
     * @throws  Error Exception
     * 
     * 用法1 trace(MillisecondTransform.timeToMillisecond("00:60:00"))
     * 输出   3600000
     * 
     * 
     * 用法2 trace(MillisecondTransform.timeToMillisecond("00.60.00","."))
     * 输出   3600000
     */
    public static function timeToMillisecond(time:String, partition:String = ":", strict:Boolean=true):String
    {
        var _ary:Array = time.split(partition);
        var timeNum:int = 0;
        var len:uint = _ary.length;
        for (var i:uint = 0; i < len; i++)
        {
            var n:Number = _ary[i];
            if (strict) 
            {
                if (i == 0 && (n > 12 || n < 0)) 
                    throw new Error("The hour section must be lower or equal than 12 and greater or equal than 0!");
                else if (i == 1 && (n > 59 || n < 0)) 
                    throw new Error("The minute section must be lower or equal than 12 and greater or equal than 0!");
                else if (i == 2 && (n > 59 || n < 0)) 
                    throw new Error("The second section must be lower or equal than 12 and greater or equal than 0!");
            }
            timeNum += n * Math.pow(60, (len - 1 - i));
        }
        timeNum *= 1000;
        return String(timeNum);
    }
}
}
