package cn.geckos.utils 
{
import flash.events.TimerEvent;
import flash.utils.Timer;
/**
 * ...enterFrame工具
 * @author Kanon
 */
public class EnterFrame
{
	//计时器
	private static var timer:Timer;
	//存放方法列表
	private static var funList:Vector.<Function>;
	//是否初始化
	private static var isInit:Boolean;
	/**
	 * 初始化
	 * @param	fps	enterFrame执行的帧频
	 */
	public static function init(fps:int = 24):void
	{
		EnterFrame.funList = new Vector.<Function>();
		EnterFrame.timer = new Timer(int(1000 / fps));
		EnterFrame.timer.addEventListener(TimerEvent.TIMER, timerHandler);
		EnterFrame.isInit = true;
		EnterFrame.timer.start();
	}
	
	/**
	 * 实时执行函数
	 * @param	event
	 */
	private static function timerHandler(event:TimerEvent):void 
	{
		var length:int = EnterFrame.funList.length;
		var fun:Function;
		for (var i:int = 0; i < length; i += 1) 
		{
			fun = EnterFrame.funList[i];
			fun.apply();
		}
	}
	
	/**
	 * 添加一个需要实时执行的方法
	 * @param	fun	方法对象
	 */
	public static function push(fun:Function):void
	{
		if (!EnterFrame.isInit) return;
		if (EnterFrame.funList.indexOf(fun) == -1)
			EnterFrame.funList.push(fun);
	}
	
	/**
	 * 删除一个方法
	 * @param	fun	方法对象	
	 */
	public static function pop(fun:Function):void
	{
		if (!EnterFrame.isInit) return;
		var index:int = EnterFrame.funList.indexOf(fun);
		if (index == -1) return;
		EnterFrame.funList.splice(index, 1);
	}
	
	/**
	 * 暂停
	 */
	public static function pause():void
	{
		if (!EnterFrame.isInit) return;
		if (EnterFrame.timer.running)
			EnterFrame.timer.stop();
	}
	
	/**
	 * 播放
	 */
	public static function unPause():void
	{
		if (!EnterFrame.isInit) return;
		if (!EnterFrame.timer.running)
			EnterFrame.timer.start();
	}
	
	/**
	 * 查找存放的方法的索引	如果不存在则返回-1。
	 * @param	fun		查找的方法
	 * @return	索引
	 */
	public static function indexOf(fun:Function):int
	{
		return EnterFrame.funList.indexOf(fun);
	}
	
	/**
	 * 销毁enterFrame
	 */
	public static function destroy():void
	{
		if (EnterFrame.funList)
		{
			var length:int = EnterFrame.funList.length;
			for (var i:int = length - 1; i >= 0; i -= 1) 
			{
				EnterFrame.funList.splice(i, 1);
			}
			EnterFrame.funList = null;
		}
		if (EnterFrame.timer)
		{
			EnterFrame.timer.removeEventListener(TimerEvent.TIMER, timerHandler);
			EnterFrame.timer.stop();
			EnterFrame.timer = null;
		}
		EnterFrame.isInit = false;
	}
}
}