package flashx.textLayout.property
{
   import flashx.textLayout.formats.FormatValue;
   import flashx.textLayout.tlf_internal;
   
   use namespace tlf_internal;
   
   public class UintProperty extends Property
   {
       
      
      public function UintProperty(param1:String, param2:uint, param3:Boolean, param4:String)
      {
         super(param1,param2,param3,param4);
      }
      
      tlf_internal static function doHash(param1:uint, param2:uint) : uint
      {
         return param2 << 5 ^ param2 >> 27 ^ param1;
      }
      
      override public function setHelper(param1:*, param2:*) : *
      {
         var _loc3_:* = undefined;
         var _loc4_:String = null;
         if(param2 === null)
         {
            param2 = undefined;
         }
         if(param2 === undefined || param2 == FormatValue.INHERIT)
         {
            return param2;
         }
         if(param2 is String)
         {
            _loc4_ = String(param2);
            if(_loc4_.substr(0,1) == "#")
            {
               _loc4_ = "0x" + _loc4_.substr(1,_loc4_.length - 1);
            }
            _loc3_ = _loc4_.toLowerCase().substr(0,2) == "0x"?parseInt(_loc4_):NaN;
         }
         else if(param2 is Number || param2 is int || param2 is uint)
         {
            _loc3_ = Number(param2);
         }
         else
         {
            _loc3_ = NaN;
         }
         if(isNaN(_loc3_))
         {
            Property.errorHandler(this,_loc4_);
            return param1;
         }
         if(_loc3_ is Number)
         {
            if(_loc3_ < 0 || _loc3_ > 4294967295)
            {
               Property.errorHandler(this,param2);
               return param1;
            }
         }
         return _loc3_;
      }
      
      override public function toXMLString(param1:Object) : String
      {
         if(param1 == FormatValue.INHERIT)
         {
            return String(param1);
         }
         var _loc2_:String = param1.toString(16);
         if(_loc2_.length < 6)
         {
            _loc2_ = "000000".substr(0,6 - _loc2_.length) + _loc2_;
         }
         _loc2_ = "#" + _loc2_;
         return _loc2_;
      }
      
      override public function hash(param1:Object, param2:uint) : uint
      {
         if(param1 == FormatValue.INHERIT)
         {
            return UintProperty.doHash(inheritHashValue,param2);
         }
         return doHash(param1 as uint,param2);
      }
   }
}
