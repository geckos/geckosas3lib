package cn.geckos.net 
{
	import flash.events.Event;
	
	/**
	* ...
	* @author Jeff.xu (http://blog.jeffxu.cn)
	*/
	public class SequenceLoaderEvent extends Event 
	{
		public static const UNITCOMPLETE:String = "unit_complete";
		private var _data:Object;
		
		public function SequenceLoaderEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
		} 
		
		public override function clone():Event 
		{ 
			return new SequenceLoaderEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("SequenceLoaderEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
		public function get data():Object { return _data; }
		
		public function set data(value:Object):void 
		{
			_data = value;
		}
		
	}
	
}
