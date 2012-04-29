package cn.geckos.utils
{
import flash.utils.getDefinitionByName;
import flash.utils.getQualifiedSuperclassName;
/**
 * ...类工具
 * @author kanon
 */
public class ClassUtil 
{
	/**
	 * 判断某个类是是否属于某个父类
	 * @param type  类型
	 * @param superClass 超类
	 */
	public static function isSubclassOf(type:Class, superClass:Class):Boolean
	{
		if (superClass == Object)
		{
			return true;
		}
		try
		{
			for (var c:Class = type; c != Object; c = Class(getDefinitionByName(getQualifiedSuperclassName(c))))
			{
				if (c == superClass)
				{
					return true;
				}
			}
		}
		catch(e:Error)
		{
		}
		return false;
	}
}
}