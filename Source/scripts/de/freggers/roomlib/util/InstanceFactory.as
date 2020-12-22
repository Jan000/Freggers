package de.freggers.roomlib.util
{
   import flash.system.ApplicationDomain;
   
   public class InstanceFactory
   {
       
      
      public function InstanceFactory(param1:Class)
      {
         super();
      }
      
      public static function createInstanceOf(param1:String, param2:Class) : Object
      {
         var _loc5_:Class = null;
         var _loc3_:Object = null;
         var _loc4_:ApplicationDomain = ApplicationDomain.currentDomain;
         if(_loc4_.hasDefinition(param1))
         {
            _loc5_ = _loc4_.getDefinition(param1) as Class;
            if(param2.prototype.isPrototypeOf(_loc5_.prototype))
            {
               _loc3_ = new _loc5_();
            }
         }
         return _loc3_;
      }
   }
}
