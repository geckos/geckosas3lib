package cn.geckos.utils 
{
import flash.net.SharedObject;
/**
 * ...本地存储工具
 * @author ...Kanon
 */
public class Cookie 
{
	//共享对象
	private static var so:SharedObject;
	//共享对象名字
	private static const name:String = "cookie";
	/**
	 * 初始化
	 */
	public static function init(name:String = ""):void
	{
		if (!name) name = Cookie.name;
		Cookie.so = SharedObject.getLocal(name);
	}
	
	/**
	 * 保存数据
	 * @param	key		存储键值
	 * @param	value	需要存储的值
	 */
	public static function save(key:String, value:String):void
	{
		if (!Cookie.so) return;
		Cookie.so.data[key] = value;
		Cookie.so.flush();
	}
	
	/**
	 * 读取数据
	 * @param	key		存储键值
	 * @return	需要读取的数据
	 */
	public static function read(key:String):String
	{
		if (!Cookie.so) return null;
		return Cookie.so.data[key];
	}
}
}