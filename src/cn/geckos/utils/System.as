package cn.geckos.utils 
{
import flash.display.DisplayObject;
import flash.system.Capabilities;
/**
 * ...描述了承载 SWF 文件的系统和播放器
 * @author ...Kanon
 */
public class System 
{
	
	/**
	 * 是否是浏览器插件的swf
	 * @return	
	 */
	public static function isPlugs():Boolean
	{
		if (Capabilities.playerType == "PlugIn" || 
			Capabilities.playerType == "ActiveX")
			return true;
		return false;
	}
	
	/**
	 * 是否是独立运行的swf
	 * @return
	 */
	public static function isStandAlone():Boolean
	{
		if (Capabilities.playerType == "StandAlone")
			return true;
		return false;
	}
	
	/**
	 * 是否是air桌面应用
	 * @return
	 */
	public static function isAirApplication():Boolean
	{
		if (Capabilities.playerType == "Desktop")
			return true;
		return false;
	}
	
	/**
	 * 是否是IDE内的承载swf
	 * @return
	 */
	public static function isIDE():Boolean
	{
		if (Capabilities.playerType == "External")
			return true;
		return false;
	}
	
	/**
	 * 是否是mac系统
	 * @return
	 */
	public static function isMac():Boolean
	{
		if (Capabilities.os.toLocaleLowerCase().indexOf("mac os") != -1)
			return true;
		return false;
	}
	
	/**
	 * 是否是除了mac系统外的其余系统
	 * @return
	 */
	public static function isPC():Boolean
	{
		if (!System.isMac())
			return true;
		return false;
	}
	
	/**
	 * 是否是web环境运行
	 * @param	location	获取的显示对象
	 * @return	
	 */
	public static function isWeb(location:DisplayObject):Boolean
	{
		return location.loaderInfo.url.substr(0, 4) == "http";
	}
	
}
}