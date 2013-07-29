package cn.geckos.utils 
{
import flash.events.Event;
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.utils.getDefinitionByName;
/**
 * ...声音管理
 * @author Kanon
 */
public class SoundManager
{
	//声音对象
	private static var sound:Sound;
	//声音通道对象
	private static var channel:SoundChannel;
	//声音开关
	private static var soundSwitch:Boolean;
	//播放的位置
	private static var soundPosition:Number;
	//循环次数
	private static var soundLoops:uint;
	//播放结束方法
	public static var completeFun:Function;
	/**
	 * 创建声音对象
	 * @param	soundName	声音对象名字
	 */
	public static function createSound(soundName:String):void
	{
		SoundManager.stop();
		var SoundClass:Class = getDefinitionByName(soundName) as Class;
		sound = new SoundClass();
	}
	
	private static function soundCompleteHandler(event:Event):void 
	{
		if (soundLoops > 0)
		{
			SoundManager.play(0, soundLoops);
			soundLoops--;
		}
		if (completeFun is Function)
			completeFun();
	}
	
	/**
	 * 播放声音
	 * @param	startTime	声音的开始时间
	 * @param	loops		循环次数
	 */
	public static function play(startTime:Number = 0, loops:uint = 0):void
	{
		if (!sound) return;
		channel = sound.play(startTime, 0);
		if (!channel.hasEventListener(Event.SOUND_COMPLETE))
			channel.addEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
		soundSwitch = true;
		soundLoops = loops;
	}
	
	/**
	 * 停止声音
	 */
	public static function stop():void
	{
		if (!channel) return;
		soundPosition = channel.position;
		channel.stop();
		soundSwitch = false;
	}
	
	/**
	 * 暂停或恢复
	 */
	public static function togglePause():void
	{
		soundSwitch = !soundSwitch;
		if (!soundSwitch) stop();
		else play(soundPosition, soundLoops);
	}
	
}
}