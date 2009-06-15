/////////////////////////////////////////////////////////
//  
//  用于处理常用的字符串操作(去除空白字符等)
//  http://gskinner.com/RegExr/ 在线测试正则表达式
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
	 * 
	 * @param	str
	 * @return
	 * 删除字符串2端空白字符串
	 * 
	 * 正则表达式中
	 * \s代表空白字符
	 * ^ 代表字符串开始位置
	 * $ 代表字符串末尾
	 * 
	 */
	 /*
	public static function trimB(str:String):String
	{
		var newStr:String = str.replace(/(^\s*)|(\s*$)/g, "");
		return newStr;
	}
	*/
	//////////////////////////////////////////////////////////////
	//
	// $n好比在正则表达式中使用\n来反向引用前面匹配的内容(被括号括起来的部分)
	//
	//////////////////////////////////////////////////////////////
	/*
	public static function trimC(str:String):String
	{
		var reg:RegExp = /^\s*(\S+(\s+\S+)*)\s*$/g;
		return str.replace(reg, "$1");
	}
	*/
	
	///////////////////////////////////////////////////////////
	//
	//  " " 一个空白字符
	//  \t  制表符
	//  \r  回车符
	//  \n  换行符
	//
	//////////////////////////////////////////////////////////
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


