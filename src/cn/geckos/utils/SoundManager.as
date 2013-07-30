package cn.geckos.utils 
{
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.media.SoundTransform;
import flash.net.URLRequest;
import flash.utils.getDefinitionByName;
/**
 * ...声音管理
 * @author Kanon
 */
public class SoundManager extends EventDispatcher
{
	//声音对象
	private var sound:Sound;
	//声音通道对象
	private var channel:SoundChannel;
	//声音控制
	private var soundTf:SoundTransform;
	//声音开关
	private var soundSwitch:Boolean;
	//播放的位置
	private var soundPosition:Number;
	//循环次数
	private var soundLoops:uint;
	//请求地址
	private var req:URLRequest;
	/**
	 * 创建声音对象
	 * @param	soundName	声音对象名字
	 */
	public function createSound(soundName:String):void
	{
		this.stop();
		this.removeLoadEventListeners();
		var SoundClass:Class = getDefinitionByName(soundName) as Class;
		this.sound = new SoundClass();
		if (!this.soundTf) 
			this.soundTf = new SoundTransform();
	}
	
	private function soundCompleteHandler(event:Event):void 
	{
		if (this.soundLoops > 0)
		{
			this.play(0, this.soundLoops);
			this.soundLoops--;
		}
		this.dispatchEvent(event);
	}
	
	/**
	 * 播放声音
	 * @param	startTime	声音的开始时间
	 * @param	loops		循环次数
	 */
	public function play(startTime:Number = 0, loops:uint = 0):void
	{
		if (!this.sound) return;
		this.channel = this.sound.play(startTime, 0);
		this.channel.soundTransform = this.soundTf;
		if (!this.channel.hasEventListener(Event.SOUND_COMPLETE))
			this.channel.addEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
		this.soundSwitch = true;
		this.soundLoops = loops;
	}
	
	/**
	 * 停止声音
	 */
	public function stop():void
	{
		if (!this.channel) return;
		this.soundPosition = this.channel.position;
		this.channel.stop();
		this.soundSwitch = false;
	}
	
	/**
	 * 暂停或恢复
	 */
	public function togglePause():void
	{
		this.soundSwitch = !this.soundSwitch;
		if (!this.soundSwitch) this.stop();
		else this.play(this.soundPosition, this.soundLoops);
	}
	
	/**
	 * 设置音量
	 * @param	value
	 */
	public function setVolume(value:Number):void
	{
		if (!this.soundTf) return;
		this.soundTf.volume = value;
	}
	
	/**
	 * 加载声音
	 * @param	url	声音地址
	 */
	public function loadSound(url:String):void
	{
		this.stop();
		this.removeEventListeners();
		//Sound对象只允许被load一个声音流,即使close()了也不能加载另一个声音.
		this.sound = new Sound();
		if (!this.req) this.req = new URLRequest(url);
		else this.req.url = url;
		if (!this.soundTf) this.soundTf = new SoundTransform();
		
		if (!this.sound.hasEventListener(IOErrorEvent.IO_ERROR))
			this.sound.addEventListener(IOErrorEvent.IO_ERROR, loadErrorHandler);
		
		if (!this.sound.hasEventListener(ProgressEvent.PROGRESS))
			this.sound.addEventListener(ProgressEvent.PROGRESS, loadProgressHandler);
		
		if (!this.sound.hasEventListener(Event.COMPLETE))
			this.sound.addEventListener(Event.COMPLETE, loadCompleteHandler);
		
		this.sound.load(this.req);
	}
	
	private function loadCompleteHandler(event:Event):void 
	{
		this.dispatchEvent(event);
	}
	
	private function loadErrorHandler(event:IOErrorEvent):void 
	{
		this.dispatchEvent(event);
	}
	
	private function loadProgressHandler(event:ProgressEvent):void 
	{
		this.dispatchEvent(event);
	}
	
	/**
	 * 销毁时间监听
	 */
	private function removeEventListeners():void
	{
		if (this.channel && 
			this.channel.hasEventListener(Event.SOUND_COMPLETE))
			this.channel.removeEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
	}
	
	/**
	 * 销毁加载用的事件
	 */
	private function removeLoadEventListeners():void
	{
		if (this.sound)
		{
			if (this.sound.hasEventListener(IOErrorEvent.IO_ERROR))
				this.sound.removeEventListener(IOErrorEvent.IO_ERROR, loadErrorHandler);
			
			if (this.sound.hasEventListener(ProgressEvent.PROGRESS))
				this.sound.removeEventListener(ProgressEvent.PROGRESS, loadProgressHandler);
				
			if (this.sound.hasEventListener(Event.COMPLETE))
				this.sound.removeEventListener(Event.COMPLETE, loadCompleteHandler);
		}
	}
	
	/**
	 * 销毁方法
	 */
	public function destroy():void
	{
		this.stop();
		this.removeEventListeners();
		this.removeLoadEventListeners();
		this.channel = null;
		this.soundTf = null;
		this.req = null;
		this.sound = null;
	}
}
}