package cn.geckos.utils
{
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;

public class DepthManager
{
    
    /**
     * 将显示对象的深度设置到其所在容器中的最高深度
     * @param display
     * 
     */
    public static function bringToFront(display:DisplayObject):void
    {
        var parent:DisplayObjectContainer = display.parent;
        parent.setChildIndex(display, parent.numChildren-1);
    }
    
    /**
     * 将显示对象的深度设置到其所在容器中的最低深度(0)
     * @param display
     * 
     */
    public static function bringToBack(display:DisplayObject):void
    {
        display.parent.setChildIndex(display, 0);
    }
    
    /**
     * 将显示对象向上移动一个深度
     * @param display
     * 
     */
    public static function bringForward(display:DisplayObject):void
    {
        var parent:DisplayObjectContainer = display.parent;
        var index:int = parent.getChildIndex(display);
        
        if (index != (parent.numChildren-1))
        {
            parent.setChildIndex(display, index + 1);
        }
    }
    
    /**
     * 将显示对象向下移动一个深度
     * @param display
     * 
     */
    public static function bringBackward(display:DisplayObject):void
    {
        var parent:DisplayObjectContainer = display.parent;
        var index:int = parent.getChildIndex(display);
        
        if (index != 0)
        {
            parent.setChildIndex(display, index - 1);
        }
    }
}
}