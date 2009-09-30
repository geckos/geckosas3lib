/*
* 常用矩阵操作
* 
* 以后的ColorMatrix类将会继承GMatrix, 并实现操纵亮度, 对比度, 色相, 饱和度等的操作
* GMatrix类至少还有multiphy方法还未完成, 代码注释还未完善, 方法名的命名还未完善
* 
* 
*/
package cn.geckos.geom
{

import cn.geckos.api.ICloneable;
import flash.errors.IllegalOperationError;

public class GMatrix implements ICloneable 
{
	private var _matrix:Array = [];
	private var _row:uint;
	private var _column:uint;
	
	private var _cloneAry:Array = [];
	
	//getter
	public function get row():uint
	{
		return this._row;
	}
	
	//getter
	public function get column():uint
	{
		return this._column;
	}
	
	//getter
	public function get matrix():Array
	{
		return this._matrix;
	}
	
	//setter
	/*
	public function set matrix(gx:Array):void
	{
		this._matrix = gx;
	}
	*/
	//构造函数
	//[1, 2, 3], 1, 3 代表着1行3列
	//格式化输出为
	//----------
	//1, 2, 3
	//----------
	public function GMatrix(matrix:Array, row:uint, column:uint):void
	{
		this._matrix = matrix;
		this._row = row;
		this._column = column;
		this._cloneAry = this._matrix.concat();
		
	}
	
	/*
	* 格式化输出
	*/
	protected function toFormatString():String
	{
		var str:String = "";
		var tempAry:Array = this.format();
		str += "----------------\n";
		for(var k:Number = 0; k<tempAry.length; k++)
		{
			str += "\t" + String(tempAry[k]) + "\n";
		}
		str += "----------------";
		return str;
	}
	
	/*
	* 转换至多维数组
	*/
	protected function format():Array
	{
		var tempAry:Array = [];
		var _ary:Array = this._matrix;
		var index:uint = 0;
		for(var i:uint = 0; i < this._row; i++)
		{
			tempAry[i] = new Array();
			for(var j:Number = 0; j < this._column; j++)
			{
				tempAry[i][j] = _ary[index++];
			}
		}
		return tempAry;
	}
	
	/*
	* 使用字符串描述矩阵
	*/
	public function toString():String
	{
		return this.toFormatString();
	}
	
	
	//返回当前矩阵的一个克隆对象
	public function clone():Object
	{
		return new GMatrix(this._matrix, this._row, this._column);
	}
	
	/**
	* 2个矩阵相加
	*/
	public function add(gx:GMatrix):void
	{
		var ary:Array = this.format();
		var otherAry:Array = gx.format();
	
		if(ary.length != otherAry.length || 
	   	this._row != gx._row || 
	   	this._column != gx._column) throw new IllegalOperationError("Warning: 2个矩阵的大小尺寸不同");
	
		var temp:Array = [];
		for(var i:uint = 0; i < this._row; i++)
		{
			temp[i] = new Array();
			for(var j:uint = 0; j < this._column; j++)
			{
				temp[i][j] = ary[i][j] + otherAry[i][j];
			}
		}
		
		this._matrix = oneDim(temp);
	}
	
	/**
	* 2个矩阵相减
	*/
	public function subtract(gx:GMatrix):void
	{
		var ary:Array = this.format();
		var otherAry:Array = gx.format();
		
		if(ary.length != otherAry.length || 
		   this._row != gx._row || 
	   	   this._column != gx._column) throw new IllegalOperationError("Warning: 2个矩阵的大小尺寸不同");
	
		var temp:Array = [];
		for(var i:uint = 0; i < this._row; i++)
		{
			temp[i] = new Array();
			for(var j:Number = 0; j < this._column; j++)
			{
				temp[i][j] = ary[i][j] - otherAry[i][j];
			}
		}
		
		this._matrix = oneDim(temp);
		
	}

	/*
	*
	*/
	protected function oneDim(ary:Array):Array
	{
		var all:uint = ary.length;
		var len:uint = all;
		var f:Array = ary[0];
		while(--len)
		{
			f = f.concat(ary[all - len]);
		}
		return f;
	}
	
	
	/**
	* 判断2矩阵是否相等
	*/
	public function isEqual(gx:GMatrix):Boolean
	{
		if(this._matrix.length != gx._matrix.length || 
		   this._row != gx._row || 
		   this._column != gx._column) return false;
	
		var _aryA:Array = this.format();
		var _aryB:Array = gx.format();
		
		for(var i:uint = 0; i<_aryA.length; i++)
		{
			for(var j:uint = 0; j<_aryB.length; j++)
			{
				if(_aryA[i][j] != _aryB[i][j]) return false;
			}
		}
		return  true;
	}
	
	public function reset():void
	{
		this._matrix = this._cloneAry;
	}
	
	/*
	* 转换矩阵
	* @return 
	* 比如: 3行* 1列 变为1行 * 3列
	*/
	public function transpose():GMatrix
	{
		var gx:GMatrix = clone() as GMatrix;
		var format:Array = gx.getRegularMatrix();
		var tempAry:Array = [];
		
		gx._row = this._column;
		gx._column = this._row;
		
		for(var i:uint = 0; i < gx._row; i++)
		{
			tempAry[i] = new Array();
			for(var j:uint = 0; j < gx._column; j++)
			{
				tempAry[i][j] = format[j][i];
			}
		}
		
		gx._matrix = gx.oneDim(tempAry);
		return gx as GMatrix;
	}
	
	/*
	* 返回正规的矩阵的数组形式
	* @return 
	*/
	protected function getRegularMatrix():Array
	{
		var tempAry:Array = [];
		for(var i:uint = 0; i < this._row; i++)
		{
			tempAry[i] = new Array();
			for(var j:uint = 0; j < this._column; j++)
			{
				tempAry[i][j] = this._matrix[j + i * this._column];
			}
		}
		return tempAry;
	}
	
	/*
	* 计算2个矩阵彼此是否可以相乘
	* @return 
	*/
	protected function isCouldMultiply(gx:GMatrix):Boolean
	{
		return this._column == gx._row;
	}
	
	/*
	* 计算相乘后的行, 列值
	* @return 返回一个存储行列的数组
	*/
	protected function count(gx:GMatrix):Array
	{
		return [this._row, gx._column];
	}
	
	/*
	*  2矩阵相乘
	*  
	*/
	public function multiply(gx:GMatrix):void
	{
		if(!this.isCouldMultiply(gx)) throw new IllegalOperationError("不符合矩阵相乘的规则");
		var cm:Array = this._matrix;
		var om:Array = gx._matrix;
		var currentAry:Array = [];
		var tempAry:Array = [];
		
		//先计算m矩阵的右边的列数
		for(var i:uint = 0; i < gx._column; i++)
		{
			for(var j:uint = 0; j < this._column; j++)
			{
				currentAry[j] = om[i + gx._column * j];
			}	
			// 整行的计算
			for(var h:uint = 0; h < this._row; h++)
			{
				var value:Number = 0;
				//从数组中提取, 生成单个数值(整列中的一个)
				for(var z:uint = 0; z < currentAry.length; z++)
				{
					value += currentAry[z] * cm[z + (h * this._column)];
				}
				tempAry[i + (h * gx._column)] = value;
			}
		}
		
		//setter
		var overShow:Array = this.count(gx);
		this._row = overShow[0];
		this._column = overShow[1];
		this._matrix = tempAry;
	}
	
	
}

}















