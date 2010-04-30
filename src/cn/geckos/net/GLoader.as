package cn.geckos.net 
{
    import flash.events.Event;
    import flash.events.ProgressEvent;
    import flash.events.IOErrorEvent;
    import flash.events.HTTPStatusEvent;
	import flash.events.EventDispatcher;
    import flash.net.URLLoader;
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
     * @author jeff
     */
    public class GLoader extends EventDispatcher
    {
        public static const QUEUE:String = "QUEUE";     // FIFO
        public static const STACK:String = "STACK";     // LIFO
        
        //______GLOBAL SCOPE_____
        
        // If GLOBAL_POOL_SIZE equals zero means don't reuse the loader from the pool, 
        // creating loader every time when needed. Otherwize obtain loader from pool while there has idel loader avaiable.
        private static var GLOBAL_POOL_SIZE:int = 0; 
        private static var gPool:Array = new Array();
        
        private static var gArray:Array = new Array();
        private static var gWaitingRoom:Array = new Array();
        
        private static var gWorkingLoader:URLLoader;
        private static var gCallbackFun:Object;
        private static var gCallbackId:*;
        
        //______INSTANCE SCOPE_____
        
        // If POOL_SIZE equals zero means don't reuse the loader from the pool, 
        // creating loader every time when needed. Otherwize obtain loader from pool while there has idel loader avaiable.
        private var POOL_SIZE:int = 0;
        private var pool:Array = new Array();
        
        private var reqArray:Array = new Array();
        private var waitingRoom:Array = new Array();
        
        private var workingLoader:URLLoader;
        private var sCallbackFun:Object;
        private var sCallbackId:*;
        
        private var order:String;
        
        public function GLoader(order:String="STACK") 
        {
            this.order = order;
        }
        
        //######====---->____Sequence Loader Event Handler
        
        protected function getSingletonLoader():URLLoader {
            if (workingLoader == null) {
                var loader:URLLoader = getLoader();
                if (loader == null) {
                    //TODO append to waiting room.
                }else {
                    workingLoader = loader;
                    initWorkingLoader();
                }
            }else {
                try {
                    workingLoader.close();
                }catch (err:Error){}
            }
            return workingLoader;
        }
        
        protected function initWorkingLoader():void {
            if (workingLoader == null) {
                workingLoader = new URLLoader();
                workingLoader.addEventListener(Event.COMPLETE, onSingleComplete);
                workingLoader.addEventListener(ProgressEvent.PROGRESS, onSingleProgress);
                workingLoader.addEventListener(IOErrorEvent.IO_ERROR, onSingleIOError);
                workingLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onSingleHTTPStatus);
            }
        }
        
        private function onSingleHTTPStatus(e:HTTPStatusEvent):void 
        {
            if (sCallbackFun != null && sCallbackFun.status != null) {
                var o:Object = { status:e.status };
                if (sCallbackId != null) {
                    o.id = sCallbackId;
                }
                sCallbackFun.status(o);
            }
        }
        
        private function onSingleIOError(e:IOErrorEvent):void 
        {
            if (sCallbackFun != null && sCallbackFun.ioError != null) {
                var o:Object = { ioerror:e.toString() };
                if (sCallbackId != null) {
                    o.id = sCallbackId;
                }
                sCallbackFun.ioError(o);
            }
            // Load Next
            forNext();
        }
        
        private function onSingleProgress(e:ProgressEvent):void 
        {
            if (sCallbackFun != null && sCallbackFun.progress != null) {
                var o:Object = { loaded:e.bytesLoaded, total:e.bytesTotal };
                if (sCallbackId != null) {
                    o.id = sCallbackId;
                }
                sCallbackFun.progress(o);
            }
        }
        
        private function onSingleComplete(e:Event):void 
        {
            if (sCallbackFun != null && sCallbackFun.complete != null) {
                var o:Object = {data:workingLoader.data};
                if (sCallbackId != null) {
                    o.id = sCallbackId;
                }
                sCallbackFun.complete(o);
            }
            // Load Next
            forNext();
        }
        
        /**
         * According to the order to choose request(FIFO or LIFO).
         * @return Boolean false to tell no more request in the array.
         */
        private function forNext():Boolean {
            // No more request
            if (reqArray.length <= 0) {
                return false;
            }
            var o:Object;
            // FIFO
            if (GLoader.QUEUE == order) {
                o = reqArray.shift();
            }else { // LIFO
                o = reqArray.pop();
            }
            GLoader.request(getSingletonLoader(), o.url, o.param, o.method);
            return true;
        }
        
        //######====---->____Pool Loader Event Handler
        
        protected function initPoolLoader():URLLoader {
            var loader:URLLoader = new URLLoader();
            loader.addEventListener(Event.COMPLETE, onPoolComplete);
            loader.addEventListener(ProgressEvent.PROGRESS, onPoolProgress);
            loader.addEventListener(IOErrorEvent.IO_ERROR, onPoolIOError);
            loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onPoolHTTPStatus);
            return loader;
        }
        
        private function onPoolHTTPStatus(e:HTTPStatusEvent):void 
        {
            if (sCallbackFun != null && sCallbackFun.status != null) {
                var o:Object = { status:e.status };
                if (sCallbackId != null) {
                    o.id = sCallbackId;
                }
                sCallbackFun.status(o);
            }
        }
        
        private function onPoolIOError(e:IOErrorEvent):void 
        {
            if (sCallbackFun != null && sCallbackFun.ioError != null) {
                var o:Object = { ioerror:e.toString() };
                if (sCallbackId != null) {
                    o.id = sCallbackId;
                }
                sCallbackFun.ioError(o);
            }
        }
        
        private function onPoolProgress(e:ProgressEvent):void 
        {
            if (sCallbackFun != null && sCallbackFun.progress != null) {
                var o:Object = { loaded:e.bytesLoaded, total:e.bytesTotal };
                if (sCallbackId != null) {
                    o.id = sCallbackId;
                }
                sCallbackFun.progress(o);
            }
        }
        
        private function onPoolComplete(e:Event):void 
        {
            if (sCallbackFun != null && sCallbackFun.complete != null) {
                var o:Object = {data:workingLoader.data};
                if (sCallbackId != null) {
                    o.id = sCallbackId;
                }
                sCallbackFun.complete(o);
            }
        }
        
        //######====---->____Class Function
        
        protected function getLoader():URLLoader {
            if (GLoader.POOL_SIZE == 0) {
                return initPoolLoader();
            }
            //TODO for futher optimize when pool size is huge (but don't recommand large pool size).
            for (var i:int = 0; i < GLoader.threadPool.length; i++) {
                if (!GLoader.threadPool[i].isWorking) {
                    return GLoader.threadPool[i].loader;
                }
            }
            // The pool is full and no more free loader avaiable, waiting for idel loader.
            if (GLoader.threadPool.length == GLoader.POOL_SIZE) {
                //No idel loader avaiable
                return null;
            }else {
                var loader:URLLoader = initPoolLoader();
                GLoader.threadPool.push({isWorking:true, loader:loader});
                return loader;
            }
        }
        
        /**
         * Push request to the waiting room, there are two types of parameter pass to the wait function 
         * Object and Array, Object for individual request and Array for a sequence of requests.
         * @param	obj 
         */
        protected function wait(obj:Object):void {
            waitingRoom.push(o);
        }
        
        private static function request(loader:URLLoader, url:String, param:Object, method:String):void {
            var r:URLRequest = new URLRequest(url);
            var p:URLVariables = new URLVariables();
            for (var key in param) {
                p[key] = param[key];
            }
            r.method = method;
            r.data = p;
            loader.load(r);
        }
        
        public function append(url:String, param:Object, callbackFun:Object, method:String="POST", callbackId:*=null):void {
            reqArray.push({url:url, param:param, callback:callbackFun, method:method, callbackId:callbackId});
        }
        
        public function preppend(url:String, param:Object, callbackFun:Object, method:String="POST", callbackId:*=null):void {
            reqArray.unshift({url:url, param:param, callback:callbackFun, method:method, callbackId:callbackId});
        }
        
        public function rPost(url:String, param:Object, callbackFun:Object, callbackId:*=null):void {
            sCallbackFun = callbackFun;
            sCallbackId = callbackId;
            var loader:URLLoader = getLoader();
            if (loader == null) {
                waitingRoom.push();
            }
            GLoader.request(loader, url, param, URLRequestMethod.POST);
        }
        
        public function rGet(url:String, param:Object, callbackFun:Object, callbackId:*=null):void {
            sCallbackFun = callbackFun;
            sCallbackId = callbackId;
            GLoader.request(getLoader(), url, param, URLRequestMethod.GET);
        }
        
        public function stop():void {
            if (workingLoader != null) {
                try {
                    workingLoader.close();
                }catch (err:Error){}
            }
        }
        
        public function stopAll():void {
            trace("stop all in obj");
        }
        
        //######====---->>>>____Static Function
        
        public static function append(url:String, param:Object, callbackFun:Object, method:String="POST", callbackId:String=null):void {
            
        }
        
        public static function preppend(url:String, param:Object, callbackFun:Object, method:String="POST", callbackId:String=null):void {
            
        }
        
        public static function rPost(url:String, param:Object, callbackFun:Object, callbackId:String=null):void {
            
        }
        
        public static function rGet(url:String, param:Object, callbackFun:Object, callbackId:String=null):void {
            
        }
        
        public static function stop():void {
            
        }
        
        public static function stopAll():void {
            trace("stop all in class");
        }
        
        /**
         * Get the number of free loader from the pool.
         * @return -1 means unlimited size.
         */
        public static function numFree():int {
            if (GLoader.POOL_SIZE == 0) {
                return -1;
            }
            var c:int = 0;
            for (var i:int = 0; i < GLoader.threadPool.length; i++) {
                if (!GLoader.threadPool[i].isWorking) {
                    c++;
                }
            }
            if (GLoader.threadPool.length != GLoader.POOL_SIZE) {
                c += GLoader.POOL_SIZE - GLoader.threadPool.length;
            }
            return c;
        }
        
        static public function get SIZE():int { return POOL_SIZE; }
        
        static public function set SIZE(value:int):void 
        {
            if (value < 0) {
                return;
            }
            POOL_SIZE = value;
        }
    }

}