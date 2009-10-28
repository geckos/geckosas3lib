/////////////////////////////////////
//
//
//  在as3中模拟抽象类实现
//   
//
/////////////////////////////////////
package cn.geckos.api
{

import flash.utils.getQualifiedClassName;
import flash.utils.describeType;

public class AbstractClassUtil
{
	/**
	*  用于检测抽象类构造函数
	*
	*  将此方法放入某个需要实现抽象机制的抽象类的构造函数, 如果返回true, 则抛出异常
	*
	*  param@ obj  抽象类对象
	*  param@ checkClass 抽象类类对象
	*  
	*  举例:
	*  class abstractClass
	*  {
	* 	  function abstractClass()
	* 	  {
	* 		 AbstractClassUtil.checkForAbstractClassConstructor(this, abstractClass);	
	*     }
	*  }
	*  在抽象类构造函数中放入ClassInfo.checkForAbstractClassConstructor(this, abstractClass);
	**/
	public static function checkForAbstractClassConstructor(obj:Object, checkClass:Class):Boolean
	{
		//trace(obj, obj.constructor, checkClass);
		//[object B] [class B] [class A]
		return (obj.constructor == checkClass);
	}
	
	/**
	*
	*   用于检测抽象方法是否被实现子类所覆盖
	*   TODO
	*   @param obj  抽象类对象
	*   @param abstractFunctionNameAry  需要检测的抽象方法(将方法名的字符串形式放入该数组)
	*
	*   举例: 抽象类中有三个"抽象"方法
	*   abstractA, abstractB, abstractC
	*   
	*   可以在抽象类中那么书写(书写在该类的构造函数中)
	*   if(!AbstractClassUtil.checkForAbstractClassFunction(this, ["abstractA", "abstractB", "abstractC"]))
	*	{
	*		throw new Error("Error");
	*	}
	* 
	**/
	public static function checkForAbstractClassFunction(obj:Object, abstractFunctionNameAry:Array):Boolean
	{
		var reflectionXML:XML = describeType(obj);
		var list:XMLList = reflectionXML.method;
		
		for (var item:String in abstractFunctionNameAry)
		{
			var declaredStr:String = list[item].@declaredBy.toXMLString();
			if(declaredStr.slice(getMatchIndex(declaredStr, "::") + 2, declaredStr.length) != getClassName(obj))
			{
				return false;
			}	
		}
		return true;
	}
	
	
	
	/**
	*  @param obj  
	*  @return 待返回的类名
	*/
	private static function getClassName(obj:Object):String
	{
		var qualifiedClassName:String = getQualifiedClassName(obj);
		return qualifiedClassName != "null" ? 
			   qualifiedClassName.slice(getMatchIndex(qualifiedClassName, "::") + 2, qualifiedClassName.length) : "null";
	}
	
	private static function getMatchIndex(mainStr:String, matchStr:String):int
	{
		return mainStr.indexOf(matchStr);
	}
}
}