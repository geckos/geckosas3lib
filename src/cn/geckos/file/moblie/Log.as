package cn.geckos.file.moblie 
{
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.utils.ByteArray;
/**
 * ...向sd卡内读写日志
 * @author Kanon
 */
public class Log
{
    //文件
    private static var file:File;
    
    //sd卡路径
    public static var sdCardPath:String = "/mnt/sdcard/";
    
    /**
     * 初始化文件系统
     */
    private static function initFile():void
    {
        if (!Log.file) Log.file = File.userDirectory;
    }
    
    /**
     * 读取sd卡内的文本文件
     * @param	path    文件目录
     * @return  内容
     */
    public static function read(path:String):String
    {
        Log.initFile();
        var content:String;
        file = file.resolvePath(sdCardPath + path);
        if (file.exists) 
        {
            //文件流打开文件并读取字节流
            var stream:FileStream = new FileStream();
            stream.open(file, FileMode.READ);
            //读取保存的文件信息
            content = stream.readUTFBytes(stream.bytesAvailable);
            stream.close();
        }
        return content;
    }
    
    /**
     * 写入sd卡内的文本文件
     * @param	str     写入内容
     * @param	path    文件目录
     */
    public static function write(str:String, path:String):void
    {
        Log.initFile();
        file = file.resolvePath(sdCardPath + path);
        //写入字节数组
        var filebyte:ByteArray = new ByteArray();
        filebyte.writeUTFBytes(str);
        //文件流打开文件并写入字节流
        var stream:FileStream = new FileStream();
        stream.open(file, FileMode.WRITE);
        stream.writeBytes(filebyte, 0, filebyte.length);
        stream.close();
    }
}
}