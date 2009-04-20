package cn.geckos.geom
{
import cn.geckos.api.ICloneable;
import cn.geckos.utils.MathUtil;
    
/**
 * 2D 向量，
 * 取自 Keith Peters 的 《AdvanceED ActionScript Animation》一书第二章的Vector2D类，略有修改
 */
public class Vector2D implements ICloneable
{
    
    //
    //  坐标
    //
    
    private var _x:Number;
    /**
     * x 值
     */ 
    public function get x():Number
    {
        return _x;
    }
    
    /**
     * @private
     */ 
    public function set x(value:Number):void
    {
        _x = value;
    }
    
    private var _y:Number;
    /**
     * y 值
     */ 
    public function get y():Number
    {
        return _y;
    }
    
    /**
     * @private
     */ 
    public function set y(value:Number):void
    {
        _y = value;
    }
    
    //
    //  长度
    //
    
    /**
     * 向量长度，如果改变向量长度，x y 值也会随着改变，但是不会影响角度。
     */ 
    public function get length():Number
    {
        return Math.sqrt(x*x + y*y);
    }
    
    public function set length(value:Number):void
    {
        var a:Number = getAngle(false);
        _x = Math.cos(a) * value;
        _y = Math.sin(a) * value;
    }
    
    //
    //  法向量
    //
    
    /**
     * 得到与当前向量成90度夹角的向量，即法向量。
     * 
     * @return 当前向量的法向量。
     */ 
    public function get perp():Vector2D
    {
        return new Vector2D(-y, x);
    }
    
    //
    //
    //
    
    /**
     * 构造器
     */ 
    public function Vector2D(x:Number=0, y:Number=0)
    {
        _x = x;
        _y = y;
    }
    
    /**
     * 返回此向量的副本。
     */ 
    public function clone():Object
    {
        return new Vector2D(x, y);
    }
    
    /**
     * 获取当前向量与另一个向量之间的距离
     * 
     * @param v 另一个向量对象
     * @reutrn 当前向量与v2之间的距离
     */ 
    public function dist(v:Vector2D):Number
    {
        var dx:Number = v.x - x;
        var dy:Number = v.y - y;
        
        return Math.sqrt(dx*dx + dy*dy);
    }
    
    /**
     * 检测当前向量与另一个向量的值是否相等。
     * 
     * @param v 另一个向量对象
     * @return 若当前向量的 x与v.x相等并且y与v.y相等则返回true，否则返回false。
     */ 
    public function equals(v:Vector2D):Boolean
    {
        return _x == v.x && _y == v.y;
    }
    
    //
    //  角度/弧度
    //
    
    /**
     * 获取向量的角度或弧度
     * 
     * @param degrees 指定是否返回角度值，默认为true
     * 
     * @return 如果degrees为true，则返回向量的角度值，否则返回向量的弧度值
     */ 
    public function getAngle(degrees:Boolean=true):Number
    {
        var radians:Number = Math.atan2(y, x);
        if (degrees)
        {
            return MathUtil.rds2dgs(radians);
        }
        
        return radians;
    }
    
    /**
     * 设置向量的角度或弧度
     * 
     * @param degressOrRadians 弧度或角度值
     * @param degrees 指示 degressOrRadians 参数是否为角度，若为true， degressOrRadians
     *                则被认视为角度值，否则被视为弧度值，默认为true。
     */ 
    public function setAngle(degressOrRadians:Number, degress:Boolean=true):void
    {
        if (degress)
        {
            degressOrRadians = MathUtil.dgs2rds(degressOrRadians);
        }
        
        var len:Number = length;
        _x = Math.cos(degressOrRadians) * len;
        _y = Math.sin(degressOrRadians) * len;
    }
    
    /**
     * 向量加法，将另一个向量对象与当前向量相加。
     * 
     * @param v 另一个向量对象
     */ 
    public function add(v:Vector2D):void
    {
        _x += v.x;
        _y += v.y;
    }
    
    /**
     * 点积，返回当前向量对象与另一向量的点积。
     * 
     * @param v 另一向量对象
     * 
     * @return 当前向量与向量v的点积值
     */
    public function dot(v:Vector2D):Number
    {
        return x*v.x + y*v.y;
    }
    
    /**
     * 描述向量实例的字符窜
     */
    public function toString():String
    {
        return "[Vector2D (x:" + _x + ", " + _y + ":_y)]";
    }

}
}