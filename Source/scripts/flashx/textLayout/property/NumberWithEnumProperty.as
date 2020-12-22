package flashx.textLayout.property
{
   import flashx.textLayout.tlf_internal;
   
   use namespace tlf_internal;
   
   public class NumberWithEnumProperty extends NumberProperty
   {
       
      
      private var _range:Object;
      
      private var _defaultValue:Object;
      
      public function NumberWithEnumProperty(param1:String, param2:Object, param3:Boolean, param4:String, param5:Number, param6:Number, ... rest)
      {
         this._range = EnumStringProperty.createRange(rest);
         var _loc8_:Boolean = param2 is String && this._range.hasOwnProperty(param2);
         var _loc9_:Number = !!_loc8_?Number(0):Number(Number(param2));
         super(param1,_loc9_,param3,param4,param5,param6);
         this._defaultValue = param2;
      }
      
      override public function get defaultValue() : Object
      {
         return this._defaultValue;
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
         return !!this._range.hasOwnProperty(param2)?param2:super.setHelper(param1,param2);
      }
      
      override public function hash(param1:Object, param2:uint) : uint
      {
         var _loc3_:uint = this._range[param1];
         if(_loc3_ != 0)
         {
            return UintProperty.doHash(_loc3_,param2);
         }
         return super.hash(param1,param2);
      }
   }
}
