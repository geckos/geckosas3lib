package cn.geckos.utils 
{
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
/**
 * ...显示对象工具
 * @author Kanon
 */
public class DisplayObjectUtil 
{
	/**
	 * 删除容器内所有的显示对象
	 * @param	o  容器
	 */
	public static function removeAllChild(o:DisplayObjectContainer):void
	{
		if (!o) return;
		var numChildren:int = o.numChildren;
		for (var i:int = numChildren - 1; i >= 0; i -= 1)
		{
			o.removeChild(o.getChildAt(i));
		}
	}
	
	/**
	 * 删除某个显示对象
	 * @param	o 某个显示对象
	 */
	public static function removeChild(o:DisplayObject):void
	{
		if (o && o.parent)
			o.parent.removeChild(o);
	}
}
}