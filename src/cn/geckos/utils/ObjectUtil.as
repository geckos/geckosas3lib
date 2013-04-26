package cn.geckos.utils
{
import flash.net.registerClassAlias;
import flash.utils.ByteArray;
import flash.utils.getDefinitionByName;
import flash.utils.getQualifiedClassName;
public class ObjectUtil
{
    public static function isEmpty(obj:Object)
    {
        if (obj == null || obj == undefined)
            return true;
        
        if (obj is Array || obj is Vector) 
            return obj.length == 0;
        
        if (obj is String) 
            return obj == '';
        
        for (var key:* in obj) {
            return false;
        }
        
        return true;        
    }
	
	/**
	 * 获取对象长度
	 * @param	o
	 * @return
	 */
	public static function getLength(o:Object):int
	{
		var count:int = 0;
		for (var key:* in o)
		{
			count++;
		}
		return count;
	}
	
	/**
	 * 深度拷贝对象
	 * @param	source  拷贝对象
	 * @return  新的对象
	 */
	public static function clone(source:Object):Object
	{
		//获取全名
		var typeName:String = getQualifiedClassName(source);
		//切出包名
		var packageName:String = typeName.split('::')[0];
		//获取Class
		var type:Class = getDefinitionByName(typeName) as Class;
		//注册Class
		registerClassAlias(packageName, type);
		var copier:ByteArray = new ByteArray();
		copier.writeObject(source);
		copier.position = 0;
		return copier.readObject();
	}
	
	/**
	 * 复制对象
	 * @param	obj	需要复制的对象
	 * @return	新的对象
	 */
	public static function copy(obj:Object):Object
	{
		var newObj:Object = { };
		if (!obj) return newObj;
		for (var key:String in obj) 
		{
			newObj[key] = obj[key];
		}
		return newObj;
	}
	
	/**
	 * 转换为数组
	 * @param	obj	需要转换的对象
	 * @return	转换后的数组
	 */
	public static function toArray(obj:Object):Array
	{
		if (!obj) return null;
		var newArr:Array = [];
		for each (var o:* in obj) 
		{
			newArr.push(o);
		}
		return newArr;
	}
	
}
}