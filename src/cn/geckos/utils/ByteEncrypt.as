package cn.geckos.utils
{
import flash.utils.ByteArray;
/**
 * 基于二进制的简易/快速的不变长加解密算法
 */
public final class ByteEncrypt
{
	private static const XorKeys:Array = [0xB2, 0x09, 0xAA, 0x55, 0x93, 0x6D, 0x84, 0x47];
	/**
	 * 加密
	 */
	public static function encode(buf:ByteArray):ByteArray
	{
		var out:ByteArray = new ByteArray();
		if (buf && buf.length)
		{
			buf.position = 0;
			var flag:int = 0;
			var b:int;
			while (buf.bytesAvailable)
			{
				b = buf.readUnsignedByte();
				out.writeByte(b ^ XorKeys[flag]);
				flag = ++flag % 8;
			}
			out.position = 0;
		}
		return out;
	}
	
	/**
	 * 解密
	 */
	public static function decode(buf:ByteArray):ByteArray 
	{
		var out:ByteArray = new ByteArray();
		if (buf && buf.length)
		{
			buf.position = 0;
			var flag:int = 0;
			var b:int;
			while (buf.bytesAvailable) 
			{
				b = buf.readUnsignedByte();
				out.writeByte(b ^ XorKeys[flag]);
				flag = ++flag % 8;
			}
			out.position = 0;
		}
		return out;
	}
}
}