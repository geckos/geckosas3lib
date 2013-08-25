package cn.geckos.utils 
{
import flash.display.InteractiveObject;
import flash.events.KeyboardEvent;
import flash.utils.Dictionary;
/**
 * ...键盘管理
 * @author Kanon
 */
public class KeyboardManager 
{
	/**
	 * 键盘事件类型
	 */
	public static const TYPE_KEY_DOWN:int = 0;
	public static const TYPE_KEY_UP:int = 1;
	/**
	 * 按键监听者
	 */
	private static var _listener:InteractiveObject;
	//存放按下注册数据的字典
	private static var keyDownDict:Dictionary;
	//存放按起注册数据的字典
	private static var keyUpDict:Dictionary;
	/**
	 * 键值字符串枚举
	 */
	public static const A 			: String = "A";
	public static const B 			: String = "B";
	public static const C 			: String = "C";
	public static const D 			: String = "D";
	public static const E 			: String = "E";
	public static const F 			: String = "F";
	public static const G 			: String = "G";
	public static const H 			: String = "H";
	public static const I 			: String = "I";
	public static const J 			: String = "J";
	public static const K 			: String = "K";
	public static const L 			: String = "L";
	public static const M 			: String = "M";
	public static const N 			: String = "N";
	public static const O 			: String = "O";
	public static const P 			: String = "P";
	public static const Q 			: String = "Q";
	public static const R 			: String = "R";
	public static const S 			: String = "S";
	public static const T 			: String = "T";
	public static const U 			: String = "U";
	public static const V 			: String = "V";
	public static const W 			: String = "W";
	public static const X 			: String = "X";
	public static const Y 			: String = "Y";
	public static const Z 			: String = "Z";
	
	public static const a 			: String = "a";
	public static const b 			: String = "b";
	public static const c 			: String = "c";
	public static const d 			: String = "d";
	public static const e 			: String = "e";
	public static const f 			: String = "f";
	public static const g 			: String = "g";
	public static const h 			: String = "h";
	public static const i 			: String = "i";
	public static const j 			: String = "j";
	public static const k 			: String = "k";
	public static const l 			: String = "l";
	public static const m 			: String = "m";
	public static const n 			: String = "n";
	public static const o 			: String = "o";
	public static const p 			: String = "p";
	public static const q 			: String = "q";
	public static const r 			: String = "r";
	public static const s 			: String = "s";
	public static const t 			: String = "t";
	public static const u 			: String = "u";
	public static const v 			: String = "v";
	public static const w 			: String = "w";
	public static const x 			: String = "x";
	public static const y 			: String = "y";
	public static const z 			: String = "z";
	
	public static const ESC 		: String = "Esc";
	public static const F1			: String = "F1";
	public static const F2			: String = "F2";
	public static const F3			: String = "F3";
	public static const F4			: String = "F4";
	public static const F5			: String = "F5";
	public static const F6			: String = "F6";
	public static const F7			: String = "F7";
	public static const F8			: String = "F8";
	public static const F9			: String = "F9";
	public static const F10			: String = "F10";
	public static const F11			: String = "F11";
	public static const F12			: String = "F12";
	
	public static const NUM_1 		: String = "1";
	public static const NUM_2 		: String = "2";
	public static const NUM_3 		: String = "3";
	public static const NUM_4 		: String = "4";
	public static const NUM_5 		: String = "5";
	public static const NUM_6 		: String = "6";
	public static const NUM_7 		: String = "7";
	public static const NUM_8 		: String = "8";
	public static const NUM_9 		: String = "9";
	public static const NUM_0 		: String = "0";
	
	public static const TAB 		: String = "Tab";
	public static const CTRL 		: String = "Ctrl";
	public static const ALT 		: String = "Alt";
	public static const SHIFT 		: String = "Shift";
	public static const CAPS_LOCK 	: String = "Caps Lock";
	public static const ENTER	 	: String = "Enter";
	public static const SPACE	 	: String = "Space";
	public static const BACK_SPACE 	: String = "Back Space";
	
	public static const INSERT		: String = "Insert";
	public static const DELETE		: String = "Page Down";
	public static const HOME		: String = "Home";
	public static const END			: String = "Page Down";
	public static const PAGE_UP		: String = "Page Up";
	public static const PAGE_DOWN	: String = "Page Down";
	
	public static const LEFT		: String = "Left";
	public static const RIGHT		: String = "Right";
	public static const UP			: String = "Up";
	public static const DOWN		: String = "Down";
	
	public static const PAUSE_BREAK	: String = "Pause Break";
	public static const NUM_LOCK	: String = "Num Lock";
	public static const SCROLL_LOCK	: String = "Scroll Lock";
	
	public static const WINDOWS		: String = "Windows";
	
	/**
	 * 设置监听键盘的对象
	 */
	public static function set listener(value:InteractiveObject):void 
	{
		if (!value) return;
		_listener = value;
		_listener.addEventListener(KeyboardEvent.KEY_DOWN, onKeyHandler);
		_listener.addEventListener(KeyboardEvent.KEY_UP, onKeyHandler);
		keyDownDict = new Dictionary();
		keyUpDict = new Dictionary();
	}
	
	/**
	 * 注册按键
	 * @param	key		键值
	 * @param	fun		回调方法
	 * @param	type	按键类型 TYPE_KEY_DOWN、TYPE_KEY_UP
	 */
	public static function registerKey(key:String, fun:Function, type:int = 0, ...args):void
	{
		var keyDict:Dictionary = type ? keyUpDict : keyDownDict;
		keyDict[key] = { "fun":fun, args:args };
	}
	
	/**
	 * 注销按键
	 * @param	key		键值
	 * @param	type	注销的类型
	 */
	public static function unregisterKey(key:String, type:int = 0):void
	{
		var keyDict:Dictionary = type ? keyUpDict : keyDownDict;
		delete keyDict[key];
	}
	
	/**
	 *  执行键盘操作
	 * @param	event
	 */
	private static function onKeyHandler(event:KeyboardEvent):void 
	{
		var key:String = keyCodeToString(event.keyCode, event.charCode);
		var keyDict:Dictionary = event.type == KeyboardEvent.KEY_UP ? keyUpDict : keyDownDict;
		var o:Object = keyDict[key];
		if (o) 
		{
			var fun:Function = o.fun;
			var args:Array = o.args;
			fun.apply(null, args);
		}
	}
	
	/**
	 * 根据keyCode或charCode获取相应的字符串代号
	 * @param	keyCode
	 * @param	charCode
	 * @return	键盘所指字符串代号
	 */
	private static function keyCodeToString(keyCode:int, charCode:int):String
	{
		switch(keyCode)
		{
			case 8 :
				return BACK_SPACE;
			case 9 :
				return TAB;
			case 13 :
				return ENTER;
			case 16 :
				return SHIFT;
			case 17 :
				return CTRL;
			case 19 :
				return PAUSE_BREAK;
			case 20 :
				return CAPS_LOCK;
			case 27 :
				return ESC;
			case 32 :
				return SPACE;
			case 33 :
				return PAGE_UP;
			case 34 :
				return PAGE_DOWN;
			case 35 :
				return END;
			case 36 :
				return HOME;
			case 37 :
				return LEFT;
			case 38 :
				return UP;
			case 39 :
				return RIGHT;
			case 40 :
				return DOWN;
			case 45 :
				return INSERT;
			case 46 :
				return DELETE;
			case 91 :
				return WINDOWS;
			case 112 :
				return F1;
			case 113 :
				return F2;
			case 114 :
				return F3;
			case 115 :
				return F4;
			case 116 :
				return F5;
			case 117 :
				return F6;
			case 118 :
				return F7;
			case 119 :
				return F8;
			case 120 :
				return F9;
			case 122 :
				return F11;
			case 123 :
				return F12;
			case 144 :
				return NUM_LOCK;
			case 145 :
				return SCROLL_LOCK;
			default :
				return String.fromCharCode(charCode);
		}
	}
	
	/**
	 * 销毁方法
	 */
	public static function destroy():void
	{
		keyDownDict = null;
		keyUpDict = null;
		if (_listener)
		{
			_listener.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyHandler);
			_listener.removeEventListener(KeyboardEvent.KEY_UP, onKeyHandler);
		}
	}
}
}