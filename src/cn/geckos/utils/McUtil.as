package cn.geckos.utils
{
import flash.display.FrameLabel;
import flash.display.MovieClip;
public class McUtil
{
    /**
     * 给指定的帧标签添加回调函数
     * @param label     帧标签
     * @param callBack  跑到指定的帧标签时调用的函数
     * @param targetMC  目标MC
     */
    public static function addFrameLabelScript(label:String, 
											   callBack:Function, 
											   targetMC:MovieClip):void
    {
        var frames:Array = targetMC.currentLabels;
        for each(var frameLabel:FrameLabel in frames)
        {
            if (frameLabel.name == label)
            {
                targetMC.addFrameScript(frameLabel.frame - 1, callBack);
                return;
            }
        }
    }
	
	/**
	 * 去除帧标签上的脚本
	 * @param	label		帧标签
	 * @param	targetMC	目标mc
	 */
	public static function removeFrameLabelScript(label:String, targetMC:MovieClip):void
	{
		McUtil.addFrameLabelScript(label, null, targetMC);
	}
}
}