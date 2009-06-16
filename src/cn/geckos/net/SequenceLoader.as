package cn.geckos.net 
{
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.errors.IOError;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	/**
	* ...
	* @author Jeff.xu (http://blog.jeffxu.cn)
	*/
	public class SequenceLoader extends EventDispatcher
	{	
		private var errorMax:Number = 1;
		private var _errorCounter:Number;
		private var counter:Number;
		
		private var stack:Array;
		private var _isLoading:Boolean;
		private var _loader:Loader;
		
		public function SequenceLoader() 
		{
			this._isLoading = false;
			this._errorCounter = 0;
		}
		
		public function start(urls:Array):void 
		{
			if (this.stack == null) 
			{
				this.stack = urls;
			}
			if (this._loader != null) 
			{
				try 
				{
					this._loader.close();
				}catch (error:Error){}
			}
			this.counter = 0;
			this.run();
		}
		
		protected function run():void 
		{
			if (this.counter >= this.stack.length) 
			{
				var e:Event = new Event(Event.COMPLETE);
				this.dispatchEvent(e);
				this.destroy();
				return;
			}else 
			{
				this.removeEvents();
			}
			this._loader = new Loader();
			this._loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
			this._loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			this._loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgress);
			var t:Object = this.stack[this.counter];
			var context:LoaderContext = new LoaderContext();
			context.applicationDomain = new ApplicationDomain();
			if (t is URLRequest) 
			{
				this._loader.load(URLRequest(t), context);
			}else 
			{
				this._loader.load(new URLRequest(String(t)), context);
			}
			this._isLoading = true;
		}
		
		private function onProgress(e:ProgressEvent):void 
		{
			this.dispatchEvent(e);
		}
		
		private function errorHandler(e:IOErrorEvent):void 
		{
			this._errorCounter++;
			//trace("Error counter", this._errorCounter, this.errorMax);
			if (this.errorMax > 0 && this._errorCounter > this.errorMax) 
			{
				this.dispatchEvent(e);
				this._errorCounter = 0;
				this.counter++;
			}
			this.run();
		}
		
		private function onComplete(e:Event):void 
		{
			var te:SequenceLoaderEvent = new SequenceLoaderEvent(SequenceLoaderEvent.UNITCOMPLETE);
			te.data = this._loader;
			this.dispatchEvent(te);
			this._errorCounter = 0;
			this.counter++;
			this.run();
		}
		
		protected function removeEvents():void
		{
			if (this._loader != null) 
			{
				this._loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onComplete);
				this._loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			}
		}
		
		public function destroy():void 
		{
			this.removeEvents();
			this.stack = null;
			try 
			{
				this._loader.close();
			}catch (error:Error){}
			this._loader = null;
			this._isLoading = false;
		}
		
		//public function get loader():Loader { return this._loader; }
		
		public function get isLoading():Boolean { return _isLoading; }
		
		public function set errorCounter(value:Number):void 
		{_errorCounter = value;}
		
		//public function get bytesLoaded():Number { return _bytesLoaded; }
		
		//public function get bytesTotal():Number { return _bytesTotal; }
	}
	
}
