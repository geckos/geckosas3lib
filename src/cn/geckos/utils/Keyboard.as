package cn.geckos.utils
{
/**
 * 键盘工具
 */
public final class Keyboard 
{
	//有效的键值列表
	private static const VALID_KEY_CODES:Object = 
	{ 
		//a-zA-Z
		65 : true,66 : true,67 : true,68 : true,69 : true,
		70 : true,71 : true,72 : true,73 : true,74 : true,75 : true,76 : true,77 : true,78 : true,79 : true,
		80 : true,81 : true,82 : true,83 : true,84 : true,85 : true,86 : true,87 : true,88 : true,89 : true,
		90 : true,
		//0-9
		48 : true,49 : true,50 : true,51 : true,52 : true,53 : true,54 : true,55 : true,56 : true,57 : true,
		//上下左右
		38 : true,40 : true,37 : true,39 : true,
		//Numpad 0-9
		96 : true, 97 : true, 98 : true, 99 : true, 100 : true, 101 : true, 102 : true, 103 : true, 104 : true, 105 : true,
		//其他键盘
		32: true, 36: true, 17:true, 107:true, 110:true, 111:true, 106:true,
		109:true, 189:true, 191:true, 222:true, 187:true, 220:true, 16:true, 17:true, 192:true
	};
	
	//键值对应的字符串
	private static const KEY_CODE_NAMES:Object = 
	{
		//a-zA-Z
		65 : 'a',66 : 'b',67 : 'c',68 : 'd',69 : 'e',
		70 : 'f', 71 : 'g', 72 : 'h', 73 : 'i', 74 : 'j', 75 : 'k', 76 : 'l', 77 : 'm', 78 : 'n', 79 : 'o', 
		80 : 'p', 81 : 'q', 82 : 'r', 83 : 's', 84 : 't', 85 : 'u', 86 : 'v', 87 : 'w', 88 : 'x', 89 : 'y', 
		90 : 'z', 
		//0-9
		48 : '0', 49 : '1', 50 : '2', 51 : '3', 52 : '4', 53 : '5', 54 : '6', 55 : '7', 56 : '8', 57 : '9', 
		//上下左右
		38 : '上',40 : '下',37 : '左',39 : '右',
		//Numpad 0-9
		96 : '小键盘0', 97 : '小键盘1', 98 : '小键盘2', 99 : '小键盘3', 100 : '小键盘4', 101 : '小键盘5', 102 : '小键盘6', 103 : '小键盘7', 104 : '小键盘8', 105 : '小键盘9',
		
		//其他键盘
		32: '空格', 36: 'home', 17:'ctrl',  15:'command', 46:'delete', 35:'end', 34:'page_down', 33:'page_up', 
		107:'小键盘+', 110:'小键盘.', 111:'小键盘/', 106:'小键盘*', 109:'小键盘-', 189:'-', 191:'/', 222:'\'', 
		187:'=', 220:'\\', 16:'shift', 192:'`'
	};
	
	/**
	 * 返回指定键值是否是有效的键值
	 */
	public static function isValidKey(keyCode:int):Boolean
	{
		return VALID_KEY_CODES[keyCode];
	}
	
	/**
	 * 返回键值对应的字符串
	 */
	public static function getKeyName(keyCode:int):String
	{
		return KEY_CODE_NAMES[keyCode] ? KEY_CODE_NAMES[keyCode] : '';
	}
	
	/**
	 * 返回字符串对应的键值
	 */
	public static function getKeyCode(keyName:String):int
	{
		var code:String;
		for (code in KEY_CODE_NAMES) 
		{
			if (KEY_CODE_NAMES[code] == keyName) 
				break;
		}
		return int(code);
	}
}
}