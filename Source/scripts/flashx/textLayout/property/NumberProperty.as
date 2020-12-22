package flashx.textLayout.property
{
   import flashx.textLayout.formats.FormatValue;
   import flashx.textLayout.tlf_internal;
   
   use namespace tlf_internal;
   
   public class NumberProperty extends Property
   {
       
      
      private var _minValue:Number;
      
      private var _maxValue:Number;
      
      public function NumberProperty(param1:String, param2:Number, param3:Boolean, param4:String, param5:Number, param6:Number)
      {
         super(param1,param2,param3,param4);
         this._minValue = param5;
         this._maxValue = param6;
      }
      
      tlf_internal static function doHash(param1:Number, param2:uint) : uint
      {
         var _loc5_:uint = 0;
         var _loc3_:uint = uint(param1);
         var _loc4_:uint = UintProperty.doHash(_loc3_,param2);
         if(_loc3_ != param1)
         {
            _loc5_ = uint((param1 - _loc3_) * 10000000000);
            _loc4_ = UintProperty.doHash(_loc5_,_loc4_);
         }
         return _loc4_;
      }
      
      public function get minValue() : Number
      {
         return this._minValue;
      }
      
      public function get maxValue() : Number
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
         var _loc3_:Number = param2 is String?Number(parseFloat(param2)):Number(Number(param2));
         if(isNaN(_loc3_))
         {
            Property.errorHandler(this,param2);
            return param1;
         }
         if(checkLowerLimit() && _loc3_ < this._minValue)
         {
            Property.errorHandler(this,param2);
            return param1;
         }
         if(checkUpperLimit() && _loc3_ > this._maxValue)
         {
            Property.errorHandler(this,param2);
            return param1;
         }
         return _loc3_;
      }
      
      override public function hash(param1:Object, param2:uint) : uint
      {
         if(param1 == FormatValue.INHERIT)
         {
            return UintProperty.doHash(inheritHashValue,param2);
         }
         return NumberProperty.doHash(param1 as Number,param2);
      }
   }
}
