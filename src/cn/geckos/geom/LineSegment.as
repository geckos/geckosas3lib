package cn.geckos.geom
{
import cn.geckos.api.ICloneable;
import cn.geckos.utils.MathUtil;

/////////////////////////////////////////
//
// LineSegment类(2D)
//
/////////////////////////////////////////

public class LineSegment implements ICloneable 
{
	//TODO
	private static var LINE_HORIZONTAL:String = "horizontal";//水平
	
	private static var LINE_VERTICAL:String = "vertical";//垂直
	
	private static var LINE_PARALLEL:String = "parallel";//平行
	
	private static var LINE_OVERLAP:String = "overlap";//覆盖
	
	private static var LINE_UNEXPECTED:String = "unexpected";//其它
	
	
	private var startPoint:Vector2D;
	
	private var endPoint:Vector2D;
	
	
	/**
	 * 初始化
	 * @param	sp
	 * @param	ep
	 */
	public function LineSegment(sp:Vector2D, ep:Vector2D):void 
	{
		this.startPoint = sp;
		this.endPoint = ep;
	}

	
	/**
	 * 获得该线段的截距(和y轴相交的点的y值)
	 * @return
	 */
    public function getIntercept():Number
	{
		var slope:Number = this.getLineSlope();
		//var ep:Vector2D = this.endPoint; 这个变量没用到么？
		
		return this.endPoint.y - slope * this.endPoint.x; 
	}
	
	
	/**
	 * 获得一个线段的斜率
	 * @return
	 */
	public function getLineSlope():Number
	{
		var sp:Vector2D = this.startPoint;
		var ep:Vector2D = this.endPoint;
		return (ep.y - sp.y) / (ep.x - sp.x);
	}
	
	
	/**
	 * 返回一个复制的line对象
	 * @return
	 */
	public function clone():Object
	{
		return new LineSegment(this.startPoint, this.endPoint);
	}
	
	
	/**
	 * 输出起始点和结尾点
	 * @return
	 */
	public function toString():String
	{
		return "startPoint-[" + this.startPoint + "]" + "::" + 
			   "endPoint-[" + this.endPoint + "]";
	}
	
	
	/**
	 * 输出线段的数学表达式y = kx + b
	 * @return
	 */
    public function toMathString():String
	{
		var slope:Number = this.getLineSlope();
		var intercept:Number = this.getIntercept();
		return "[" + "y = " + slope + "X" + " + " + intercept + "]";
	}
	
	
	/**
	 * 判断线段是否是水平于x轴
	 * @return
	 */
    public function isHorizontal():Boolean
	{
		return (this.endPoint.y - this.startPoint.y) == 0;
	}
	
	
	/**
	 * 判断线段是否是水平于y轴
	 * @return
	 */
    public function isVertical():Boolean
	{
		return (this.endPoint.x - this.startPoint.x) == 0;
	}
	
	
    /**
	 * 检测2线条是否互相垂直
     * 对垂直线不起作用, 垂直的线会遇到(y / 0)的情况
     * @param	line
     * @return
     */
    public function isPerpendicular(line:LineSegment):Boolean
	{
		var slopeA:Number = this.getLineSlope();
		var slopeB:Number = line.getLineSlope();
		return (slopeA * slopeB) == -1;
	}
    
	/**
	 * 判断2条线是否平行
	 * 对垂直线不起作用, 垂直的线会遇到(y / 0)的情况
	 * @param	line
	 * @return
	 */
	public function isParallel(line:LineSegment):Boolean
	{
		var slopA:Number = this.getLineSlope();
		var slopB:Number = line.getLineSlope();
		return (slopA == slopB);
	}
	
	
	/**
	 * 求出2条线之间的夹角
	 * 公式 tanA = |(k2-k1)/(1-k1*k2)| (0 < A < 90);
	 * 对垂直线不起作用, 垂直的线会遇到(y / 0)的情况
	 * @param	line  求出2条线之间的夹角
	 * @param	degrees 是否返回角度值
	 * @return
	 */
	public function angleBetween(line:LineSegment,degrees:Boolean = true):Number
	{
		var slopA:Number = this.getLineSlope();
		var slopB:Number = line.getLineSlope();
		var tanA:Number = Math.abs((slopB - slopA) / (1 + slopA * slopB));
		var angle:Number = Math.atan(tanA);
		if (degrees) angle = MathUtil.rds2dgs(angle);
		return angle;
	}
	
	/**
	 * 如果已知改线段和参数line线段垂直, 取得改line线段的斜率
	 * @param	line
	 * @return
	 */
	public function getSibling(line:LineSegment):Object
	{
		if(this.isPerpendicular(line))
		{
			return (-1 / this.getLineSlope());
		}
		return null;
	}
	
	
	/**
	 * TODO
	 * 取得另一条线段(垂直于己的2条线段)
	 * @return
	 */
	public function getSiblingLine():Object
	{
		var oSlope:Number = (-1 / this.getLineSlope());
		var tempA:Vector2D = this.startPoint;
		var tempB:Vector2D = this.endPoint;
		var tempLine:Object = {};
		var interceptA:Number = tempA.y - oSlope * tempA.x;
		var interceptB:Number = tempB.y - oSlope * tempB.x;
		var lineAStr:String = "[" + "y = " + oSlope + "X" + " + " + interceptA + "]";
		var lineBStr:String = "[" + "y = " + oSlope + "X" + " + " + interceptB + "]";
		tempLine.lineA = lineAStr;
		tempLine.lineB = lineBStr;
		return tempLine;
	}
	
	
	/**
	 * 指定点是否在线条的轨迹上
	 * @param	point
	 * @return
	 */
    public function isInLineTrack(point:Vector2D):Boolean
	{
		var slope:Number = this.getLineSlope();
		var startPoint:Vector2D = this.startPoint;
		var endPoint:Vector2D = point;
		return ((endPoint.y - startPoint.y) / (endPoint.x - startPoint.x)) == slope;
	}

	
	/**
	 * 返回线段的斜率和截距
	 * @return
	 */
    public function getLineObj():Object
	{
		return {slope:this.getLineSlope(), intercept:this.getIntercept()};
	}
	
	
	/**
	 * 判断2线段是否有可能相交
	 * @param	line
	 * @return
	 */
    public function hasIntersection(line:LineSegment):Boolean
	{
		var lineASlope:Number = this.getLineSlope();
		var lineBSlope:Number = line.getLineSlope();
		return lineASlope != lineBSlope;
	}
	

	/**
	 * TODO
	 * 取得2线段的基本关系
	 * @return
	 */
	public function getRelation(line:LineSegment):String
	{
		if(this.isHorizontal() && line.isHorizontal())
		{
			return LINE_HORIZONTAL;
		}
		
		if(this.isVertical() && line.isVertical())
		{
			return LINE_VERTICAL;
		}
		
		if(this.getLineSlope() == line.getLineSlope())
		{
			return LINE_PARALLEL;
		}
		
		if(this.getLineObj().slope == line.getLineObj().slope && 
			this.getLineObj().intercept == line.getLineObj().intercept) 
		{
			return LINE_OVERLAP;
		}
		else
		{
			return LINE_UNEXPECTED;
		}
	}

	//TODO
    public function isEqual(line:LineSegment):Boolean
	{
		return (this.startPoint.equals(line.startPoint) && 
	       this.endPoint.equals(line.endPoint)) ||	
		   (this.startPoint.equals(line.endPoint) &&
		   this.endPoint.equals(line.startPoint));
	}

	/**
	 * 获得2条线段的可能的相交点
	 * @param	line
	 * @return
	 */
    public function getIntersectionPoint(line:LineSegment):Object
	{
		if(this.getRelation(line) != LINE_UNEXPECTED)
			return null;
			
		var lineA:Object = this.getLineObj();
		var lineB:Object = line.getLineObj();
	
		var slopeA:Number = lineA.slope;
		var slopeB:Number = lineB.slope;
	
		var interceptA:Number = lineA.intercept;
		var interceptB:Number = lineB.intercept;
	
		var tempX:Number = (interceptB - interceptA) / (slopeA - slopeB);
		var tempY:Number = slopeA * tempX + interceptA;
	
		return new Vector2D(tempX, tempY);
	}
	
	
	/**
	 * 判断2条线段相交的点是否在这2条线段上
	 * @param	line
	 * @return
	 */
    public function isIntersection(line:LineSegment):Boolean
	{
		var value:Object = this.getIntersectionPoint(line);
		if (!value) return false;
		var point:Vector2D = value as Vector2D;
		return this.isContainPoint(point);
	}

	
    /**
	 * TODO
     * 判断一个点是否在指定的线段上
     * @param	point
     * @return
     */
    public function isContainPoint(point:Vector2D):Boolean
	{
		if(this.isHorizontal())
		{
			var hn:Number = Math.min(this.startPoint.x, this.endPoint.x);
			var hx:Number = Math.max(this.startPoint.x, this.endPoint.x);
			return (point.x <= hx && point.x >= hn) && (point.y == this.startPoint.y);
		}
		else if(this.isVertical())
		{
			var vn:Number = Math.min(this.startPoint.y, this.endPoint.y);
			var	vx:Number = Math.max(this.startPoint.y, this.endPoint.y);
			return (point.y <= vx && point.y >= vn) && (point.x == this.startPoint.x);
		}
		
		//method 1:
		if(!this.isInLineTrack(point)) return false;
		
		var dx:Number = this.endPoint.x - this.startPoint.x;
		var dy:Number = this.endPoint.y - this.startPoint.y;
		var tempDx:Number = point.x - this.startPoint.x;
		var tempDy:Number = point.y - this.startPoint.y;
		
		//考虑二进制舍入误差
		return (dx * tempDy - dy * tempDx) < .0000001;
	}
}
}