package cn.geckos.utils 
{
import flash.net.SharedObject;
/**
 * ...本地存储工具
 * @author ...Kanon
 * 
 * Sample
 * if (Cookie.read("username") == null) {
 *    Cookie.save("username", "jeff");
 * }
 *
 */
public class Cookie 
{
	//共享对象
	private static var so:SharedObject;
	//共享对象名字
	public static var name:String = "cookie";
	
	/**
	 * 初始化cookie
	 */
	private static function init():void 
	{
		if (!Cookie.so) 
			Cookie.so = SharedObject.getLocal(Cookie.name);
	}
	
	/**
	 * 保存数据
	 * @param	key		存储键值
	 * @param	value	需要存储的值
	 */
	public static function save(key:String, value:String):void
	{
        // TODO Add expire datetime
		Cookie.init();
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
        // TODO According to the expire datetime whether to delete this key or return it.
		Cookie.init();
		return Cookie.so.data[key];
	}
	
	/**
	 * 删除一条数据
	 * @param	key 数据对应的key
	 */
	public static function remove(key:String):void
	{
		Cookie.init();
		if (Cookie.so.data[key])
		{
			Cookie.so.data[key] = null;
			Cookie.so.flush();
			delete Cookie.so.data[key];
		}
	}
	
	/**
	 * 清除所有cookie数据
	 */
	public static function clearAll():void
	{
		Cookie.init();
		Cookie.so.clear();
	}
}
}
