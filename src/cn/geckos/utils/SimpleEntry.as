package cn.geckos.utils
{
public class SimpleEntry implements IEntry
{
    private var _key:*;
    
    public function get key():*
    {
        return _key;
    }
    
    public function set key(v:*):void
    {
        _key = v;
    }
    
    private var _value:*;
    
    public function get value():*
    {
        return _value;
    }
    
    public function set value(v:*):void
    {
        _value = value;
    }

    public function SimpleEntry(key:*, value:*)
    {
        _key = key;
        _value = value;
    }
}
}
