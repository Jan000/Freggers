package flashx.textLayout.property
{
   import flashx.textLayout.tlf_internal;
   
   use namespace tlf_internal;
   
   public class StringProperty extends Property
   {
       
      
      public function StringProperty(param1:String, param2:String, param3:Boolean, param4:String)
      {
         super(param1,param2,param3,param4);
      }
      
      tlf_internal static function doHash(param1:String, param2:uint) : uint
      {
         if(param1 == null)
         {
            return param2;
         }
         var _loc3_:uint = param1.length;
         var _loc4_:uint = param2;
         var _loc5_:uint = 0;
         while(_loc5_ < _loc3_ / 2)
         {
            _loc4_ = UintProperty.doHash(param1.charCodeAt(2 * _loc5_) << 16 | param1.charCodeAt(2 * _loc5_ + 1),_loc4_);
            _loc5_++;
         }
         if(_loc3_ % 2 != 0)
         {
            _loc4_ = UintProperty.doHash(param1.charCodeAt(_loc3_ - 1),_loc4_);
         }
         return _loc4_;
      }
      
      override public function setHelper(param1:*, param2:*) : *
      {
         if(param2 === null)
         {
            param2 = undefined;
         }
         if(param2 === undefined || param2 is String)
         {
            return param2;
         }
         Property.errorHandler(this,param2);
         return param1;
      }
      
      override public function hash(param1:Object, param2:uint) : uint
      {
         return doHash(param1 as String,param2);
      }
   }
}
