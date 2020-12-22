package de.freggers.roomdisplay
{
   import de.freggers.animation.MovementWayPoint;
   import de.freggers.audio.SoundConfig;
   import de.freggers.net.data.Path;
   import de.freggers.net.data.Position;
   import de.freggers.net.data.SoundBlock;
   import de.freggers.net.data.WayPoint;
   
   public class Utils
   {
       
      
      public function Utils()
      {
         super();
      }
      
      public static function getMovementWayPoints(param1:Path) : Array
      {
         var _loc5_:WayPoint = null;
         var _loc6_:Position = null;
         var _loc2_:Array = param1.wayPoints;
         var _loc3_:Array = new Array(_loc2_.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_.length)
         {
            _loc5_ = _loc2_[_loc4_];
            _loc6_ = _loc5_.position;
            _loc3_[_loc4_] = new MovementWayPoint(_loc6_.u,_loc6_.v,_loc6_.z,_loc5_.duration);
            _loc4_++;
         }
         return _loc3_;
      }
      
      public static function getSoundConfig(param1:SoundBlock) : SoundConfig
      {
         var _loc2_:SoundConfig = new SoundConfig();
         _loc2_.loopCount = param1.loopCount;
         _loc2_.startPosition = param1.position;
         _loc2_.volume = param1.volume / 100;
         _loc2_.loopMode = param1.playMode;
         _loc2_.maxDelay = param1.maxValue;
         _loc2_.minDelay = param1.minValue;
         if(param1.range >= 0)
         {
            _loc2_.range = param1.range;
         }
         if(param1.fadeInValue > 0)
         {
            _loc2_.fadeInTime = param1.fadeInValue;
         }
         return _loc2_;
      }
   }
}
