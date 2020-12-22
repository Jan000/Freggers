package de.freggers.animation
{
   import de.freggers.isostar.IsoStar;
   import flash.geom.Vector3D;
   
   public class HorizontalThrowPathSegment extends PathSegment
   {
       
      
      private var _delta:Vector3D;
      
      private var _start:Vector3D;
      
      private var _ctrl:Vector3D;
      
      private var _end:Vector3D;
      
      private var _overalldistancesquared:Number;
      
      private var _overalldistance:Number;
      
      private var _throwheight:Number;
      
      private var _throwheightTimes4:Number;
      
      public function HorizontalThrowPathSegment(param1:Array, param2:int)
      {
         super(param1,param2);
         this._start = param1[0] as Vector3D;
         this._ctrl = param1[1] as Vector3D;
         this._end = param1[2] as Vector3D;
         this._delta = this._end.subtract(this._start);
         this._overalldistancesquared = this._delta.x * this._delta.x + this._delta.y * this._delta.y;
         this._overalldistance = Math.sqrt(this._overalldistancesquared);
         this._throwheight = this._ctrl.z - this._start.z;
         this._throwheightTimes4 = this._throwheight * 4;
      }
      
      override public function compute(param1:int) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc2_:Number = param1 / duration;
         if(this._overalldistancesquared == 0)
         {
            _loc3_ = this._start.x;
            _loc4_ = this._start.y;
            _loc5_ = this._start.z + this._throwheightTimes4 * (-_loc2_ * _loc2_ + _loc2_);
         }
         else
         {
            _loc3_ = this._delta.x * _loc2_;
            _loc4_ = this._delta.y * _loc2_;
            _loc7_ = Math.sqrt(_loc3_ * _loc3_ + _loc4_ * _loc4_);
            _loc3_ = _loc3_ + this._start.x;
            _loc4_ = _loc4_ + this._start.y;
            _loc5_ = this._start.z + 4 * this._throwheight * (-(_loc7_ * _loc7_ / this._overalldistancesquared) + _loc7_ / this._overalldistance) + _loc7_ * this._delta.z / this._overalldistance;
         }
         var _loc6_:Vector3D = position.clone();
         position.x = _loc3_;
         position.y = _loc4_;
         position.z = _loc5_;
         direction = IsoStar.computeDirection(position.subtract(_loc6_));
      }
      
      override public function toString() : String
      {
         return "HorizontalThrowPathSegment[points=(" + points + ")]";
      }
   }
}
