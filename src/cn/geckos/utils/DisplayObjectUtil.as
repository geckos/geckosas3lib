package cn.geckos.utils 
{
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Graphics;
import flash.display.Loader;
import flash.display.MovieClip;
import flash.geom.ColorTransform;
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
	
	
	/**
	 * @param	container   一个指定容器（Sprite 或者 Movieclip)
	 * @param	scale9Grids 设定的9slice 矩形对象
	 * @example 
	 *	var r:Rectangle = new Rectangle(23, 21, 44, 47);//9slice 尺寸
         *	convertBitmaptoScale9(_mc, r);//清除原始Bitmap信息，转而在该mc的graphics中绘制
	 * 需要注意的是该方法没有返回container中的位图的bitmapData对象, 如果这个bitmapData对象调用dispose
	 * 被销毁, 那么依靠beginBitmapFill进行绘图的显示对象中的图形会被清除
	 */
	public static function convertBitmaptoScale9(container:DisplayObjectContainer, scale9Grids:Rectangle):void{
		var b:Bitmap = container.removeChildAt(0) as Bitmap; //获取到的是Bitmap而不是Shape,就是因为在库中取了链接名
		var topDown:Array = [scale9Grids.top, scale9Grids.bottom, b.height];
		var leftRight:Array = [scale9Grids.left, scale9Grids.right, b.width];
		var g:Graphics = Sprite(container).graphics;
		var bd:BitmapData = b.bitmapData.clone();
		var topDownStepper:int = 0;
		var leftRightStepper:int = 0;
		for(var i:int = 0; i < 3; i ++){
			for(var j:int = 0; j < 3; j ++){
				g.beginBitmapFill(bd, null, true, true);
				g.drawRect(leftRightStepper, topDownStepper,
					leftRight[i] - leftRightStepper, topDown[j] - topDownStepper);
				g.endFill();
				topDownStepper = topDown[j];
			}
			leftRightStepper = leftRight[i];
			topDownStepper = 0;
		}
		container.scale9Grid = scale9Grids;
		b.bitmapData.dispose();
		b.bitmapData = null;
	}
	
	/**
	 * 根据给定的显示对象获取实际显示的长宽
	 * @param dis
	 * @return 
	 * @example
	 * 绘制一个shape盖在_mc上, 这个shape的覆盖区域就是_mc的不透明矩形区域
	 *  var r:Rectangle = getDisplaySize(_mc);
	 *	var s:Shape = new Shape();
	 *	addChild(s);
	 *	s.graphics.beginFill(0, .4);
	 *	s.graphics.drawRect(r.x, r.y, r.width, r.height);
	 *	s.graphics.endFill();
	 *	s.x = _mc.x;
	 *	s.y = _mc.y;
	 */
	public static function getDisplaySize(dis:DisplayObject):Rectangle{
		var b:Rectangle = dis.getBounds(dis);
		var t:Matrix = dis.transform.matrix;
		var d:BitmapData = new BitmapData(b.width * t.a, b.height * t.d, true, 0);
		d.draw(dis, new Matrix(t.a, 0, 0, t.d, -b.x * t.a, -b.y * t.d));
		var r:Rectangle = d.getColorBoundsRect(0xFF000000, 0, false);
		d.dispose();
		r.x += b.x * t.a;
		r.y += b.y * t.d;
		return r;
	}
	
	/**
	 * @param dis 指定显示对象
	 * 设置了scrollRect, 又或者移除舞台，而后添加至舞台, 会导致可视长宽无法及时获得, 
	 * 需要延迟一帧才能获得 (移除舞台到添加至舞台, 添加至舞台到移除舞台，具体表现还不一致)
	 * 似乎也可以使用draw绘制当前可视范围, 但也需要注意当前显示对象如果为loader,可能会
	 * 导致安全报错
	 * getBounds 只对设置过的scrollRect 起作用, 对内部visible为false始终保持原始的该区域的值
	 */ 
	public static function invalidateRedraw(dis:DisplayObject):void{
		var area:Rectangle = dis.scrollRect;
		dis.scrollRect = null;
		__redraw(dis);
		dis.scrollRect = area;
		__redraw(dis);
	}
	
	/**
	 * 检查指定显示对象在指点鼠标点下是否为透明
	 * @param dis   指定显示对象
	 * @param point 指定鼠标点Point对象, 为舞台全局坐标         
	 */ 
	public static function checkPointIsTransParent(dis:DisplayObject, point:Point):Boolean{
		if(!dis){
			return true;
		}
		checkTransParent.fillRect(checkTransParent.rect, 0);
		checkPoint.x = point.x;
		checkPoint.y = point.y;
		checkPoint = dis.globalToLocal(checkPoint);
		checkMatrix.tx = -checkPoint.x|0;
		checkMatrix.ty = -checkPoint.y|0;
		checkTransParent.draw(dis, checkMatrix);
		return ((checkTransParent.getPixel32(0, 0) >>> 24) & 0xFF) < 0x80;
	}
	
	/**
	 * 将以下三种类型变量常量提出, 是为了避免每帧创建所带来的内存浪费
	 */ 
	private static const checkTransParent:BitmapData = new BitmapData(1, 1, true, 0);
	private static const checkMatrix:Matrix = new Matrix();
	private static var checkPoint:Point = new Point();
	
	
	
	/**
	 * 检查指定显示对象是否在舞台上, 可以使用Stage属性是否为空为判断条件, 还有个方法是检测显示对象的loaderInfo属性是否为空
	 * 但是当一个loader加载了一个显示对象后, 就不要去检测被加载对象它的LoaderInfo属性, 
	 * 即使该loader对象不在舞台, 它的loaderInfo属性也不为空
	 * @param dis
	 * @return
	 */
	public static function isOnStage(dis:DisplayObject):Boolean {
		if(dis && dis.stage && dis.visible){
			var main:Rectangle = new Rectangle(0, 0, dis.stage.stageWidth, dis.stage.stageHeight);
			var p:Point = dis.parent.localToGlobal(new Point(dis.x, dis.y));
			return main.containsPoint(p);
		}
		return false;
	}
	
	
	/**
	 * 获取指定显示对象的位图数据对象
	 * @param dis
	 * @param sx
	 * @param sy
	 * @see getBitmapData (这里将ColorTransform, filters 计算在内) 
	 * @return 
	 */
	public static function getCopy(dis:DisplayObject, sx:Number = 1.0, sy:Number = 1.0):BitmapData{
		if(dis.width <= 0 || dis.height <= 0){
			return null;
		}
		if(!__checkDraw(dis)){
			return null;
		}
		var wh:Rectangle = getActualSize(dis);
		var c:ColorTransform = dis.transform.colorTransform;
		var len:int = dis.filters.length;
		var p:Point = getLeftTopPosition(dis, sx, sy);
		var b:Rectangle = new Rectangle(0, 0, wh.width, wh.height);
		if(len > 0){
			for(var i:int = 0; i < len; i ++){
				var temp:BitmapData = new BitmapData(wh.width, wh.height, true, 0);
				var tempRect:Rectangle = temp.generateFilterRect(temp.rect, dis.filters[i]);
				b = b.union(tempRect);
				temp.dispose();
			}
		}
		var mt:Matrix = new Matrix(sx, 0, 0, sy, -b.x + p.x, -b.y + p.y);
		var dt:BitmapData = new BitmapData(b.width, b.height, true, 0);
		dt.draw(dis, mt, c);
		return dt;
	}
	
	
	/**
	 * 将指定显示对象绘制成一个指定长宽的位图数据对象
	 * @param dis
	 * @param range
	 * @return 
	 */
	public static function sampling(dis:DisplayObject, range:Rectangle = null):BitmapData{
		if((dis.width == 0) || (dis.height == 0)){
			return null;
		}
		if(!__checkDraw(dis)){
			return null;
		}
		if(!range || ((range.width >= dis.width) && (range.height >= dis.height))){
			return DisplayObjectUtil.getBitmapData(dis);
		}
		//var rect:Rectangle = dis.transform.pixelBounds;
		var rect:Rectangle = dis.getBounds(dis);
		var s:Number;
		if(range.width < dis.width){
			dis.width = range.width;
			dis.height = range.width * (rect.height / rect.width);
			s = range.width / rect.width;
		}
		if(range.height < dis.height){
			dis.height = range.height;
			dis.width = range.height * (rect.width / rect.height);
			s = range.height / rect.height;
		}
		var bd:BitmapData = new BitmapData(dis.width, dis.height, true, 0);
		var topLeft:Point = DisplayObjectUtil.getLeftTopPosition(dis);
		bd.draw(dis, new Matrix(s, 0, 0, s, topLeft.x, topLeft.y));
		return bd;
	}
	
	
}
}
