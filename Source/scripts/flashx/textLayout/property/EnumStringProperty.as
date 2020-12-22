package flashx.textLayout.property
{
   import flashx.textLayout.formats.FormatValue;
   import flashx.textLayout.tlf_internal;
   
   use namespace tlf_internal;
   
   public class EnumStringProperty extends Property
   {
      
      tlf_internal static var nextEnumHashValue:uint = 217287;
       
      
      private var _range:Object;
      
      public function EnumStringProperty(param1:String, param2:String, param3:Boolean, param4:String, ... rest)
      {
         super(param1,param2,param3,param4);
         this._range = createRange(rest);
      }
      
      tlf_internal static function createRange(param1:Array) : Object
      {
         var _loc2_:Object = new Object();
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc2_[param1[_loc3_]] = nextEnumHashValue++;
            _loc3_++;
         }
         _loc2_[FormatValue.INHERIT] = nextEnumHashValue++;
         return _loc2_;
      }
      
      public function get range() : Object
      {
         return Property.shallowCopy(this._range);
      }
      
      override public function setHelper(param1:*, param2:*) : *
      {
         if(param2 === null)
         {
            param2 = undefined;
         }
         if(param2 === undefined)
         {
            return param2;
         }
         if(this._range.hasOwnProperty(param2))
         {
            return param2;
         }
         Property.errorHandler(this,param2);
         return param1;
      }
      
      override public function hash(param1:Object, param2:uint) : uint
      {
         return UintProperty.doHash(this._range[param1],param2);
      }
   }
}
