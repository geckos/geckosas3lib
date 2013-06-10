package cn.geckos.utils 
{
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.IBitmapDrawable;
import flash.net.LocalConnection;
import flash.system.Capabilities;
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
	
	
	/**
	 * 改方法触发FlashPlayer触发GC, 可用于调试, Debug版本可使用
	 * System.gc()方法, 考虑GC阶段分为Mark-Sweep, 所以需要调用
	 * 2次
	 * grantskinner's hack method, don't use in release version
	 * @see could read gskinner's tech blog for this detail
	 */ 
	public static function gc():void{
		try{
			new LocalConnection().connect("__forceGCDoNotUseInReleaseVersionSWF");
			new LocalConnection().connect("__forceGCDoNotUseInReleaseVersionSWF");
		}
		catch(e:Error){
			trace("garbage collection is running");
		}
	}
	
	
	/**
	 * check current player's environment whether is debug
	 * 判断当前运行SWF的FlashPlayer环境是否为debug版本
	 */ 
	public static function isDebug():Boolean{
		return Capabilities.isDebugger;
	}
	
	/**
	 * 判断当前运行swf环境 为本地还是线上
	 */ 
	public static function isLocal():Boolean{
		return Boolean(Capabilities.playerType == "Desktop" || (new LocalConnection( ).domain == "localhost")); 
	}
	
	/**
	 * 检查当前运行在player中的swf文件是否为debug版本
	 * @return
	 */
	public static function isDebuggerSWF():Boolean {
		var s:String  = new Error().getStackTrace();
		if (s == null) {
			return false;
		}
		return s.search(/.as:[0-9]+]$/m) != -1;
	}
	
	
	/**
	 * check variable is whether null
	 * 判定当前指定值是否为无意义的null值
	 * @param value 
	 */ 
	public static function isNull(value:*):Boolean{
		var s:String = getQualifiedClassName(value);
		return s == "null" || s == "void" || s == "undefined";
	}
	
	
	/**
	 * 判断指定的bitmapData对象是否可以访问 
	 * @param data
	 * @see ArgumentError: Error #2015: 无效的 BitmapData。
	 */ 
	public static function assertBitmapDataIsDispose(data:BitmapData):Boolean{
		if(data){
			try{
				data.width;
				data.height;
			}
			catch(e:ArgumentError){
				return true;
			}
			return false;
		}
		return true;
	}
	
	/**
	 * 判定指定显示对象是否为可显示状态
	 */ 
	public static function assertDisplayObjectIsMayVisible(dis:DisplayObject):Boolean{
		if(dis){
			return dis.visible && dis.alpha > 0 && dis.scaleX != 0 && dis.scaleY != 0 && dis.stage != null;
		}
		return false;
	}
	
	
	/**
	 * 获取指定显示对象容器中匹配指定类型的集合
	 * @param container 
	 * @param type
	 */ 
	public static function getChildByType(container:DisplayObjectContainer, type:Class):Array{
		if(!container || container.numChildren == 0){
			return null;
		}
		var ary:Array = [];
		var len:int = container.numChildren;
		while(--len > -1){
			var d:DisplayObject = container.getChildAt(len);
			if(d is type){
				ary.push(d);
			}
		}
		return ary;
	}
	
	/**
	 * 检查指定的实现IBitmapDrawable接口对象是否可以绘制
	 * DisplayObject和BitmapData均实现此接口
	 */ 
	public static function isCouldDraw(IBD:IBitmapDrawable):Boolean{
		if(IBD is DisplayObject){
			return (DisplayObject(IBD).width > 0) && (DisplayObject(IBD).height > 0);
		}
		if(IBD is BitmapData){
			return (BitmapData(IBD).width > 0) && (BitmapData(IBD).height > 0);
		}
		return false;
	}
}
}