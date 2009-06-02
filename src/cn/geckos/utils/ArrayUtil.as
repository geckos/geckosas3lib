/////////////////////////////////////////////////////////
//  
//  用于处理常用的数组的操作(排序, 查找)
//  
////////////////////////////////////////////////////////

package cn.geckos.utils
{
public final class ArrayUtil
{
	/**
	 * 执行插入排序
	 * @param	ary
	 */
	public static function insertionSort(ary:Array):void
	{
		var len:Number = ary.length;
		for(var i:Number = 1; i<len; i++)
		{
			var val:Number = ary[i];
			for(var j:Number = i; j > 0 && ary[j - 1] > val; j--)
			{
				ary[j] = ary[j - 1];
			}
			ary[j] = val;
		}
	}

	/**
	 * 执行二分搜索
	 * @param	ary
	 * @param	value
	 * @return  返回匹配结果的数组索引
	 */
	public static function binarySearch(ary:Array, value:Number):Number
	{
		var startIndex:Number = 0;
		var endIndex:Number = ary.length;
		var sub:Number = (startIndex + endIndex) >> 1;
		while(startIndex < endIndex)
		{
			if(value <= ary[sub]) endIndex = sub;
			else if(value >= ary[sub]) startIndex = sub + 1;
			sub = (startIndex + endIndex) >> 1;
		}
		if(ary[startIndex] == value) return startIndex;
		return -1;
	}
	
	
	/**
	 * 返回匹配项的索引
	 * @param	ary
	 * @param	num
	 * @return  返回匹配项的索引
	 */
	public static function findElementIndex(ary:Array, num:int):int
	{
		var len:int = ary.length;
		for(var i:int = 0; i<len; i++)
		{
			if(ary[i] == num)
				return i;
		}
		return -1;
	}
	
	/**
	 * 返回数组中最大值的索引
	 * @param	ary
	 * @return  返回数组中最大值的索引
	 */
	public static function getMaxElementIndex(ary:Array):int
	{
		var matchIndex:int = 0;
		var len:int = ary.length;		
		for(var j:int = 1; j < len; j++)
		{
			if(ary[j] > ary[matchIndex])
				matchIndex = j;
		}
		return matchIndex;
	}
	
	/**
	 * 返回数组中最小值的索引
	 * @param	ary
	 * @return  返回数组中最小值的索引
	 */
	public static function getMinElementIndex(ary:Array):int
	{
		var matchIndex:int = 0;
		var len:int = ary.length;
		for(var j:int = 1; j < len; j++)
		{
			if(ary[j] < ary[matchIndex])
				matchIndex = j;
		}
		return matchIndex;	
	}
}
}

