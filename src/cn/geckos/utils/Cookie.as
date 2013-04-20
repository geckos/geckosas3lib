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
 * Expire Sample
 * var d:Date = new Date();
 * Cookie.save("username", "jeff", d.time + 3600 * 1000); // Save data by key username for 1 hour
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
     * @param   expireDatetime  过期日期时间的时间戳，单位为毫秒，Date.time
	 */
	public static function save(key:String, value:String, expireDatetime:Number=0):void
	{
        if (expireDatetime > 0) {
            value = expireDatetime + "@" +  value;
        }
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
		Cookie.init();
        var value:String = Cookie.so.data[key];
        if (value && value.indexOf("@") == 13) {
            var results:Array = value.split("@");
            var expireDatetime:Number = Number(results[0].substring(0, 13));
            if (isNaN(expireDatetime)) {
                // 前13位不是过期日期时间的毫秒数
                return value;
            } else {
                var now:Date = new Date();
                if (now.time > expireDatetime) {
                    // 过期了
                    remove(key);
                    return null;
                } else {
                    return results[1];
                }
            }
        }
		return value;
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
