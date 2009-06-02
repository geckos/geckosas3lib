/////////////////////////////////////////////////////////
//  
//  用于处理常用的字符串操作(去除空白字符等)
//  
////////////////////////////////////////////////////////

package cn.geckos.utils
{
public final class StringUtil
{
	/**
	 * 
	 * @param	str
	 * @return
	 * 根据给定unicode字符返回对应的字符串
	 */
	public static function showUnicodeStr(str:String):String
	{
		return String.fromCharCode(parseInt(str, 16));
	}
	
	/**
	 * @param	str
	 * @return
	 * 匹配中文字符
	 */
	public static function matchChineseWord(str:String):Array
	{
		//中文字符的unicode值[\u4E00-\u9FA5]
		var patternA:RegExp = /[\u4E00-\u9FA5]+/gim;
		return str.match(patternA);
	}
	
	/**
	 * 
	 * @param	target
	 * @return
	 * 去除字符串左端的空白字符
	 */
	public static function lTrim(target:String):String
	{
		var startIndex:int = 0;
		while (isWhiteSpace(target.charAt(startIndex)))
		{
			startIndex++;
		}
		return target.slice(startIndex, target.length);
	}
	
	/**
	 * 
	 * @param	target
	 * @return
	 * 去除字符串右端的空白字符
	 */
	public static function rTrim(target:String):String
	{
		var endIndex:int = target.length - 1;
		while (isWhiteSpace(target.charAt(endIndex))) 
		{
			endIndex --;
		}
		return target.slice(0, endIndex + 1);
	}
	
	
	/**
	 * 返回一个去除2段空白字符的字符串
	 * @param	target
	 * @return  返回一个去除2段空白字符的字符串
	 */
	public static function trim(target:String):String
	{
		var startIndex:int = 0;
		while(isWhiteSpace(target.charAt(startIndex)))
			startIndex++;
	
		var endIndex:int = target.length - 1;
		while(isWhiteSpace(target.charAt(endIndex)))
			endIndex--;
	
		return target.slice(startIndex, endIndex + 1);
	}
	
	/**
	 * 返回该字符是否为空白字符
	 * @param	str
	 * @return  返回该字符是否为空白字符
	 */
	public static function isWhiteSpace(str:String):Boolean
	{
		if (str == " " || str == "\t" || str == "\r" || str == "\n")
		{
			return true;
		}
		return false;
	}
	
	/**
	 * 返回执行替换后的字符串
	 * @param	mainStr   待查找字符串
	 * @param	targetStr 目标字符串
	 * @param	replaceStr 替换字符串 
	 * @param	caseMark  是否忽略大小写
	 * @return  返回执行替换后的字符串
	 */
	public static function replaceMatch(mainStr:String, targetStr:String, 
										replaceStr:String, caseMark:Boolean = false):String
	{
		var len:int = mainStr.length;
		var tempStr:String = "";
		var isMatch:Boolean = false;
		var tempTarget:String = caseMark == true ? targetStr.toLowerCase() : targetStr;
		for (var i:int = 0; i < len; i++)
		{
			isMatch = false;
			if (mainStr.charAt(i) == tempTarget.charAt(0))
			{
				if (mainStr.substr(i, tempTarget.length) == tempTarget)
				{
					isMatch = true;
				}
			}
			if (isMatch)
			{
				tempStr += replaceStr;
				i = i + tempTarget.length - 1;
			}
			else 
			{
				tempStr += mainStr.charAt(i);
			}
		}
		return tempStr;
	}
}
}


