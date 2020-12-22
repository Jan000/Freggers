package de.freggers.animation
{
   import de.freggers.data.Level;
   import de.freggers.isostar.IsoStar;
   import flash.geom.Vector3D;
   
   public class LinearPathSegment extends PathSegment
   {
       
      
      private var _delta:Vector3D;
      
      public function LinearPathSegment(param1:Array, param2:int, param3:Level = null)
      {
         super(param1,param2,param3);
         this._delta = (param1[1] as Vector3D).subtract(param1[0]);
         direction = IsoStar.computeDirection(this._delta);
      }
      
      override public function compute(param1:int) : void
      {
         var _loc2_:Number = param1 / duration * this._delta.x;
         var _loc3_:Number = param1 / duration * this._delta.y;
         var _loc4_:Number = param1 / duration * this._delta.z;
         var _loc5_:Vector3D = points[0] as Vector3D;
         position.x = _loc5_.x + _loc2_;
         position.y = _loc5_.y + _loc3_;
         position.z = _loc5_.z + _loc4_;
         if(level)
         {
            position.z = level.getHeightAt(position.x,position.y);
         }
      }
      
      override public function toString() : String
      {
         return "AMLinearPathSegment[points=(" + points + "),ground=" + (level != null) + "]";
      }
   }
}
