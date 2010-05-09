package cn.geckos.net 
{
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.HTTPStatusEvent;
    import flash.events.IOErrorEvent;
    import flash.events.ProgressEvent;
    import flash.net.URLRequest;
    import flash.net.URLRequestMethod;
    import flash.net.URLVariables;
	
	/**
     * GLoader provide an easy way to manage server requests, and provide 
     * more powerful functions like pool support, queue and stack.
     * 
     * ==POOL==
     * One instance of GLoader using one pool, the global using the separate pool from all instances.
     * On the other words, there at least one pool exists which is the global pool.
     * The machanism of managing pool is to lazy initial every single loader when needed.
     * 
     * ==Example==
     * Below are example code fragment of GLoader:
     * 
     * public function test():void
     * var loader:GLoader = new GLoader();
     * loader.rGet("http://127.0.0.1:8080/echo.php", {data:"hello"}, {complete:handler}, "1");
     * loader.rPost("http://127.0.0.1:8080/echo.php", {data:"hello"}, {complete:handler, status:onStatus, ioError:onIOErrorHandler, progress:onProgress}, "1");
     * loader.append("http://127.0.0.1:8080/echo.php", {data:"hello"}, {complete:handler}, "POST", "1");
     * loader.preppend("http://127.0.0.1:8080/echo.php", {data:"hello"}, {complete:handler}, "POST", "1");
     * }
     * 
     * public function handler(arg:Object):void {
     *      trace("Callback ID", arg.id);
     *      trace("Result", arg.data);
     * }
     * 
     * public function onStatus(arg:Object):void {
     *      trace("Callback ID", arg.id);
     *      trace("Status", arg.status);
     * }
     * 
     * public function onIOErrorHandler(arg:Object):void {
     *      trace("Callback ID", arg.id);
     *      trace("IOError", arg.ioerror)
     * }
     * 
     * public function onProgress(arg:Object):void {
     *      trace("Callback ID", arg.id);
     *      trace("Bytes Loaded", arg.loaded, "Bytes Total", arg.total);
     * }
     * 
     * Below are php code for echo.
     * 
     * <?php
     * $data = $_REQUEST['data'];
     * sleep(2);
     * echo $data;
     * 
     * @author jeff
     */
    public class GLoader extends EventDispatcher
    {
        public static const QUEUE:String = "QUEUE";     // FIFO
        public static const STACK:String = "STACK";     // LIFO
        
        public static var DEBUG:Boolean;
        
        //______GLOBAL SCOPE_____
        
        // If GLOBAL_POOL_SIZE equals zero means don't reuse the loader from the pool, 
        // creating loader every time when needed. Otherwize obtain loader from pool while there has idle loader avaiable.
        private static var gPoolSize:int = 0; 
        private static var gPool:Array = new Array();
        
        private static var gReqArray:Array = new Array();
        private static var gWaitingRoom:Array = new Array();
        
        private static var gSeqLoader:BindableLoader;
        
        public static var order:String = STACK;
        
        //______INSTANCE SCOPE_____
        
        // If poolSize equals zero means don't reuse the loader from the pool, 
        // creating loader every time when needed. Otherwize obtain loader from pool while there has idle loader avaiable.
        private var poolSize:int = 0;
        private var pool:Array = new Array();
        
        private var reqArray:Array = new Array();
        private var waitingRoom:Array = new Array();
        
        private var sequenceLoader:BindableLoader;
        
        private var order:String;
        
        /**
         * Constructor of GLoader
         * @param	poolSize default is 0(unlimit number of loader, no wait time).
         * @param	order default is stack order.
         */
        public function GLoader(poolSize:int=0, order:String="STACK") 
        {
            this.poolSize = poolSize;
            this.order = order;
        }
        
        /**
         * According to the order to choose next request(FIFO or LIFO).
         * @return Boolean false to tell no more request in the array.
         */
        static private function forNext(arr:Array, order:String):Object {
            // No more request
            if (arr.length <= 0) {
                return null;
            }
            var o:Object;
            // FIFO
            if (GLoader.QUEUE == order) {
                o = arr.shift();
            }else { // LIFO
                o = arr.pop();
            }
            return o;
        }
        
        /**
         * Load next request.
         * TODO remove event from the temp loader when poolSize equals 0.
         * @param loader
         */
        protected function doNext(loader:BindableLoader):void {
            if (waitingRoom.length > 0 || sequenceLoader == loader) {
                var o:Object;
                if (sequenceLoader == loader) {
                    o = GLoader.forNext(reqArray, order);
                    if (o != null) {
                        loader.bind = o;
                        GLoader.request(loader, o.url, o.param, o.method);
                        return;
                    }else {
                        sequenceLoader = null; // The sequence request array is empty.
                    }
                }
                
                if (waitingRoom.length > 0) {
                    var req:Object = waitingRoom.shift();
                    if (req is Array) {
                        sequenceLoader = loader;
                        o = forNext(reqArray, order);  // this order is ***IMPORTANT***
                        sequenceLoader.bind = o;
                        GLoader.request(loader, o.url, o.param, o.method);
                    }else {
                        loader.bind = req;
                        GLoader.request(loader, req.url, req.param, req.method);
                    }
                    return;
                }
            }
            // No requests avaiable.
            loader.bind = null;
            loader.isWorking = false;
            if (loader.floater) {
                destroyLoader(loader);
            }
        }
        static protected function doNext(loader:BindableLoader):void {
            if (gWaitingRoom.length > 0 || gSeqLoader == loader) {
                var o:Object;
                if (gSeqLoader == loader) {
                    o = GLoader.forNext(gReqArray, order);
                    if (o != null) {
                        loader.bind = o;
                        GLoader.request(loader, o.url, o.param, o.method);
                        return;
                    }else {
                        gSeqLoader = null; // The sequence request array is empty.
                    }
                }
                
                if (gWaitingRoom.length > 0) {
                    var req:Object = gWaitingRoom.shift();
                    if (req is Array) {
                        gSeqLoader = loader;
                        o = forNext(gReqArray, order);  // this order is ***IMPORTANT***
                        gSeqLoader.bind = o;
                        GLoader.request(loader, o.url, o.param, o.method);
                    }else {
                        loader.bind = req;
                        GLoader.request(loader, req.url, req.param, req.method);
                    }
                    return;
                }
            }
            // No requests avaiable.
            loader.bind = null;
            loader.isWorking = false;
            if (loader.floater) {
                destroyLoader(loader);
            }
        }
        
        //#####====---->____DEBUG MODE
        
        static protected function beginDebug(loader:BindableLoader):void {
            var d:Date = new Date();
            var report:Object = {startTime:d};
            loader.bind.report = report;
            trace(">>>>>>>> [START] at:", d);
            if (loader.bind.callbackId != null) {
            trace("[Id]......:", loader.bind.callbackId);
            }
            trace("[Loader]..:", loader.id);
            trace("[Url].....:", loader.bind.url);
            trace("[Method]..:", loader.bind.method);
            var param:Object = loader.bind.param;
            trace("[===Parameter===]");
            for (var key:String in param) {
            trace("KEY:", "[" + key + "]", ", VAL:", "[" + param[key] + "]");
            }
            trace("==================");
        }
        
        static protected function endDebug(loader:BindableLoader):void {
            var report:Object = loader.bind.report;
            var beginTime:Date = report.startTime;
            var endTime:Date = new Date();
            trace("<<<<<<<< [STOP] at:", endTime);
            if (loader.bind.callbackId != null) {
            trace("[Id]......:", loader.bind.callbackId);
            }
            trace("[Loader]..:", loader.id);
            trace("[Pool]....:", !loader.floater);
            trace("[Url].....:", loader.bind.url);
            trace("[Last]....:", (endTime.time - beginTime.time), "ms.");
            trace("[Status]..:", report.status);
            trace("==================");
        }
        
        //######====---->____Pool Loader Event Handler
        
        protected function initPoolLoader():BindableLoader {
            var loader:BindableLoader = new BindableLoader();
            loader.addEventListener(Event.COMPLETE, onPoolComplete);
            loader.addEventListener(ProgressEvent.PROGRESS, onPoolProgress);
            loader.addEventListener(IOErrorEvent.IO_ERROR, onPoolIOError);
            loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onPoolHTTPStatus);
            return loader;
        }
        static protected function initPoolLoader():BindableLoader {
            var loader:BindableLoader = new BindableLoader();
            loader.addEventListener(Event.COMPLETE, onPoolComplete);
            loader.addEventListener(ProgressEvent.PROGRESS, onPoolProgress);
            loader.addEventListener(IOErrorEvent.IO_ERROR, onPoolIOError);
            loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onPoolHTTPStatus);
            return loader;
        }
        
        //_______DESTROY LOADER
        
        protected function destroyLoader(loader:BindableLoader):void {
            loader.removeEventListener(Event.COMPLETE, onPoolComplete);
            loader.removeEventListener(ProgressEvent.PROGRESS, onPoolProgress);
            loader.removeEventListener(IOErrorEvent.IO_ERROR, onPoolIOError);
            loader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, onPoolHTTPStatus);
            loader.bind = null;
            loader.isWorking = false;
            loader.id = null;
        }
        static protected function destroyLoader(loader:BindableLoader):void {
            loader.removeEventListener(Event.COMPLETE, onPoolComplete);
            loader.removeEventListener(ProgressEvent.PROGRESS, onPoolProgress);
            loader.removeEventListener(IOErrorEvent.IO_ERROR, onPoolIOError);
            loader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, onPoolHTTPStatus);
            loader.bind = null;
            loader.isWorking = false;
            loader.id = null;
        }
        
        //_______HTTPStatus
        
        private function onPoolHTTPStatus(e:HTTPStatusEvent):void 
        {
            var loader:BindableLoader = BindableLoader(e.target);
            var param:Object = loader.bind;
            if (param.callback != null && param.callback.status != null) {
                var o:Object = { status:e.status };
                if (param.callbackId != null) {
                    o.id = param.callbackId;
                }
                param.callback.status(o);
            }
        }
        static private function onPoolHTTPStatus(e:HTTPStatusEvent):void 
        {
            var loader:BindableLoader = BindableLoader(e.target);
            var param:Object = loader.bind;
            if (param.callback != null && param.callback.status != null) {
                var o:Object = { status:e.status };
                if (param.callbackId != null) {
                    o.id = param.callbackId;
                }
                param.callback.status(o);
            }
        }
        
        //_______IOError
        
        private function onPoolIOError(e:IOErrorEvent):void 
        {
            var loader:BindableLoader = BindableLoader(e.target);
            var param:Object = loader.bind;
            if (param.callback != null && param.callback.ioError != null) {
                var o:Object = { ioerror:e.toString() };
                if (param.callbackId != null) {
                    o.id = param.callbackId;
                }
                param.callback.ioError(o);
            }
            
            if (DEBUG) {
                loader.bind.report.status = "ERROR" + e.toString();
                GLoader.endDebug(loader);
            }
            
            doNext(loader);
        }
        static private function onPoolIOError(e:IOErrorEvent):void 
        {
            var loader:BindableLoader = BindableLoader(e.target);
            var param:Object = loader.bind;
            if (param.callback != null && param.callback.ioError != null) {
                var o:Object = { ioerror:e.toString() };
                if (param.callbackId != null) {
                    o.id = param.callbackId;
                }
                param.callback.ioError(o);
            }
            
            if (DEBUG) {
                loader.bind.report.status = "ERROR" + e.toString();
                GLoader.endDebug(loader);
            }
            
            doNext(loader);
        }
        
        //_______PROGRESS
        
        private function onPoolProgress(e:ProgressEvent):void 
        {
            var loader:BindableLoader = BindableLoader(e.target);
            var param:Object = loader.bind;
            if (param.callback != null && param.callback.progress != null) {
                var o:Object = { loaded:e.bytesLoaded, total:e.bytesTotal };
                if (param.callbackId != null) {
                    o.id = param.callbackId;
                }
                param.callback.progress(o);
            }
        }
        static private function onPoolProgress(e:ProgressEvent):void 
        {
            var loader:BindableLoader = BindableLoader(e.target);
            var param:Object = loader.bind;
            if (param.callback != null && param.callback.progress != null) {
                var o:Object = { loaded:e.bytesLoaded, total:e.bytesTotal };
                if (param.callbackId != null) {
                    o.id = param.callbackId;
                }
                param.callback.progress(o);
            }
        }
        
        //_______COMPLETE
        
        private function onPoolComplete(e:Event):void 
        {
            var loader:BindableLoader = BindableLoader(e.target);
            var param:Object = loader.bind;
            if (param.callback != null && param.callback.complete != null) {
                var o:Object = {data:loader.data};
                if (param.callbackId != null) {
                    o.id = param.callbackId;
                }
                param.callback.complete(o);
            }
            
            if (DEBUG) {
                loader.bind.report.status = "COMPLETE";
                GLoader.endDebug(loader);
            }
            
            doNext(loader);
        }
        static private function onPoolComplete(e:Event):void 
        {
            var loader:BindableLoader = BindableLoader(e.target);
            var param:Object = loader.bind;
            if (param.callback != null && param.callback.complete != null) {
                var o:Object = {data:loader.data};
                if (param.callbackId != null) {
                    o.id = param.callbackId;
                }
                param.callback.complete(o);
            }
            
            if (DEBUG) {
                loader.bind.report.status = "COMPLETE";
                GLoader.endDebug(loader);
            }
            
            doNext(loader);
        }
        
        //_______Get Loader
        
        protected function getLoader():BindableLoader {
            var loader:BindableLoader;
            if (poolSize == 0) {
                loader = initPoolLoader();
                if (DEBUG) {
                    var d:Date = new Date();
                    loader.id = String(d.time);
                }
                loader.floater = true;
                return loader;
            }
            //TODO for futher optimize when pool size is huge (but don't recommand large pool size).
            for (var i:int = 0; i < pool.length; i++) {
                if (!pool[i].isWorking) {
                    return pool[i];
                }
            }
            // The pool is full and no more free loader avaiable, waiting for idle loader.
            if (pool.length == poolSize) {
                //No idle loader avaiable
                return null;
            }else {
                loader = initPoolLoader();
                pool.push(loader);
                
                if (DEBUG) {
                    loader.id = String(pool.length - 1);
                }
                return loader;
            }
        }
        static protected function getLoader():BindableLoader {
            var loader:BindableLoader;
            if (gPoolSize == 0) {
                loader = initPoolLoader();
                if (DEBUG) {
                    var d:Date = new Date();
                    loader.id = String(d.time);
                }
                loader.floater = true;
                return loader;
            }
            //TODO for futher optimize when pool size is huge (but don't recommand large pool size).
            for (var i:int = 0; i < gPool.length; i++) {
                if (!gPool[i].isWorking) {
                    return gPool[i];
                }
            }
            // The pool is full and no more free loader avaiable, waiting for idle loader.
            if (gPool.length == gPoolSize) {
                //No idle loader avaiable
                return null;
            }else {
                loader = initPoolLoader();
                gPool.push(loader);
                
                if (DEBUG) {
                    loader.id = String(gPool.length - 1);
                }
                return loader;
            }
        }
        
        /**
         * Push request to the waiting room, there are two types of parameter pass to the wait function 
         * Object and Array, Object for individual request and Array for a sequence of requests.
         * @param	obj 
         */
        static protected function wait(room:Array, obj:Object):void {
            room.push(obj);
        }
        
        static private function request(loader:BindableLoader, url:String, param:Object, method:String):void {
            var r:URLRequest = new URLRequest(url);
            var p:URLVariables = new URLVariables();
            for (var key:String in param) {
                p[key] = param[key];
            }
            r.method = method;
            r.data = p;
            loader.isWorking = true;
            loader.load(r);
            
            if (DEBUG) {
                beginDebug(loader);
            }
        }
        
        //_______APPEND
        
        public function append(url:String, 
                               param:Object, 
                               callbackFun:Object, 
                               method:String="POST", 
                               callbackId:*=null):void {
            reqArray.push(GLoader.createObject(url, param, callbackFun, method, callbackId));
            if (sequenceLoader == null) {
                var loader:BindableLoader = getLoader();
                if (loader != null) {
                    sequenceLoader = loader;
                    doNext(loader);
                }else {
                    wait(waitingRoom, reqArray);
                }
            }
        }
        static public function append(url:String, 
                                      param:Object, 
                                      callbackFun:Object, 
                                      method:String="POST", 
                                      callbackId:String=null):void {
            gReqArray.push(createObject(url, param, callbackFun, method, callbackId));
            if (gSeqLoader == null) {
                var loader:BindableLoader = getLoader();
                if (loader != null) {
                    gSeqLoader = loader;
                    doNext(loader);
                }else {
                    wait(gWaitingRoom, gReqArray);
                }
            }
        }
        
        //_______PREPPEND
        
        public function preppend(url:String, 
                                 param:Object, 
                                 callbackFun:Object, 
                                 method:String="POST", 
                                 callbackId:*=null):void {
            reqArray.unshift(GLoader.createObject(url, param, callbackFun, method, callbackId));
            if (sequenceLoader == null) {
                var loader:BindableLoader = getLoader();
                if (loader != null) {
                    sequenceLoader = loader;
                    doNext(loader);
                }else {
                    wait(waitingRoom, reqArray);
                }
            }
        }
        static public function preppend(url:String, 
                                        param:Object, 
                                        callbackFun:Object, 
                                        method:String="POST", 
                                        callbackId:String=null):void {
            gReqArray.unshift(createObject(url, param, callbackFun, method, callbackId));
            if (gSeqLoader == null) {
                var loader:BindableLoader = getLoader();
                if (loader != null) {
                    gSeqLoader = loader;
                    doNext(loader);
                }else {
                    wait(gWaitingRoom, gReqArray);
                }
            }
        }
        
        //_______POST
        
        public function rPost(url:String, param:Object, callbackFun:Object, callbackId:*=null):void {
            var loader:BindableLoader = getLoader();
            var obj:Object = GLoader.createObject(url, param, callbackFun, URLRequestMethod.POST, callbackId);
            if (loader == null) {
                wait(waitingRoom, obj);
                return;
            }
            loader.bind = obj;
            GLoader.request(loader, url, param, URLRequestMethod.POST);
        }
        static public function rPost(url:String, 
                                     param:Object, 
                                     callbackFun:Object, 
                                     callbackId:String=null):void {
            var loader:BindableLoader = getLoader();
            var obj:Object = createObject(url, param, callbackFun, URLRequestMethod.POST, callbackId);
            if (loader == null) {
                wait(gWaitingRoom, obj);
                return;
            }
            loader.bind = obj;
            request(loader, url, param, URLRequestMethod.POST);
        }
        
        //_______GET
        
        public function rGet(url:String, 
                             param:Object, 
                             callbackFun:Object, 
                             callbackId:*=null):void {
            var loader:BindableLoader = getLoader();
            var obj:Object = GLoader.createObject(url, param, callbackFun, URLRequestMethod.GET, callbackId);
            if (loader == null) {
                wait(waitingRoom, obj);
                return;
            }
            loader.bind = obj;
            GLoader.request(loader, url, param, URLRequestMethod.GET);
        }
        static public function rGet(url:String, 
                                    param:Object, 
                                    callbackFun:Object, 
                                    callbackId:String=null):void {
            var loader:BindableLoader = getLoader();
            var obj:Object = createObject(url, param, callbackFun, URLRequestMethod.GET, callbackId);
            if (loader == null) {
                wait(gWaitingRoom, obj);
                return;
            }
            loader.bind = obj;
            GLoader.request(loader, url, param, URLRequestMethod.GET);
        }
        
        //_______STOP
        
        public function stop():void {
            if (sequenceLoader != null) {
                try {
                    sequenceLoader.close();
                }catch (err:Error){}
                sequenceLoader.bind = null;
                sequenceLoader.isWorking = false;
                sequenceLoader = null;
            }
        }
        static public function stop():void {
            if (gSeqLoader != null) {
                try {
                    gSeqLoader.close();
                }catch (err:Error){}
                gSeqLoader.bind = null;
                gSeqLoader.isWorking = false;
                gSeqLoader = null;
            }
        }
        
        //_______STOP ALL
        
        public function stopAll():void {
            for (var i:int = 0; i < pool.length; i++) {
                if (pool[i].isWorking) {
                    try {
                        pool[i].close();
                    }catch (err:Error){}
                    pool[i].bind = null;
                    pool[i].isWorking = false;
                }
            }
            sequenceLoader = null;
        }
        static public function stopAll():void {
            for (var i:int = 0; i < gPool.length; i++) {
                if (gPool[i].isWorking) {
                    try {
                        gPool[i].close();
                    }catch (err:Error){}
                    gPool[i].bind = null;
                    gPool[i].isWorking = false;
                }
            }
            gSeqLoader = null;
        }
        
        /**
         * Get the number of free loader from the pool.
         * @return -1 means unlimited size.
         */
        public function numFree():int {
            if (poolSize == 0) {
                return -1;
            }
            var c:int = 0;
            for (var i:int = 0; i < pool.length; i++) {
                if (!pool[i].isWorking) {
                    c++;
                }
            }
            if (pool.length != poolSize) {
                c += poolSize - pool.length;
            }
            return c;
        }
        static public function numFree():int {
            if (gPoolSize == 0) {
                return -1;
            }
            var c:int = 0;
            for (var i:int = 0; i < gPool.length; i++) {
                if (!gPool[i].isWorking) {
                    c++;
                }
            }
            if (gPool.length != gPoolSize) {
                c += gPoolSize - gPool.length;
            }
            return c;
        }
        
        static private function createObject(url:String, 
                                            param:Object, 
                                            callbackFun:Object, 
                                            method:String, 
                                            callbackId:*=null):Object {
            return {url:url, param:param, callback:callbackFun, method:method, callbackId:callbackId}
        }
        
        
        /**
         * Fetch and change the pool size.
         */ 
        public function get size():int { return poolSize; }
        
        public function set size(value:int):void 
        {
            if (value < 0 || value == poolSize) {
                return;
            }
            if (value < poolSize) {
                var i:int = pool.length - 1;
                while (i >= value) {
                    var loader:BindableLoader = pool.pop();
                    loader.floater = true;
                    i--;
                }
            }
            poolSize = value;
        }
        static public function get size():int { return gPoolSize; }
        
        static public function set size(value:int):void 
        {
            if (value < 0 || value == gPoolSize) {
                return;
            }
            if (value < gPoolSize) {
                var i:int = gPool.length - 1;
                while (i >= value) {
                    var loader:BindableLoader = gPool.pop();
                    loader.floater = true;
                    i--;
                }
            }
            gPoolSize = value;
        }
    }
}

import flash.net.URLLoader;
class BindableLoader extends URLLoader {
    private var _id:String;
    private var _isWorking:Boolean;
    private var _bindParam:*;
    private var _floater:Boolean;
    
    public function get id():String
    {
        return _id;
    }
    
    public function set id(value:String):void
    {
        _id = value;
    }
    
    public function get bind():* {
        return _bindParam;
    }
    
    public function set bind(value:*):void {
        _bindParam = value;
    }
    
    public function get isWorking():Boolean
    {
        return _isWorking;
    }
    
    public function set isWorking(value:Boolean):void
    {
        _isWorking = value;
    }
    
    public function get floater():Boolean
    {
        return _floater;
    }
    
    public function set floater(value:Boolean):void
    {
        _floater = value;
    }
    
}