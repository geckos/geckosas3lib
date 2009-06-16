package cn.geckos.net {
    
import flash.events.Event;
import flash.events.HTTPStatusEvent;
import flash.events.IOErrorEvent;
import flash.events.SecurityErrorEvent;
import flash.net.URLLoader;
import flash.net.URLRequest;

/**
 * @author harry
 */
public class StackURLLoader extends URLLoader {
    
    private var requestsStack:Array = [];
    private var datumsStack:Array = [];
    
    private var _currentRequest:URLRequest;
    private var _currentData:Object;
    private var _isBusy:Boolean;
    
    private var listenerInited:Boolean = false;
    private var opened:Boolean = false;
    
    public function get currentRequest():URLRequest {
        return _currentRequest;
    }
    
    public function get currentData():Object {
        return _currentData;
    }
    
    public function get isBusy():Boolean {
        return _isBusy;
    }
    
    public function StackURLLoader() {
    }
    
    override public function load(request:URLRequest):void {
        loadWithData(request);
    }
    
    public function loadWithData(request:URLRequest, data:Object=null):void {
        initListeners();
        
        requestsStack.push(request);
        datumsStack.push(data);
        
        if(!isBusy) {
            loadNext();
        }
    }
    
    private function assignCurrent():void {
        _currentRequest = requestsStack.shift();
        _currentData = datumsStack.shift();
    }
    
    private function loadNext():void {
        opened = false;
        if(requestsStack.length > 0) {
            super.load(requestsStack[0]);
            _isBusy = true;
        }
        else {
            _isBusy = false;
        }
    }
    
    private function initListeners():void {
        if(!listenerInited) {
            addEventListener(Event.COMPLETE, __loadEnd);
            addEventListener(IOErrorEvent.IO_ERROR, __loadEnd);
            addEventListener(SecurityErrorEvent.SECURITY_ERROR, __loadEnd);
            addEventListener(Event.OPEN, __open);
            addEventListener(HTTPStatusEvent.HTTP_STATUS, __httpStatus);
            listenerInited = true;
        }
    }
    
    private function __loadEnd(event:Event):void {
        loadNext();
    }
    
    private function __open(event:Event):void {
        opened = true;
        assignCurrent();
    }
    
    private function __httpStatus(event:Event):void {
        if(!opened) {
            assignCurrent();
        }
    }
}
}

