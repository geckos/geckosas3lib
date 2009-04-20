package cn.geckos.api
{
/**
 * 此接口为对象定义为可复制对象
 */
public interface ICloneable
{
    /**
     * 复制当前对象
     * @return 返回一个与前对象的拷贝
     */ 
    function clone():Object;
}
}