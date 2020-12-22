package de.freggers.animation
{
   import de.freggers.data.Level;
   import flash.geom.Vector3D;
   
   public class Point2PointMovement extends Movement
   {
       
      
      public function Point2PointMovement(param1:ITarget, param2:Array, param3:int, param4:Level, param5:*)
      {
         super(param1,param3,param5,null);
         this.init(param2,param4);
      }
      
      private function init(param1:Array, param2:Level) : void
      {
         var _loc6_:MovementWayPoint = null;
         var _loc7_:Vector3D = null;
         var _loc8_:Vector3D = null;
         var _loc9_:int = 0;
         var _loc3_:Array = new Array();
         var _loc4_:uint = 0;
         while(_loc4_ < param1.length)
         {
            if((param1[_loc4_] as MovementWayPoint).millis == 0)
            {
               param1.splice(_loc4_,1);
            }
            _loc4_++;
         }
         var _loc5_:uint = param1.length;
         if(!param1 || param1.length == 0)
         {
            cleanup();
            return;
         }
         _loc7_ = target.uvz.clone();
         _loc8_ = new Vector3D(param1[0].isoU,param1[0].isoV,param1[0].isoZ);
         _loc3_.push(new LinearPathSegment([_loc7_,_loc8_],param1[0].millis,param2));
         _loc4_ = 0;
         while(_loc4_ < _loc5_ - 1)
         {
            _loc6_ = param1[_loc4_] as MovementWayPoint;
            if(_loc6_)
            {
               _loc7_ = new Vector3D(_loc6_.isoU,_loc6_.isoV,_loc6_.isoZ);
               _loc6_ = param1[_loc4_ + 1];
               if(_loc6_)
               {
                  _loc8_ = new Vector3D(_loc6_.isoU,_loc6_.isoV,_loc6_.isoZ);
                  _loc9_ = _loc6_.millis;
                  if(!(!_loc7_ || !_loc8_))
                  {
                     _loc3_.push(new LinearPathSegment([_loc7_,_loc8_],_loc9_,param2));
                  }
               }
            }
            _loc4_++;
         }
         super.segments = _loc3_;
      }
   }
}
