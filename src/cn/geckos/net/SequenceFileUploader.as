package cn.geckos.net
{
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IOErrorEvent;
import flash.net.FileReference;
import flash.net.URLRequest;
/**
 * 队列上传
 * @author harry
 * 
 */
public class SequenceFileUploader extends EventDispatcher
{
    private var _files:Array = [];
    private var _requests:Array = [];
    private var _fields:Array = [];
    
    public function get length():int
    {
        return _files.length;
    }
    
    
    private var _uploadingFile:FileReference;
    public function get uploadingFile():FileReference
    {
        return _uploadingFile;
    }
    
    private var _running:Boolean;
    public function get running():Boolean
    {
        return _running;
    }
    
    /**
     * Constructor
     * 
     */
    public function SequenceFileUploader()
    {
    }
    
    /**
     * 开始上传
     * 
     */
    public function start():void
    {
        if( !running ) {
            _running = true; 
            run();
        }
    }
    
    /**
     * 停止上传
     * 
     */
    public function stop():void
    {
        uploadingFile.cancel();
        _running = false;
    }
    
    
    protected function run():void
    {
        if( !running ) {
            return;
        }
        
        if( _files.length < 1 ) {
            _running = false;
            _uploadingFile = null;
            dispatchEvent(new Event(Event.COMPLETE));
            return;
        }
        else {
            _uploadingFile = _files[0];
            addFileListeners(_uploadingFile);
            
            _uploadingFile.upload(URLRequest(_requests[0]), _fields[0]);
            
            dispatchEvent(new Event(Event.CHANGE));
        }
    }
    
    private function fileUploadCompleteHandler(event:Event):void
    {
        var file:FileReference = FileReference( _files.shift() );
        removeFileListeners(file);
        
        _requests.shift();
        _fields.shift();
        
        run();
    }
    
    /**
     * 文件上传出现错误后将直接发出错误时间并且停止上传
     */
    private function fileUploadErrorHandler(event:Event):void
    {
        dispatchEvent(event);
        _running = false;
    }
    
    public function addFile(file:FileReference, request:URLRequest, fieldName:String):void
    {
        _files.push(file);
        _requests.push(request);
        _fields.push(fieldName);
    }
    
    /**
     * 移除要进行上传的文件，如果该文件正在上传中，文件的 cancel() 将会被调用
     * @param file
     * @param request
     * 
     */
    public function removeFile(file:FileReference, request:URLRequest=null):void
    {
        var index:int;
        
        while( (index = _files.indexOf(file)) > -1 )
        {
            if( request && _requests[index] != request ) {
                continue;
            }
            
            var theFile:FileReference = FileReference( _files[index] );
            removeFileListeners(theFile);
            
            _files.splice(index, 1);
            _requests.splice(index, 1);
            _fields.splice(index, 1);
            
            if( theFile == _uploadingFile ) {
                theFile.cancel();
                run();
            }
        }
    }
    
    private function addFileListeners(file:FileReference):void
    {
        file.addEventListener(Event.COMPLETE, fileUploadCompleteHandler);
        file.addEventListener(IOErrorEvent.IO_ERROR, fileUploadErrorHandler);
    }
    
    private function removeFileListeners(file:FileReference):void
    {
        file.removeEventListener(Event.COMPLETE, fileUploadCompleteHandler);
        file.removeEventListener(IOErrorEvent.IO_ERROR, fileUploadErrorHandler);
    }
        
}
}