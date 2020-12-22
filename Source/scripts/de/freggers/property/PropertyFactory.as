package de.freggers.property
{
   public class PropertyFactory
   {
      
      private static var _configs:Object;
       
      
      public function PropertyFactory()
      {
         super();
      }
      
      public static function configure(param1:Object) : void
      {
         var _loc2_:* = null;
         _configs = new Object();
         for(_loc2_ in param1)
         {
            _configs[_loc2_] = PropertyConfig.fromData(_loc2_,param1[_loc2_]);
         }
      }
      
      public static function createProperty(param1:String, param2:String) : Property
      {
         var _loc4_:Property = null;
         if(_configs == null || _configs[param1] == null)
         {
            return null;
         }
         var _loc3_:PropertyConfig = _configs[param1];
         if(_loc3_ != null)
         {
            if(Property.isValidType(_loc3_.type))
            {
               _loc4_ = new Property(_loc3_,param2);
            }
         }
         return _loc4_;
      }
      
      public static function createPropertyList(param1:Object) : Array
      {
         var _loc3_:* = null;
         var _loc4_:Property = null;
         var _loc2_:Array = new Array();
         for(_loc3_ in param1)
         {
            _loc4_ = PropertyFactory.createProperty(_loc3_,param1[_loc3_]);
            if(_loc4_ != null)
            {
               _loc2_.push(_loc4_);
            }
         }
         return _loc2_;
      }
   }
}
