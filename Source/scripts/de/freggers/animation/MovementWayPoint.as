package de.freggers.animation
{
   public class MovementWayPoint
   {
       
      
      public var isoU:Number = 0;
      
      public var isoV:Number = 0;
      
      public var isoZ:Number = 0;
      
      public var millis:int = 0;
      
      public function MovementWayPoint(param1:Number, param2:Number, param3:Number, param4:int)
      {
         super();
         this.isoU = param1;
         this.isoV = param2;
         this.isoZ = param3;
         this.millis = param4;
      }
      
      public function toString() : String
      {
         return "MWP[isoU=" + this.isoU + ",isoV=" + this.isoV + ",isoZ=" + this.isoZ + ",millis=" + this.millis + "]";
      }
   }
}
