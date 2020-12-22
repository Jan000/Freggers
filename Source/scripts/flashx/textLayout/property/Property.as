package flashx.textLayout.property
{
   import flashx.textLayout.elements.GlobalSettings;
   import flashx.textLayout.formats.FormatValue;
   import flashx.textLayout.tlf_internal;
   
   use namespace tlf_internal;
   
   public class Property
   {
      
      public static var errorHandler:Function = defaultErrorHandler;
      
      public static const NO_LIMITS:String = "noLimits";
      
      public static const LOWER_LIMIT:String = "lowerLimit";
      
      public static const UPPER_LIMIT:String = "upperLimit";
      
      public static const ALL_LIMITS:String = "allLimits";
      
      tlf_internal static const inheritHashValue:uint = 314159;
      
      private static const nullStyleObject:Object = new Object();
       
      
      private var _name:String;
      
      private var _default:Object;
      
      private var _inherited:Boolean;
      
      private var _limits:String;
      
      private var _category:String;
      
      public function Property(param1:String, param2:Object, param3:Boolean, param4:String)
      {
         super();
         this._name = param1;
         this._default = param2;
         this._limits = ALL_LIMITS;
         this._inherited = param3;
         this._category = param4;
      }
      
      public static function defaultErrorHandler(param1:Property, param2:Object) : void
      {
         throw new RangeError(createErrorString(param1,param2));
      }
      
      public static function createErrorString(param1:Property, param2:Object) : String
      {
         return GlobalSettings.resourceStringFunction("badPropertyValue",[param1.name,param2.toString()]);
      }
      
      public static function defaultsAllHelper(param1:Object, param2:Object) : void
      {
         var _loc3_:Property = null;
         for each(_loc3_ in param1)
         {
            param2[_loc3_.name] = _loc3_.defaultValue;
         }
      }
      
      public static function equalAllHelper(param1:Object, param2:Object, param3:Object) : Boolean
      {
         var _loc4_:Property = null;
         var _loc5_:String = null;
         if(param2 == param3)
         {
            return true;
         }
         if(param2 == null || param3 == null)
         {
            return false;
         }
         for each(_loc4_ in param1)
         {
            _loc5_ = _loc4_.name;
            if(!_loc4_.equalHelper(param2[_loc5_],param3[_loc5_]))
            {
               return false;
            }
         }
         return true;
      }
      
      public static function extractInCategory(param1:Class, param2:Object, param3:Object, param4:String) : Object
      {
         var _loc6_:Property = null;
         var _loc5_:Object = null;
         for each(_loc6_ in param2)
         {
            if(_loc6_.category == param4 && param3[_loc6_.name] != null)
            {
               if(_loc5_ == null)
               {
                  _loc5_ = new param1();
               }
               _loc5_[_loc6_.name] = param3[_loc6_.name];
            }
         }
         return _loc5_;
      }
      
      public static function shallowCopy(param1:Object) : Object
      {
         var _loc3_:* = null;
         var _loc2_:Object = new Object();
         for(_loc3_ in param1)
         {
            _loc2_[_loc3_] = param1[_loc3_];
         }
         return _loc2_;
      }
      
      public static function equalStyleObjects(param1:Object, param2:Object) : Boolean
      {
         var _loc4_:* = null;
         var _loc5_:int = 0;
         if(param1 == null)
         {
            param1 = nullStyleObject;
         }
         if(param2 == null)
         {
            param2 = nullStyleObject;
         }
         var _loc3_:int = 0;
         for(_loc4_ in param1)
         {
            if(param1[_loc4_] != param2[_loc4_])
            {
               return false;
            }
            _loc3_++;
         }
         _loc5_ = 0;
         for(_loc4_ in param2)
         {
            _loc5_++;
         }
         return _loc3_ == _loc5_;
      }
      
      public static function equalCoreStyles(param1:Object, param2:Object, param3:Object) : Boolean
      {
         var _loc5_:* = null;
         var _loc6_:int = 0;
         var _loc7_:Object = null;
         var _loc8_:Object = null;
         var _loc9_:Class = null;
         if(param1 == null)
         {
            param1 = nullStyleObject;
         }
         if(param2 == null)
         {
            param2 = nullStyleObject;
         }
         var _loc4_:int = 0;
         for(_loc5_ in param1)
         {
            _loc7_ = param1[_loc5_];
            _loc8_ = param2[_loc5_];
            if(_loc7_ != _loc8_)
            {
               if(!(_loc7_ is Array) || !(_loc8_ is Array) || _loc7_.length != _loc8_.length)
               {
                  return false;
               }
               _loc9_ = param3[_loc5_].memberType;
               if(!Property.equalAllHelper(_loc9_.tlf_internal::description,_loc7_,_loc8_))
               {
                  return false;
               }
            }
            _loc4_++;
         }
         _loc6_ = 0;
         for(_loc5_ in param2)
         {
            _loc6_++;
         }
         return _loc4_ == _loc6_;
      }
      
      protected function checkLowerLimit() : Boolean
      {
         return this._limits == ALL_LIMITS || this._limits == LOWER_LIMIT;
      }
      
      protected function checkUpperLimit() : Boolean
      {
         return this._limits == ALL_LIMITS || this._limits == LOWER_LIMIT;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function get defaultValue() : Object
      {
         return this._default;
      }
      
      public function get inherited() : Object
      {
         return this._inherited;
      }
      
      public function get category() : String
      {
         return this._category;
      }
      
      public function setHelper(param1:*, param2:*) : *
      {
         if(param2 === null)
         {
            param2 = undefined;
         }
         return param2;
      }
      
      public function concatInheritOnlyHelper(param1:*, param2:*) : *
      {
         return this._inherited && param1 === undefined || param1 == FormatValue.INHERIT?param2:param1;
      }
      
      public function concatHelper(param1:*, param2:*) : *
      {
         if(this._inherited)
         {
            return param1 === undefined || param1 == FormatValue.INHERIT?param2:param1;
         }
         if(param1 === undefined)
         {
            return this.defaultValue;
         }
         return param1 == FormatValue.INHERIT?param2:param1;
      }
      
      public function equalHelper(param1:*, param2:*) : Boolean
      {
         return param1 == param2;
      }
      
      public function toXMLString(param1:Object) : String
      {
         return param1.toString();
      }
      
      public function hash(param1:Object, param2:uint) : uint
      {
         return 0;
      }
   }
}
