package cn.geckos.utils
{


/**
 * 普通二叉堆实现
 * 参考： http://www.policyalmanac.org/games/binaryHeaps.htm
 * 
 * TODO 提取接口
 * TODO 性能测试
 */
public class BinaryHeap
{
    private var _source:Array = [];
    
    private var _compareFunction:Function;
    public function get compareFunction():Function
    {
        if (_compareFunction == null)
        {
            _compareFunction = function(a:*, b:*):int {
                if (a < b) return -1;
                else if (a > b) return 1;
                else return 0;
            }
        }
        return _compareFunction;
    }

    public function set compareFunction(value:Function):void
    {
        _compareFunction = value;
    }
    
    /**
     * @return 元素数量
     * 
     */
    public function get length():uint
    {
        return _source.length;
    }
    
    /**
     * 
     */
    public function get front():*
    {
        if (length > 0)
        {
            return _source[0];
        }
        else
        {
            return null;
        }
    }

    
    /**
     * Constructor
     */
    public function BinaryHeap()
    {
    }
    
    /**
     * 插入元素
     * @param value
     * 
     */
    public function insert(value:*):void
    {
        _source.push(value);
        var currentPosition:uint = length;
        var parentPosition:uint = length / 2;
        
        while (parentPosition > 0 
               && compareFunction(value, _source[parentPosition-1]) == -1)
        {
            ArrayUtil.swap(_source, currentPosition-1, parentPosition-1);
            currentPosition = parentPosition;
            parentPosition = currentPosition / 2;
        }
    }
    
    /**
     * 
     * @param index
     * @return 
     * 
     */
    public function removeAt(index:uint):*
    {
        var lastItem:* = _source.pop();
        if (length == 0)
        {
            return lastItem;
        }
        
        var item:* = _source[index];
        _source[index] = lastItem;
        
        var currentPosition:uint = index + 1;
        
        var childPosition:uint = currentPosition * 2;
        
        while (childPosition <= length)
        {
            // 注意是数组的index，所以要减1
            var left:* = _source[childPosition - 1];
            // 注意是数组的index，所以不减1
            var right:* = _source[childPosition];
            
            var child:*;
            if (!right || compareFunction(left, right) == -1)
            {
                child = left;
            }
            else
            {
                child = right;
            }
            
            if (compareFunction(lastItem, child) == 1)
            {
                if (child == right)
                {
                    childPosition += 1;
                }
                
                // 注意后面两个参数是数组的index，所以要减1
                ArrayUtil.swap(_source, currentPosition-1, childPosition-1);
                
                // 新的位置，用于下一轮比较
                currentPosition = childPosition;
                childPosition = currentPosition * 2;
            }
            else
            {
                break;
            }
            
        }
        
        return item;
    }
    
    public function shift():*
    {
        return removeAt(0);
    }
    
    public function pop():*
    {
        return removeAt(length - 1);
    }
    
    public function clear():void
    {
        _source = [];
    }
}
}