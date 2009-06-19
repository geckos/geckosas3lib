package cn.geckos.utils
{
    import flash.display.FrameLabel;
    import flash.display.MovieClip;
    

public class McUitl
{
    /**
     * 给指定的帧标签添加回调函数
     * @param label     帧标签
     * @param callBack  跑到指定的帧标签时调用的函数
     * @param targetMC  目标MC
     * 
     */
    public static function addFrameLabelScript(
                                        label:String, 
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
}
}