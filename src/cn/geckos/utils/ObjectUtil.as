package cn.geckos.utils
{
public class ObjectUtil
{
    public static function isEmpty(obj:Object)
    {
        if (obj == null) {
            return true;
        }
        
        if (obj is Array || obj is Vector) {
            return obj.length == 0;
        }
        
        if (obj is String) {
            return obj == '';
        }
        
        for (var key:* in obj) {
            return false;
        }
        
        return true;        
    }
}
}