package cn.geckos.utils 
{
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Loader;
import flash.display.MovieClip;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.geom.Transform;
import flash.text.TextField;
/**
 * ...显示对象工具
 * @author Kanon
 */
public class DisplayObjectUtil 
{
	/**
	 * 删除容器内所有的显示对象
	 * @param	o  容器
	 */
	public static function removeAllChild(o:DisplayObjectContainer):void
	{
		if (!o) return;
		var numChildren:int = o.numChildren;
		for (var i:int = numChildren - 1; i >= 0; i -= 1)
		{
			o.removeChild(o.getChildAt(i));
		}
	}
	
	/**
	 * 删除某个显示对象
	 * @param	o 某个显示对象
	 */
	public static function removeChild(o:DisplayObject):void
	{
		if (o && o.parent)
			o.parent.removeChild(o);
	}

	/**
	 * 获取真实的指定显示对象的长宽（不受是否在舞台, 或者ScrollRect属性的影响，或者scaleX, scaleY的设置）
	 * 
	 * 直接获取dis.transform.pixelBounds 获取的是经过设置过scaleX, scaleY的长宽, 
	 * 如不在舞台需要除以5以获取实际值(原因不明)。
	 * 
	 * getBounds目前测试是不受任何影响, 包括了不在舞台的情况, 获得的均是原始值
	 * 
	 * @param dis  指定显示对象
	*
	* @example
	*  var size:Rectangle = getActualSize(_mc);
	*  var w:Number = size.width; //宽
	*  var h:Number = size.height; //高
	 */ 
	public static function getActualSize(dis:DisplayObject):Rectangle{		
		//TODO, 特例, pixelBounds无法返回文本的长宽, 只能返回对应坐标
		if(dis is TextField){
			return dis.getBounds(dis);
		}
		
		//solution two
		//inspiration from joe@usecake.com and senocular.com
		var currentTransform:Transform = dis.transform;
		var currentMatrix:Matrix = currentTransform.matrix;
		var globalMatrix:Matrix = currentTransform.concatenatedMatrix;
		
		globalMatrix.invert();
		globalMatrix.concat(currentMatrix);
		currentTransform.matrix = globalMatrix;
		
		var rect:Rectangle = currentTransform.pixelBounds;
		currentTransform.matrix = currentMatrix; //reset the position, scale and skew value
		return rect;
	}

	/**
	 * 对指定影片剪辑及其子集影片剪辑调用指定方法
	 * @param mc 	指定影片剪辑
	 * @param rawMethodName  需要调用的方法名
	 *
	 * @example
	 * 将_mc中的所有影片剪辑调用gotoAndStop，并停在第一帧
	 * runMethodInMovie(_mc, "gotoAndStop", 1);
	 */
	public static function runMethodInMovie(mc:MovieClip, rawMethodName:String, ...args):void{
		if(!mc || !mc.hasOwnProperty(rawMethodName)){
			return;
		}
		var len:int = mc.numChildren;
		while(--len > -1){
			var d:MovieClip = mc.getChildAt(len) as MovieClip;
			if(d){
				d[rawMethodName].apply(d, args[0] is Array ? args[0] : args);
				runMethodInMovie(d, rawMethodName, args);
			}
		}
	}


    /**
	 * 清除指定bitmapData对象中拥有透明像素的部分
	 * 
	 * @param bitmapData  指定检查的bitmapData
	 * @return            返回的清除过透明像素的bitmapData, 代入的bitmapData会被清除, 需要使用返回的bitmapData
	 * 
	 * @example
	 *  var b:BitmapData = bitmap.bitmapData;
	 *  b = getOpaqueBitmapData(b);
	 *  bitmap.bitmapData = b;
	 */ 
	public static function getOpaqueBitmapData(bitmapData:BitmapData):BitmapData{
		var unTransparentArea:Rectangle = bitmapData.getColorBoundsRect(0xFF000000, 0x00000000, false);
		var c:BitmapData = new BitmapData(unTransparentArea.width, unTransparentArea.height, true, 0);
		c.copyPixels(bitmapData, unTransparentArea.clone(), new Point(0, 0));
		bitmapData.dispose();
		return c;
	}
	
	/**
	 *  由于Loader本身也为DisplayObject类型, 但是无法保证所加载的显示对象是否可以绘制(是否有安全策略文件)
	 * 所以该方法的目的是检测其中加载的DisplayObject是否能被调用诸如BitmapData的draw方法。
	 */
	private static function __checkDraw(dis:DisplayObject):Boolean{
		if(dis is Loader){
			return (dis as Loader).contentLoaderInfo.childAllowsParent;
		}
		return true;
	}

	
	/**
	 * 获取指定显示对象的注册点位置(bitmapData的draw方法的绘制中需要这个偏移量)
	 * @param d       指定显示对象    
	 * @param scaleX  x轴缩放值  
	 * @param scaleY  y轴缩放值
	 * @return point  
	 *  
	 * @example
	 * var p:Point =  getLeftTopPosition(_mc);
	 * trace(p);
	 */
	public static function getLeftTopPosition(d:DisplayObject, scaleX:Number = NaN, scaleY:Number = NaN):Point {
		if(!isNaN(scaleX)){
			d.scaleX = scaleX;
		}
		if(!isNaN(scaleY)){
			d.scaleY = scaleY;
		}
		var rect:Rectangle = d.getBounds(d);
		var m:Matrix = d.transform.matrix;
		var scaleX:Number = m.a;
		var scaleY:Number = m.d;
		var rx:Number, ry:Number;
		rx = scaleX >0 ? m.a * rect.left : m.a * rect.right;
		ry = scaleY >0 ? m.d * rect.top : m.d * rect.bottom;
		return new Point(-rx|0, -ry|0);
	}
	
	/**
	 * 获取指定显示对象的Bitmap形式
	 *
	 * @param dis   指定显示对象
	 * @return      返回的bitmap对象
	 * 
	 * @example
	 * var b:Bitmap = getBitmap(_mc);
	 */ 
	public static function getBitmap(dis:DisplayObject):Bitmap{	
		var bitmapData:BitmapData = getBitmapData(dis);
		return new Bitmap(bitmapData);
	}
	
	/**
	 * 获取指定显示对象的bitmapData格式
	 * 
	 * @param d 指定显示对象
	 * @param scaleX   可能需要添加的x轴缩放值
	 * @param scaleY   可能需要添加的y轴缩放值
	 * 
	 * @return bitmapData
	 * @example
	 * var b:BitmapData = getBitmapData(_mc);
	 */ 
	public static function getBitmapData(d:DisplayObject, scaleX:Number = 1.0, scaleY:Number = 1.0):BitmapData{
		if(d.width <= 0 || d.height <= 0){
			return null;
		}
		if(!__checkDraw(d)){
			return null;
		}
		var offset:Point = getLeftTopPosition(d, scaleX, scaleY);
		var bitmapData:BitmapData = new BitmapData(d.width, d.height, true, 0);
		var mtx:Matrix = new Matrix(scaleX, 0, 0, scaleY, offset.x, offset.y);
		bitmapData.draw(d, mtx);
		return bitmapData;
	}
}
}
