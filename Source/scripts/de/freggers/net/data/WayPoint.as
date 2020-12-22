package de.freggers.net.data
{
   public class WayPoint
   {
       
      
      private var _position:Position;
      
      private var _duration:int;
      
      public function WayPoint(param1:Position, param2:int)
      {
         super();
         this._position = param1;
         this._duration = param2;
      }
      
      public function get position() : Position
      {
         return this._position;
      }
      
      public function get duration() : int
      {
         return this._duration;
      }
   }
}
