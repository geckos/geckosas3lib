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
     * 头元素
     */
    public function get head():*
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
    public function add(e:*):void
    {
        _source.push(e);
        var currentPosition:uint = length;
        var parentPosition:uint = length / 2;
        
        while (parentPosition > 0 
               && compareFunction(e, _source[parentPosition-1]) == -1)
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
    private function removeAt(index:uint):*
    {
        if (index == length-1)
        {
            return _source.pop();
        }
        
        var item:* = _source[index];
        var lastItem:* = _source.pop();
        _source[index] = lastItem;
        
        var currentPosition:uint = index + 1;
        
        var childPosition:uint = currentPosition * 2;
        
        var len:uint = length;
        while (childPosition <= len)
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
    
    /**
     * 删除一个元素
     * @param e
     * @return 
     * 
     */
    public function remove(e:*):Boolean
    {
        var index:int = _source.indexOf(e);
        if (index == -1)
        {
            return false;
        }
        else
        {
            removeAt(index);
            return true;
        }
    }
    
    /**
     * 删除头元素并返回
     * @return 
     */    
    public function poll():*
    {
        return removeAt(0);
    }
    
    /**
     * 清空集合
     */
    public function clear():void
    {
        _source = [];
    }
    
    /**
     * 判断指定元素是否在集合中
     * @param e
     * @return
     * 
     */
    public function contains(e:*):Boolean
    {
        return _source.indexOf(e) != -1;
    }
}
}