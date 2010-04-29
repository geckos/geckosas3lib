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
     * @author jeff
     */
    public class GLoader extends EventDispatcher
    {
        public static const QUEUE:String = "QUEUE";     // FIFO
        public static const STACK:String = "STACK";     // LIFO
        
        // If POOL_SIZE equals zero means don't reuse the loader from the pool, 
        // create loader every time when needed. Otherwize obtain loader from pool while there has idel loader avaiable.
        public static var POOL_SIZE:int = 0; 
        private static var threadPool:Array = new Array();  // Share between static scope and class scope.
        
        //The array for static scope.
        private static var globalArray:Array = new Array();
        
        //The array for class scope.
        private var reqArray:Array = new Array();
        private var waitingRoom:Array = new Array();
        
        //singleton thread loader.
        private var singleLoader:URLLoader;
        private var sCallbackFun:Object;
        private var sCallbackId:*;
        
        private var dataStructure:String;
        
        public function GLoader(structure:String="STACK") 
        {
            dataStructure = structure;
        }
        
        //######====---->____Singleton Loader Event Handler
        
        protected function getSingletonLoader():URLLoader {
            if (singleLoader == null) {
                initSingleLoader();
            }else {
                try {
                    singleLoader.close();
                }catch (err:Error){}
            }
            return singleLoader;
        }
        
        protected function initSingleLoader():void {
            if (singleLoader == null) {
                singleLoader = new URLLoader();
                singleLoader.addEventListener(Event.COMPLETE, onSingleComplete);
                singleLoader.addEventListener(ProgressEvent.PROGRESS, onSingleProgress);
                singleLoader.addEventListener(IOErrorEvent.IO_ERROR, onSingleIOError);
                singleLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onSingleHTTPStatus);
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
                var o:Object = {data:singleLoader.data};
                if (sCallbackId != null) {
                    o.id = sCallbackId;
                }
                sCallbackFun.complete(o);
            }
            // Load Next
            forNext();
        }
        
        private function forNext():void {
            // No more request
            if (reqArray.length <= 0) {
                return;
            }
            var o:Object;
            // FIFO
            if (GLoader.QUEUE == dataStructure) {
                o = reqArray.shift();
            }else { // LIFO
                o = reqArray.pop();
            }
            GLoader.request(getSingletonLoader(), o.url, o.param, o.method);
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
                var o:Object = {data:singleLoader.data};
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
        
        protected function wait(obj:Object):void {
            // FIFO
            if (GLoader.QUEUE == dataStructure) {
                waitingRoom.unshift(o);
            }else { // LIFO
                waitingRoom.push(o);
            }
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
            if (singleLoader != null) {
                try {
                    singleLoader.close();
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
    }

}