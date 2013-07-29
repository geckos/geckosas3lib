package cn.geckos.utils 
{
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.media.SoundTransform;
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
	/**
	 * 创建声音对象
	 * @param	soundName	声音对象名字
	 */
	public function createSound(soundName:String):void
	{
		this.stop();
		var SoundClass:Class = getDefinitionByName(soundName) as Class;
		this.sound = new SoundClass();
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
		if (!this.soundSwitch) stop();
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
}
}