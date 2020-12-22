package de.freggers.net.data
{
   import de.freggers.net.UtfMessage;
   import flash.utils.getTimer;
   
   public class Path
   {
       
      
      private var _start:Position;
      
      private var _duration:int;
      
      private var _wayPoints:Array;
      
      private var _recievedAt:int;
      
      public function Path(param1:Position, param2:int, param3:int)
      {
         super();
         this._start = param1;
         this._duration = param2;
         this._wayPoints = new Array();
         this._recievedAt = param3;
      }
      
      public static function fromUtfMessage(param1:UtfMessage) : Path
      {
         if(!param1)
         {
            return null;
         }
         var _loc2_:Array = param1.get_int_list_arg(0);
         if(!_loc2_ || _loc2_.length < 5)
         {
            return null;
         }
         var _loc3_:int = _loc2_[0];
         var _loc4_:Path = new Path(new Position(_loc2_[1],_loc2_[2],_loc2_[3]),_loc2_[4],getTimer());
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_)
         {
            _loc2_ = param1.get_int_list_arg(_loc5_ + 1);
            _loc4_.addWaypoint(new WayPoint(new Position(_loc2_[0],_loc2_[1],_loc2_[2]),_loc2_[3]));
            _loc5_++;
         }
         return _loc4_;
      }
      
      public function get startPosition() : Position
      {
         return this._start;
      }
      
      public function addWaypoint(param1:WayPoint) : void
      {
         this._wayPoints.push(param1);
      }
      
      public function get wayPoints() : Array
      {
         return this._wayPoints.concat();
      }
      
      public function get duration() : int
      {
         return this._duration;
      }
      
      public function get age() : int
      {
         return getTimer() - this._recievedAt;
      }
      
      public function get timeStamp() : int
      {
         return this._recievedAt;
      }
   }
}
