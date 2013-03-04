package cn.geckos.utils
{
public final class StringUtil
{
    /**
     * 
     * @param    str
     * @return
     * 根据给定unicode字符返回对应的字符串
     */
    public static function showUnicodeStr(str:String):String
    {
        return String.fromCharCode(parseInt(str, 16));
    }
    
    /**
     * @param    str
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
     * @param    target
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
     * @param    target
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
     * @param    target
     * @return  返回一个去除2段空白字符的字符串
     */
    public static function trim(target:String):String
    {
        if (target == null)
        {  
            return null;  
        }  
        return rTrim(lTrim(target));
    }
    
    /**
     * 
     * @param    str
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
     * @param    str
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
     * @param    mainStr   待查找字符串
     * @param    targetStr 目标字符串
     * @param    replaceStr 替换字符串 
     * @param    caseMark  是否忽略大小写
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
    
    private static var specialSigns:Array = [
        '&', '&amp;',
        '<', '&lt;',
        '>', '&gt;',
        '"', '&quot;',
        "'", '&039;',
        '®', '&reg;',
        '©', '&copy;',
        '™', '&trade;',
    ];
    
    /**
     * 用html实体换掉字符窜中的特殊字符
     * @param str
     * @return 
     * 
     */
    public static function htmlSpecialChars(str:String):String
    {
        var len:Number = specialSigns.length;
        for( var i:Number = 0; i < len; i += 2 )
        {
            var from:String = specialSigns[i];
            var to:String = specialSigns[i+1];
            str = str.replace(from, to);
        }
        
        return str;
    }
    
    /**
     * 给数字字符前面添 "0"
     * 
     * <pre> 
     * 
     * trace( StringFormat.zfill('1') );
     * // 01
     * 
     * trace( StringFormat.zfill('16', 5) );
     * // 00016
     * 
     * trace( StringFormat.zfill('-3', 3) );
     * // -03
     * 
     * </pre>
     * 
     * @param str 要进行处理的字符串
     * @param width 处理后字符串的长度，
     *              如果str.length >= width，将不做任何处理直接返回原始的str。
     * @return 
     * 
     */
    public static function zfill(str:String, width:uint = 2):String
    {
        if( !str ) {
            str;
        }
        
        var slen:Number = str.length;
        if( slen >= width ) {
            return str;
        }
        
        var negative:Boolean = false;
        if( str.substr(0, 1) == '-' ) {
            negative = true;
            str = str.substr(1);
        }
        
        var len:Number = width - slen;
        for( var i:Number = 0; i < len; i++ )
        {
            str = '0' + str;
        }
        
        if( negative ) {
            str = '-' + str;
        }
        
        return str;
    }
    
    /**
     * 字符变量替换
     * 用 args中的变量值替换掉 str 中的占位符，
     * args 有2种方式，一种是直接在 str 后跟任意个数的字符串参数，
     * 占位符用 类似 {0}, {1} ... 表示，之后分别会被 str 后的的参数替换 
     * 
     * args 还可以是一个对象，但这时候占位符花括号间可以是对象的属性名
     * 类似 {name} ，这样就会被args[0].name 替换
     * 
     * <pre>
     * 
     * var s:String = 'name is {0}, age is {1}.';
     * trace( StringFormat.format(s, 'harry', '23') );
     * // name is harry, age is 23.
     * 
     * s = 'flash is a {type}, which use {lang}, aha, \\{test\\}';
     * trace( StringFormat.format(s, {'type':'software', 'lang':'ActionScript'}) );
     * // flash is a software, which use ActionScript, aha, {test}
     * 
     * </pre>
     * 
     * @param str 要进行格式化的字符串
     * @param args 替换str中占位符的参数
     * @return 格式化后的字符串
     * 
     */
    public static function format(str:String, ...args):String
    {
        if( !args || args.length==0 ) 
        {
            return str;
        }
        
        var isDictArg:Boolean = false;
        var sArgs:Object = args;
        
        if(!(args[0] is String)) 
        {
            sArgs = args[0];
            isDictArg = true;
        }
        
        var pattern:RegExp = /(?<!\\)\{[^{}]*[^\\]\}/gim;
        
        str = str.replace(pattern, function(match:String, ...args):String {
            var key:* = match.substring(1, match.length - 1);
            if(!isDictArg) 
            {
                key = Number(key);
                return sArgs[key];
            }
            else
            {
                return getObjectAttr(key, sArgs);
            }
        });
        
        str = str.replace(/\\{/gm, '{');
        str = str.replace(/\\}/gm, '}');
        
        return str;
    }
    
    public static function getObjectAttr(attrExp:String, object:Object):*
    {
        var attrs:Array = attrExp.split('.');
        var o:Object = object;
        for each (var attr:String in attrs)
        {
            if (o.hasOwnProperty(attr))
            {
                o = o[attr];
            }
            else
            {
                return null;
            }
        }
        
        return o;
    }
    
    
    /** 
     * 是否是数值字符串;  
     * @param    char 字符串
     * @return  是否是数值字符串
     */
    public static function isNumber(char:String):Boolean
    {  
        if (char == null)
        {  
            return false;  
        }  
        return isDouble(char) || isInteger(char) || isHex(char); 
    } 
    
    /**
     * 是否为Double型数据
     * @param    char 字符串
     * @return    是否为Double型数据;
     */
    public static function isDouble(char:String):Boolean 
    {
        var pattern:RegExp =/^[-\+]?\d+(\.\d+)?$/;
        var result:Object = pattern.exec(char);
        
        return !(result == null);
    }
    
    
    /**
     * Integer 是否为整型
     * @param    char 字符串
     * @return
     */
    public static function isInteger(char:String):Boolean 
    {
        var pattern:RegExp =/^[-\+]?\d+$/;
        var result:Object = pattern.exec(char);
        
        return !(result == null);
    }
    
    /**
     * 是否为16进制
     * @param    char 字符串
     * @return    是否为16进制
     */
    public static function isHex(char:String):Boolean 
    {
        var pattern:RegExp =/^[0-9A-Fa-f]+$/;
        var result:Object = pattern.exec(char);
        
        return !(result == null);
    }
    
    
    /**
     * 是否为Email地址
     * @param    char 字符串
     * @return  是否为Email地址
     */
    public static function isEmail(char:String):Boolean
    {  
        if (char == null)
        {  
            return false;  
        }  
        char = trim(char);
        var pattern:RegExp = /(\w|[_.\-])+@((\w|-)+\.)+\w{2,4}+/;   
        var result:Object = pattern.exec(char);  
        
        if (result == null) 
        {  
            return false;  
        }  
        return true;  
    }  
    
	/**
	 * 翻转字符串
	 * @param	str 字符串
	 * @return  翻转后的字符串
	 */
	public static function reverse(str:String):String
	{
		if (str.length > 1)  
           return reverse(str.substring(1)) + str.substring(0, 1);  
       else  
           return str;   
	}
	
	/**
	 * 获得字符串的字节长度
	 * @param	str  字符串
	 * @return  长度
	 */         
	public static function getByteLen(str:String):int 
	{
        var len:int = -1;
        if (str)
		{
			var ba:ByteArray = new ByteArray();
			//如果使用的是UTF8的编码，用这个可以得到
			ba.writeMultiByte(str, "UTF-8");
			len = ba.length;
        }
        return len;
	}
}
}


