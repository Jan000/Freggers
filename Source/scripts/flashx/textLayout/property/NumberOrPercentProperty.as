package flashx.textLayout.property
{
   import flashx.textLayout.formats.FormatValue;
   import flashx.textLayout.tlf_internal;
   
   use namespace tlf_internal;
   
   public class NumberOrPercentProperty extends Property
   {
       
      
      private var _minNumberValue:Number;
      
      private var _maxNumberValue:Number;
      
      private var _minPercentValue:Number;
      
      private var _maxPercentValue:Number;
      
      public function NumberOrPercentProperty(param1:String, param2:Object, param3:Boolean, param4:String, param5:Number, param6:Number, param7:String, param8:String)
      {
         super(param1,param2,param3,param4);
         this._minNumberValue = param5;
         this._maxNumberValue = param6;
         this._minPercentValue = toNumberIfPercent(param7);
         this._maxPercentValue = toNumberIfPercent(param8);
      }
      
      private static function toNumberIfPercent(param1:Object) : Number
      {
         if(!(param1 is String))
         {
            return NaN;
         }
         var _loc2_:String = String(param1);
         var _loc3_:int = _loc2_.length;
         return _loc3_ != 0 && _loc2_.charAt(_loc3_ - 1) == "%"?Number(parseFloat(_loc2_)):Number(NaN);
      }
      
      public function get minNumberValue() : Number
      {
         return this._minNumberValue;
      }
      
      public function get maxNumberValue() : Number
      {
         return this._maxNumberValue;
      }
      
      public function get minPercentValue() : Number
      {
         return this._minPercentValue;
      }
      
      public function get maxPercentValue() : Number
      {
         return this._maxPercentValue;
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
         var _loc3_:Number = toNumberIfPercent(param2);
         if(!isNaN(_loc3_))
         {
            if(checkLowerLimit() && _loc3_ < this._minPercentValue)
            {
               Property.errorHandler(this,param2);
               return param1;
            }
            if(checkUpperLimit() && _loc3_ > this._maxPercentValue)
            {
               Property.errorHandler(this,param2);
               return param1;
            }
            return _loc3_.toString() + "%";
         }
         _loc3_ = parseFloat(param2);
         if(isNaN(_loc3_))
         {
            Property.errorHandler(this,param2);
            return param1;
         }
         if(checkLowerLimit() && _loc3_ < this._minNumberValue)
         {
            Property.errorHandler(this,param2);
            return param1;
         }
         if(checkUpperLimit() && _loc3_ > this._maxNumberValue)
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
         if(param1 is String)
         {
            return StringProperty.doHash(String(param1),param2);
         }
         return NumberProperty.doHash(param1 as Number,param2);
      }
      
      public function computeActualPropertyValue(param1:Object, param2:Number) : Number
      {
         var _loc3_:Number = toNumberIfPercent(param1);
         if(isNaN(_loc3_))
         {
            return Number(param1);
         }
         var _loc4_:Number = param2 * (_loc3_ / 100);
         if(_loc4_ < this._minNumberValue)
         {
            return this._minNumberValue;
         }
         if(_loc4_ > this._maxNumberValue)
         {
            return this._maxNumberValue;
         }
         return _loc4_;
      }
   }
}
