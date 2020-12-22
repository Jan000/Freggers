package flashx.textLayout.property
{
   import flashx.textLayout.formats.FormatValue;
   import flashx.textLayout.tlf_internal;
   
   use namespace tlf_internal;
   
   public class IntProperty extends Property
   {
       
      
      private var _minValue:int;
      
      private var _maxValue:int;
      
      public function IntProperty(param1:String, param2:int, param3:Boolean, param4:String, param5:int, param6:int)
      {
         super(param1,param2,param3,param4);
         this._minValue = param5;
         this._maxValue = param6;
      }
      
      public function get minValue() : int
      {
         return this._minValue;
      }
      
      public function get maxValue() : int
      {
         return this._maxValue;
      }
      
      override public function setHelper(param1:*, param2:*) : *
      {
         if(param2 === null)
         {
            param2 = undefined;
         }
         if(param2 === undefined || param2 == FormatValue.INHERIT)
         {
            return param2;
         }
         var _loc3_:Number = parseInt(param2);
         if(isNaN(_loc3_))
         {
            Property.errorHandler(this,param2);
            return param1;
         }
         var _loc4_:int = int(_loc3_);
         if(checkLowerLimit() && _loc4_ < this._minValue)
         {
            Property.errorHandler(this,param2);
            return param1;
         }
         if(checkUpperLimit() && _loc4_ > this._maxValue)
         {
            Property.errorHandler(this,param2);
            return param1;
         }
         return _loc4_;
      }
      
      override public function hash(param1:Object, param2:uint) : uint
      {
         if(param1 == FormatValue.INHERIT)
         {
            return UintProperty.doHash(inheritHashValue,param2);
         }
         return UintProperty.doHash(param1 as uint,param2);
      }
   }
}
