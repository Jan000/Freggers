package de.freggers.animation
{
   import de.freggers.data.Level;
   import flash.geom.Vector3D;
   
   public class HorizontalThrow extends Movement
   {
       
      
      public function HorizontalThrow(param1:ITarget, param2:Array, param3:int, param4:Level, param5:*, param6:Function)
      {
         var _loc10_:MovementWayPoint = null;
         super(param1,param3,param5,param6);
         if(param2.length != 3)
         {
            return;
         }
         var _loc7_:Array = new Array();
         param3 = 0;
         var _loc8_:int = 0;
         while(_loc8_ <= 2)
         {
            _loc10_ = param2[_loc8_];
            _loc7_[_loc8_] = new Vector3D(_loc10_.isoU,_loc10_.isoV,_loc10_.isoZ);
            param3 = param3 + _loc10_.millis;
            _loc8_++;
         }
         var _loc9_:Array = new Array();
         _loc9_.push(new HorizontalThrowPathSegment(_loc7_,param3));
         super.segments = _loc9_;
      }
   }
}
