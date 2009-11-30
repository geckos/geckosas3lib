package cn.geckos.utils
{


/**
 * 普通二叉堆实现
 * 参考： http://www.policyalmanac.org/games/binaryHeaps.htm
 * 
 * TODO 提取接口
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
        var item:* = _source[index];
        var lastItem:* = _source.pop();
        _source[index] = lastItem;
        
        var currentPosition:uint = index + 1;
        
        var childPosition:uint = currentPosition * 2;
        
        var len:uint = length;
        while (childPosition <= len)
        {
            if (compareFunction(lastItem, _source[childPosition-1]) == 1)
            {
                // 注意后面两个参数 ，是数组的index，所以要减1
                ArrayUtil.swap(_source, currentPosition-1, childPosition-1);
                currentPosition = childPosition;
                childPosition = currentPosition * 2;
                continue;
            }
            else if((childPosition + 1) <= len 
                    && compareFunction(lastItem, _source[childPosition]) == 1)
            {
                // 注意后面两个参数 ，是数组的index，所以不减1
                ArrayUtil.swap(_source, currentPosition, childPosition);
                currentPosition = childPosition + 1;
                childPosition = currentPosition * 2;
                continue;
            }
            
            // 
            break;
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