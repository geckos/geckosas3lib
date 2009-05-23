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
	 * 返回一个去除2段空白字符的字符串
	 * @param	target
	 * @return  返回一个去除2段空白字符的字符串
	 */
	public static function trim(target:String):String
	{
		var startIndex:Number = 0;
		while(isWhiteSpace(target.charAt(startIndex)))
			startIndex++;
	
		var endIndex:Number = target.length - 1;
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
		var len:Number = mainStr.length;
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


