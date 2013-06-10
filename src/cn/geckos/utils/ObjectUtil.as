package cn.geckos.utils
{
import flash.net.registerClassAlias;
import flash.utils.ByteArray;
import flash.utils.describeType;
import flash.utils.getDefinitionByName;
import flash.utils.getQualifiedClassName;
import flash.system.System;

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
	
	
	/**
	 * 复制一个复杂类型对象, 但是如果被复制属性值为复杂类型, 那么该复制仍旧为浅复制。
	 * @param source
	 * @param target
	 * @note 不包含静态属性或者私有, 保护属性
	 */
	public static function copyComplex(source:Object, target:Object):void{
		var sourceClstr:String = getQualifiedClassName(source);
		if(sourceClstr == getQualifiedClassName(target)){
			var variableList:XML = describeType(source);
			var len:int, propertyName:String, currentValue:*, type:Class;
			var list:XMLList = variableList.*.(name() == "variable" || (name() == "accessor" && 
				(attribute("access") == "writeonly" || attribute("access") == "readwrite")));
			if(list && list.length() > 0){
				len = list.length();
				while(--len > -1){
					propertyName = String(list[len].@name);
					currentValue = target[propertyName]; 
					type = getDefinitionByName(String(list[len].@type)) as Class;
					source[propertyName] = type(currentValue);
				}
			}
			System.disposeXML(variableList);
		}
	}
	
	/**
	 * 清除指定对象中的动态属性
	 * @param target
	 */
	public static function clear(target:Object):void{
		for(var item:* in target){
			delete target[item];
		}
	}
	
	/**
	 * 获取指定对象的类名字符串格式
	 * @param instanceOrClass
	 * @param singleDot
	 * @return 
	 */
	public static function getCompleteClassName(instanceOrClass:*, singleDot:Boolean = true):String{
		var clsName:String = getQualifiedClassName(instanceOrClass);
		if(clsName && singleDot){
			clsName = clsName.split("::").join(".");
		}
		return clsName;
	}
	
	
	/**
	 * 获取指定对象的包名字符串
	 * @param runIn
	 * @return 
	 */
	public static function getPackageName(obj:Object):String{
		var name:String = getQualifiedClassName(obj);
		return name.substring(0, name.indexOf("::"));
	}
	
	/**
	 * 判断指定值对象是否为简单类型对象 
	 * @param value
	 * @return 
	 */
	public static function checkIsPrimitive(value:Object):Boolean{
		var s:String = typeof value;
		return s == "boolean" || s == "number" || s == "string";
	}
	
	/**
	 * 判定指定类是否实现指定接口 
	 * @param cl
	 * @param interfaces
	 * @return 
	 */
	public static function checkIsImplementsInterface(cl:Class, interfaces:Class):Boolean{
		var xml:XML = describeType(cl);
		var isImpl:Boolean = xml.factory.implementsInterface.(@type == getQualifiedClassName(interfaces)).length() > 0;
		System.disposeXML(xml);
		return isImpl;
	}
}
}